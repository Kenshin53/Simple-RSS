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
@class NewsItem, Group;
@interface EGODB : NSObject {

	EGODatabase *db;
}
- (BOOL) addFeed:(Feed *) aFeed;
- (NSArray *) getFeeds ;
- (NSArray *) getUnreadFeeds;
- (NSArray *) getFeedsWithGroupID:(NSString *)groupID ;
- (Group *) getFullGroupWithGroupID:(NSString *)groupID;

- (NSMutableSet *) getArticleIDSinceTimeStamp: (NSInteger) days;	
- (NSMutableSet *) getFeedID;
- (BOOL) deleteFeedWithFeedID:(NSString *)feedID;
- (BOOL) addNewsItem: (NewsItem *) aNewsItem;
- (NSArray *) getNewsItemsWithFeedID: (NSString *) feedID;
- (NSArray *) getUnreadNewsItemsWithFeedID: (NSString *) feedID;

- (BOOL) addGroup:(NSString *)groupId withTitle:(NSString *)title;
- (BOOL) addCategoryAndFeed:(NSString *) groupID feedID:(NSString *)feedID;

- (Group *) getGroupWithGroupID:(NSString *)groupID title:(NSString *) title;
- (NSMutableArray *) getGroups;
- (NSArray *) getNewsItemsWithGroupID: (NSString *)groupID;
+ (NSNumber *) hexString2Number: (NSString *)hex;
- (BOOL) setNewsAsRead:(NSString *) newsID;

@end
