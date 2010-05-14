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
@implementation FolderViewController

@synthesize feeds, folders, feedParser;

@synthesize detailViewController;




- (void)dealloc {
	[feeds release];
	[folders release];
	[feedParser release];
	
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

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	UIBarButtonItem *refreshButton =[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(startSyncing)] autorelease];
	
	self.navigationItem.rightBarButtonItem = refreshButton;
	self.title = @"Folder View";
	
	EGODB *db = [[EGODB alloc] init];
	feeds = [[NSMutableArray alloc] initWithArray:[db getFeeds]];
	[db release];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedParsingArticles:) name:kNotificationFinishedParsingArticles object:nil];


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
	//UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Check" message:@"Checking " delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease];
	//[alert show];
	
	NSLog(@"%s Google ID: %@", __FUNCTION__, [[MySingleton sharedInstance] googleSID]);
	
	feedParser = [[FeedParser alloc] init] ;
	feedParser.delegate = self; 
	[feedParser start];
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
	  detailViewController.detailItem = [NSString stringWithFormat:@"Row %d", indexPath.row];
}



#pragma mark -
#pragma mark <FeedParserDelegate> Methods

- (void) parserDidEndParsingData:( FeedParser *)parser {
	if ([parser class] == [FeedParser class]) {
		if ([feeds count] != [parser.parsedFeeds count]) {
			[feeds removeAllObjects];
			NSLog(@"Numbers of feeds loaded: %d",[parser.parsedFeeds count]);
			feeds = parser.parsedFeeds;
			[self.tableView reloadData];
		}
		
		
		ArticleParser *articleParser = [[ArticleParser alloc] init];
		articleParser.delegate = self;
		[articleParser start];
	} else if ([parser class] == [ArticleParser class]) {
		NSLog(@"Ended parsing ID list");
	} 

	
	
	
									
	
	NSLog(@"Finished Parsing");
}
#pragma mark -
#pragma mark Notification implementation

- (void) finishedParsingArticles:(NSNotification *) notification {
	NSLog(@"Running in %s at Line %d",__FUNCTION__, __LINE__ );
}

@end

