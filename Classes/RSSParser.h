//
//  RSSParser.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 13/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASINetworkQueue,ASIHTTPRequest;

@interface RSSParser : NSObject {
	
}

+ (void) processSubscription:(NSString *)jsonString;
+ (void) processTagList: (NSString *) jsonString;
+ (void) processUnreadItemIDs: (NSString *) jsonString withNetworkQueue: (ASINetworkQueue *)queue;
+ (void) addNewsItemsToDatabase: (NSString *) jsonString;
+ (NSURL *) getFaviconURL:(NSString *)feedID;
+ (void) addFaviconRequests: (ASINetworkQueue *)queue;
+ (void) processDownloadedFavicon:(ASIHTTPRequest *)request ;
@end
