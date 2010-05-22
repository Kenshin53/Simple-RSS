//
//  NewsItem.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 5/20/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewsItem : NSObject {
	NSString *newsID;
	NSString *feedID;
	NSString *title;
	NSDate *published;
	NSString *link;
	NSString *summary;
	NSString *author;
	BOOL unread;
	BOOL starred;
}

@property (retain, nonatomic) NSString *newsID;
@property (retain, nonatomic) NSString *feedID;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *summary;
@property (retain, nonatomic) NSString *link;
@property (retain, nonatomic) NSString *author;

@property (retain, nonatomic) NSDate *published;

@property (nonatomic) BOOL unread;
@property (nonatomic) BOOL starred;

-(id) initWithDicitonary:(NSDictionary *) aNewsItem;

@end
