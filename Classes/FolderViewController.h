//
//  FolderViewController.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 04/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedParser.h"
#import "ArticleParser.h"
#import "ASIHTTPRequest.h"
#import "FolderCell.h"
@class ArticleParser, DetailViewController, FeedParser, ASINetworkQueue;
@interface FolderViewController : UITableViewController <FeedParserDelegate, ArticleParserDelegate, ASIHTTPRequestDelegate>{
	
	FolderCell *tmpCell;
	
	ASINetworkQueue *networkQueue;
	
	NSMutableArray *folders;
	NSMutableArray *feeds;
	FeedParser *feedParser;
	DetailViewController *detailViewController;
	UIProgressView *myProgressView;
	
}

@property (nonatomic, assign) IBOutlet FolderCell *tmpCell;
@property (retain, nonatomic) NSMutableArray *folders;
@property (retain, nonatomic) NSMutableArray *feeds;
@property (retain, nonatomic) FeedParser *feedParser;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) UIProgressView *myProgressView;

- (void) startSyncing; //Start syncing with Google Reader service 


@end
