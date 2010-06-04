//
//  MyHTMLStripper.m
//  XMLBooks
//
//  Created by Manh Tuan Cao on 6/1/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "MyHTMLStripper.h"


@implementation MyHTMLStripper

- (NSString *) parse: (NSString *)htmlString {
	text = [[NSMutableString alloc] initWithString:@""];
	TBXML *parser = [[TBXML alloc] initWithXMLString:[NSString stringWithFormat:@"<x>%@</x>", htmlString]];
	TBXMLElement *root = parser.rootXMLElement;
	if (root != nil) {
		[self traverseElement:root];		
	}
	[parser release];
	return text;
	
}

- (void) traverseElement:(TBXMLElement *)element {
	
	do {
//		NSLog(@"%@", [TBXML textForElement:element]);
		[text appendString:[TBXML textForElement:element]];
		
		if (element->firstChild) [self traverseElement:element->firstChild];
		if ([[TBXML elementName:element] isEqualToString:@"a"]) {
			if ([[TBXML textForElement:element] length]>0) {
				[text appendString:@" "];	
			}

		}
	} while ((element = element->nextSibling));  
}

@end
