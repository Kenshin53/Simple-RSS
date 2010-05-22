//
//  RSSParser.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 13/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASINetworkQueue;

@interface RSSParser : NSObject {
	
}

+ (void) processSubscription:(NSString *)jsonString;
+ (void) processUnreadItemIDs: (NSString *) jsonString withNetworkQueue: (ASINetworkQueue *)queue;
+ (void) addNewsItemsToDatabase: (NSString *) jsonString;
@end
