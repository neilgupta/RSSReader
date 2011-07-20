//
//  main.m
//  RSSReader
//
//  Created by Neil Gupta.
//  Copyright 2011 Neil Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyXMLParserDelegate.h"

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    // Read dictionary from settings.plist and get Feeds array
    NSDictionary *settings = [[[NSDictionary alloc] initWithContentsOfFile:@"settings.plist"] objectForKey:@"Root"];
    NSArray *feeds = [settings objectForKey:@"Feeds"];
    
    //loop over Feeds array
    int numFeeds = 0; // keep track of number of feeds processed so far
    for (NSDictionary* feed in feeds) {
        numFeeds++;
        NSLog(@"Feed %d: %@",numFeeds, [feed valueForKey:@"FeedURL"]);
        
        if([[feed objectForKey:@"Enabled"] boolValue]) {
            // parse XML for each URL in feeds array
            NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:[feed valueForKey:@"FeedURL"]]];
            MyXMLParserDelegate *delegate = [[MyXMLParserDelegate alloc] initWithMaxStories:[[feed valueForKey:@"MaxNewsItems"] intValue] maxDescription:[[feed valueForKey:@"DescMax"] intValue]];
            [parser setDelegate: delegate];
            [parser parse];
            [delegate release];
            [parser release];
        }
        else
            NSLog(@"Parsing disabled.");
    }
    
    [settings release];
    [pool drain];
    return 0;
}

