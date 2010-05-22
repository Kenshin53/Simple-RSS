//
//  FolderViewController.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 04/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "FolderViewController.h"
#import "MySingleton.h"
#import "ArticleParser.h"
#import "UserDefinedConst.h"
#import "EGODB.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "DetailViewController.h"
#import "DateHelper.h"
#import "GoogleReaderHelper.h"
#import "JSON.h"
#import "RSSParser.h"
#import "NewsViewController.h"

@implementation FolderViewController

@synthesize feeds, folders, feedParser;

@synthesize detailViewController;




- (void)dealloc {
	[feeds release];
	[folders release];
	[feedParser release];
	[networkQueue release];
	self.feedParser = nil;
	[detailViewController release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark Size for popover
// The size the view should be when presented in a popover.
- (CGSize)contentSizeForViewInPopoverView {
    return CGSizeMake(320.0, 600.0);
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	networkQueue = [[ASINetworkQueue alloc] init];
	[networkQueue cancelAllOperations];
	[networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];


	[networkQueue setMaxConcurrentOperationCount:1];
	[networkQueue setDelegate:self];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	UIBarButtonItem *refreshButton =[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(startSyncing)] autorelease];
	
	self.navigationItem.rightBarButtonItem = refreshButton;
	self.title = @"Folder View";
	
	EGODB *db = [[EGODB alloc] init];
	feeds = [[NSMutableArray alloc] initWithArray:[db getFeeds]];
	[db release];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedParsingArticles:) name:kNotificationFinishedParsingArticles object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedListDidChange:) name:kNotificationFeedListDidChanged object:nil];
	

}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Additional Methods

- (void) startSyncing {
	
	NSInteger timestamp = [DateHelper getTimeStampFromNDaysAgo:keepUnreadPeriod ];
	[[MySingleton sharedInstance] setTimeStamp:timestamp];
	
	NSString *urlStr = [[NSString alloc] initWithFormat:kURLSubscriptionFetchingFormat, [DateHelper getTimeStampFromNDaysAgo:0] ];

	NSURL *url = [[NSURL alloc] initWithString:urlStr];
	
	[urlStr release];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *SID = [defaults objectForKey:@"googleSID"];
	
	//	Code for getting TokenID	
	[[MySingleton sharedInstance] setTokenID:[GoogleReaderHelper getTokenID:SID]];
	// Testing of getting all the Unread Item in one request
	NSString *cookie = [[NSString alloc] initWithFormat:@"SID=%@;Domain=.google.com;path=/;expires=1600000000",SID];
//Request for getting list of subscription
	
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	[request addRequestHeader:@"Cookie" value:cookie];
	NSDictionary *info = [[[NSDictionary alloc] initWithObjectsAndKeys:@"Subscription", @"RequestType",nil] autorelease];
	[request setUserInfo:info];
	[networkQueue addOperation:request];


	

//Request for getting Tag List	
	request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:kURLGetTagList]] autorelease];
	[request addRequestHeader:@"Cookie" value:cookie];
	info = [[[NSDictionary alloc] initWithObjectsAndKeys:@"TagList", @"RequestType",nil] autorelease];
	[request setUserInfo:info];
	[networkQueue addOperation:request];
	
//Request for getting Unread Items Id 
	request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:
													[NSString stringWithFormat:kURLgetUnreadItemIDsFormat, timestamp]]] autorelease];
	NSLog(@"Get Unread URL: %@",[NSString stringWithFormat:kURLgetUnreadItemIDsFormat, timestamp]);
	[request addRequestHeader:@"Cookie" value:cookie];
	info = [[[NSDictionary alloc] initWithObjectsAndKeys:@"UnreadItemsID", @"RequestType",nil] autorelease];
	[request setUserInfo:info];
	[networkQueue addOperation:request];	
	
	
	[networkQueue go];
	
	[url release];
	[cookie release];
	
	
}


- (void)imageFetchComplete:(ASIHTTPRequest *)request
{
	NSLog(@"Request Type: ------------ %@ ------------",[[request userInfo] objectForKey:@"RequestType"]);

	if ([[[request userInfo] objectForKey:@"RequestType"] isEqualToString:@"Subscription"]) {
		
		NSLog(@"Calling function to process Subscription parsing....");
		[RSSParser processSubscription:[request responseString] ];
	}else 	if ([[[request userInfo] objectForKey:@"RequestType"] isEqualToString:@"TagList"]) {
		
		NSLog(@"Calling function to process Tag List parsing....");
	}else 	if ([[[request userInfo] objectForKey:@"RequestType"] isEqualToString:@"UnreadItemsID"]) {
		[RSSParser processUnreadItemIDs:[request responseString] withNetworkQueue:networkQueue ];
		NSLog(@"Calling function to process Unread Item ID parsing....");
	}else if ([[[request userInfo] objectForKey:@"RequestType"] isEqualToString:@"POSTUnreadIDs"]) {
		
		NSLog(@"Get Respond from POST request : %d byte", [[request responseString] length]);
		[RSSParser addNewsItemsToDatabase: [request responseString]];
	}else {
	
	
		NSLog(@"Calling something else...");
	}
	NSLog(@"Downloaded bytes: %d", [[request responseString] length]);
		
	
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (feeds != nil) {
		return [feeds count];
	}
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] title];
	
    // Set up the cell...
//	cell.textLabel.text = [[feeds objectAtIndex:[indexPath.row]] objectForKey:@"count"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
    // [self.navigationController pushViewController:anotherViewController];
    // [anotherViewController release];
	  //detailViewController.detailItem = [NSString stringWithFormat:@"Row %d", indexPath.row];
	NewsViewController *newsVC = [[NewsViewController alloc] initWithStyle:UITableViewStylePlain];
	[newsVC setParentFeed:[feeds objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:newsVC 	 animated:YES];
	newsVC.detailVC = detailViewController;
	[newsVC release];
}



#pragma mark -
#pragma mark <FeedParserDelegate> Methods

#pragma mark -
#pragma mark Notification implementation

- (void) finishedParsingArticles:(NSNotification *) notification {
	NSLog(@"Running in %s at Line %d",__FUNCTION__, __LINE__ );
}

- (void) feedListDidChange:(NSNotification *) notification {
	NSLog(@"Feed List Did changed");
	EGODB *db = [[EGODB alloc] init];
	[feeds removeAllObjects];
	[feeds addObjectsFromArray:[db getFeeds]];
	[self.tableView reloadData];
	[db release];
}

@end

//- (void) parserDidEndParsingData:( FeedParser *)parser {
//	if ([parser class] == [FeedParser class]) {
//		if ([feeds count] != [parser.parsedFeeds count]) {
//			[feeds removeAllObjects];
//			NSLog(@"Numbers of feeds loaded: %d",[parser.parsedFeeds count]);
//			feeds = parser.parsedFeeds;
//			[self.tableView reloadData];
//		}
//		
//		
//		ArticleParser *articleParser = [[ArticleParser alloc] init];
//		articleParser.delegate = self;
//		[articleParser start];
//	} else if ([parser class] == [ArticleParser class]) {
//		NSLog(@"Ended parsing ID list");
//	} 
//
//	
//	
//	
//									
//	
//	NSLog(@"Finished Parsing");
//}


