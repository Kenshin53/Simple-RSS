//
//  FolderViewController.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 04/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedParser.h"
#import "DetailViewController.h"

@interface FolderViewController : UITableViewController <FeedParserDelegate>{
	NSMutableArray *folders;
	NSMutableArray *feeds;
	FeedParser *feedParser;
	DetailViewController *detailViewController;
}

@property (retain, nonatomic) NSMutableArray *folders;
@property (retain, nonatomic) NSMutableArray *feeds;
@property (retain, nonatomic) FeedParser *feedParser;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

- (void) startSyncing; //Start syncing with Google Reader service 
@end
