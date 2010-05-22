//
//  EGODB.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 11/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGODatabase.h"
#import "Feed.h"
@class NewsItem;
@interface EGODB : NSObject {

	EGODatabase *db;
}
- (BOOL) addFeed:(Feed *) aFeed;
- (NSArray *) getFeeds ;
- (NSMutableSet *) getArticleIDSinceTimeStamp: (NSInteger) days;	
- (NSMutableSet *) getFeedID;
- (BOOL) deleteFeedWithFeedID:(NSString *)feedID;
- (BOOL) addNewsItem: (NewsItem *) aNewsItem;
- (NSArray *) getNewsItemsWithFeedID: (NSString *) feedID;

+ (NSNumber *) hexString2Number: (NSString *)hex;
@end
