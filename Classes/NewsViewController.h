//
//  NewsViewController.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 5/22/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailViewController, Feed, Group, NewsCell, NewsItem;



@interface NewsViewController : UITableViewController {

	
	NewsCell *tmpCell;
	Group *parentFolder;
	NSIndexPath *currentIndex;
	NSMutableArray *newsList;
	DetailViewController *detailVC;
	NSMutableArray *sectionsList;
	NSArray *feedsList;
	@private
	int _currentRow;
	int _currentSection;
}

@property (nonatomic, retain) NSIndexPath *currentIndex;
@property (nonatomic, assign) IBOutlet NewsCell *tmpCell;
@property (nonatomic, retain) NSMutableArray *sectionsList;
@property (nonatomic, retain) NSMutableArray *newsList;
@property (nonatomic, retain) DetailViewController *detailVC;
@property (nonatomic, retain) Group *parentFolder;

-(NewsItem *) getNextUnreadNewsItem;
- (void) sendNextUnreadNews: (NSNotification *)notification;
@end
