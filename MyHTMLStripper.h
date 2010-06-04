//
//  MyHTMLStripper.h
//  XMLBooks
//
//  Created by Manh Tuan Cao on 6/1/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface MyHTMLStripper : NSObject {
	NSMutableString *text;
}

- (NSString *) parse: (NSString *)htmlString;
- (void) traverseElement:(TBXMLElement *)element; 
@end
