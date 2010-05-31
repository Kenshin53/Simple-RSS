//
//  Group.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 5/26/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Group : NSObject {
	NSString *groupID;
	NSString *title;
	NSDictionary *feedsDict;
	NSInteger unreadCount;
	NSInteger starredCount;
}

@property (nonatomic, retain) NSString *groupID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDictionary *feedsDict;
@property (nonatomic) NSInteger unreadCount;
@property (nonatomic) NSInteger starredCount;

-(id) initWithGroupID:(NSString *)Id;
@end
