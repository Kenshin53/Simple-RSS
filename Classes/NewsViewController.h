//
//  NewsViewController.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 5/22/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailViewController, Feed, Group, NewsCell;

@interface NewsViewController : UITableViewController {
	NewsCell *tmpCell;
	Group *parentFolder;
	
	NSMutableArray *newsList;
	DetailViewController *detailVC;
	NSMutableArray *sectionsList;
	NSArray *feedsList;
}

@property (nonatomic, assign) IBOutlet NewsCell *tmpCell;
@property (nonatomic, retain) NSMutableArray *sectionsList;
@property (nonatomic, retain) NSMutableArray *newsList;
@property (nonatomic, retain) DetailViewController *detailVC;
@property (nonatomic, retain) Group *parentFolder;
@end
