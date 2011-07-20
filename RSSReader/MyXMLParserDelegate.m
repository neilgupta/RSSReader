//
//  MyXMLParserDelegate.m
//  RSSReader
//
//  Created by Neil Gupta.
//  Copyright 2011 Neil Gupta. All rights reserved.
//

#import "MyXMLParserDelegate.h"


@implementation MyXMLParserDelegate

- (id)initWithMaxStories:(int)aMax maxDescription:(int)bMax
{
    self = [super init];
    if (self) {
        output = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] initWithCapacity:bMax];
        max = aMax;
        descMax = bMax;
        total = 0;
    }
    
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
                                        namespaceURI:(NSString *)namespaceURI 
                                       qualifiedName:(NSString *)qName 
                                          attributes:(NSDictionary *)attributeDict {
    if(qName)
        elementName = qName;
    if([[NSString stringWithString:elementName] isEqualToString:@"title"]) {
        // it doesn't matter if it's RSS or Atom, only the title elements are looked at
        if (total == 0) {
            isTitle = YES;  // we are inside the title element for the feed
            [output appendString:@"Title of feed: "];
        }
        else if(total <= max) {
            // stop before hitting the max number of articles
            isTitle = YES;  // we are inside a title element for a story
            [output appendString:@"\n\n- "];
        }
        total++;
    }
    else if([[NSString stringWithString:elementName] isEqualToString:@"description"] || 
       [[NSString stringWithString:elementName] isEqualToString:@"content"]) {
        // checks for either description (RSS) or content (Atom) and outputs excerpt
        if(total > 1 && total <= max + 1) {
            isContent = YES;    // we are inside a content element for a story
            [output appendString:@"\n"];
        }
    }
    else if([[NSString stringWithString:elementName] isEqualToString:@"pubDate"] || 
            [[NSString stringWithString:elementName] isEqualToString:@"published"]) {
        // checks for either pubDate (RSS) or published (Atom) and outputs unformatted date
        if(total > 1 && total <= max + 1) {
            isPubDate = YES;    // we are inside a publication date element for a story
            [output appendString:@"\nPublished on "];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
                                      namespaceURI:(NSString *)namespaceURI 
                                     qualifiedName:(NSString *)qName {
    if(isContent)
        [output appendFormat:@"%@...",description]; // adding ... after description since it is just an excerpt
    // element ended, so obviously can't be inside any of these elements. Set all flags to NO.
    isTitle = NO;
    isContent = NO;
    isPubDate = NO;
    // release old string and allocate new one for new description
    [description release];
    description = [[NSMutableString alloc] initWithCapacity:descMax];
}

// outputs characters from feed depending on rules specified
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (isTitle) 
        [output appendFormat:@"%@", string]; // append title to output
    else if (isContent) {
        // truncate text to maximum description length
        NSUInteger diff = descMax - [description length];
        if (diff > [string length])
            diff = [string length];
        [description appendFormat:@"%@", [string substringToIndex:diff]]; // append truncated description to output
    }
    else if (isPubDate)
        [output appendFormat:@"%@", string]; // append timestamp to output as-is
}

// if content is wrapped in CDATA, it is parsed into string and passed to foundCharacters method above for output
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    NSString *data = [[NSString alloc] initWithData:CDATABlock encoding:NSASCIIStringEncoding];
    [self parser:parser foundCharacters:data];
    [data release];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    // subtract 1 from total to account for title of feed and print everything to console
	NSLog(@"Parsing enabled and completed.\nFound %d stories; limiting to the most recent %d.\n%@\n\n", (total - 1), max, output);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // parsing error occurred, so print error
    NSLog(@"Parse error occurred: %@\nThe feed may be down or invalid.",[parseError localizedDescription]);
}

- (void)dealloc
{
    [description release];
    [output release];
    [super dealloc];
}

@end
