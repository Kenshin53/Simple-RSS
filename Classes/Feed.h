//
//  Feed.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 08/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Feed : NSObject {
	NSString *feedID;
	NSString *title;
	NSString *originalURL;
	NSNumber *unreadCount;
	NSDate *lastUpdate;
	NSMutableArray *newsItems;
}

@property (nonatomic, retain) NSString *feedID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *originalURL;
@property (nonatomic, retain) NSNumber *unreadCount;
@property (nonatomic, retain) NSDate *lastUpdate;
@property (nonatomic, retain) NSMutableArray *newsItems;
- (id) initWithDictionary:(NSDictionary *)aFeed;
@end
