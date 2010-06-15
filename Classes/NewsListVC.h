//
//  NewsListVC.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 6/11/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController, NewsItem;
@interface NewsListVC : UITableViewController {


	NSMutableArray *newsList;
	NSMutableArray *sectionsList;
	NSDictionary* feedsDict;
	NSString *groupID;
	DetailViewController *detailVC;
@private
	int _currentRow;
	int _currentSection;
	

}

@property (nonatomic, retain) 	DetailViewController *detailVC;
@property (nonatomic, retain) NSMutableArray *newsList;
@property (nonatomic, retain) NSMutableArray *sectionsList;
@property (nonatomic, retain) NSDictionary *feedsDict;
@property (nonatomic, retain) NSString *groupID;


-(NewsItem *) getNextUnreadNewsItem;
- (void) sendNextUnreadNews: (NSNotification *)notification;

@end
