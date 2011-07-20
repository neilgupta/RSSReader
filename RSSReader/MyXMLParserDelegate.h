//
//  MyXMLParserDelegate.h
//  RSSReader
//
//  Created by Neil Gupta.
//  Copyright 2011 Neil Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyXMLParserDelegate : NSObject <NSXMLParserDelegate> {
	NSMutableString	*output;        // keep track of output
    NSMutableString	*description;   // keep track story description
    BOOL            isTitle;        // are we looking at a title tag?
    BOOL            isContent;      // are we looking at the story content?
    BOOL            isPubDate;      // are we looking at the publication date?
    int             max;            // max num of stories we will output
    int             descMax;        // max length of excerpt
    int             total;          // total number of stories seen
}
- (id)initWithMaxStories:(int)aMax maxDescription:(int)bMax;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock;
- (void)parserDidEndDocument:(NSXMLParser *)parser;
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;

@end