//
//  NewsViewController.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 5/22/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailViewController, Feed;

@interface NewsViewController : UITableViewController {
	Feed *parentFeed;
	NSMutableArray *newsList;
	DetailViewController *detailVC;
}

@property (nonatomic, retain) NSMutableArray *newsList;
@property (nonatomic, retain) DetailViewController *detailVC;
@property (nonatomic, retain) Feed *parentFeed;
@end
