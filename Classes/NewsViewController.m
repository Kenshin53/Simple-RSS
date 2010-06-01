//
//  NewsViewController.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 5/22/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "NewsViewController.h"
#import "EGODB.h"
#import "NewsItem.h"
#import "DetailViewController.h"
#import "Group.h"
#import "UserDefinedConst.h"
#import "NewsCell.h"
#import "MySingleton.h"
#import "MyHTMLStripper.h"
@implementation NewsViewController
@synthesize newsList, detailVC, parentFolder, tmpCell,sectionsList;

#pragma mark -
#pragma mark View lifecycle


- (void) dealloc {
	[newsList release];
	[detailVC release];
	[parentFolder release];
	[sectionsList release]; 
	[super dealloc];
}

- (CGSize)contentSizeForViewInPopoverView {
    return CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
/*	EGODB *db = [[EGODB alloc] init];

	if (parentFolder != nil) {
		newsList = [[NSMutableArray alloc] initWithArray:[db getNewsItemsWithGroupID:[parentFolder groupID]]];
	}
	[db release];
	
*/	

	
	self.tableView.rowHeight = 100;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsItemAdded:) name:kNotificationNewsItemAdded object:nil];
}




/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	
	
    return [[parentFolder feedsList] count];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// The header for the section is the region name -- get this from the region at the section index.

	
	return [[[parentFolder feedsList] objectAtIndex:section] title];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
/*	Feed *aFeed = [[[[parentFolder feedsList] objectAtIndex:section] newsItems] count];
	NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"feedID == %@",[aFeed feedID]];
	NSArray *filteredArray = [newsList filteredArrayUsingPredicate:myPredicate];
*/
	return	[[[[parentFolder feedsList] objectAtIndex:section] newsItems] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

	
	static NSString *CellIdentifier = @"NewsCell";
	
	NewsCell *cell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
		cell = tmpCell;
		self.tmpCell = nil;
	}

/*
	Feed *aFeed = [[parentFolder feedsDict] objectForKey:[[[parentFolder feedsDict] allKeys] objectAtIndex:indexPath.section]];
	NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"feedID == %@",[aFeed feedID]];
	NSArray *filteredArray = [newsList filteredArrayUsingPredicate:myPredicate];	
	NewsItem *aNews = [filteredArray objectAtIndex:indexPath.row]; 
*/
	NewsItem *aNews = [[[[parentFolder feedsList] objectAtIndex:indexPath.section] newsItems] objectAtIndex:indexPath.row];
/*	TTMarkupStripper *markup = [[TTMarkupStripper alloc] init];
	int index = [[aNews summary] length] > 200?200:[[aNews summary] length];
	NSString *strippedContent = [markup parse:[aNews summary]];
	[markup release];
*/
	MyHTMLStripper *stripper = [[MyHTMLStripper alloc] init];
	//NSString *summaryContent = [[NSString alloc] initWithFormat:@"<x> %@</x>",[aNews summary] ];
	NSString *strippedContent = [stripper parse:[aNews summary]];
	[stripper release];
//	[summaryContent release];
	cell.newsTitleLabel.text = [aNews title];
	cell.feedTitleLabel.text = [[[parentFolder feedsDict] objectForKey:[aNews feedID]] title];
	cell.briefContentLabel.text = strippedContent;
	
/*	if (strippedContent != nil && [strippedContent length]> 0) {
		index = [strippedContent length] > 100? 100:[strippedContent length];
			cell.briefContentLabel.text = [strippedContent substringToIndex:index];
	}else {
		cell.briefContentLabel.text = [[aNews summary] substringToIndex:index];
		NSLog(@"----------------HTML---------------");
		NSLog(@"%@",[aNews summary]);
		NSLog(@"-----------END OF HTML------------");
	}
*/

	NSString *faviconPath = [[[MySingleton sharedInstance] faviconPaths] objectForKey:[aNews feedID]];
	if (faviconPath != nil && ![faviconPath isEqualToString:@"None"]) {
		NSLog(@"File Path %@", faviconPath);
		cell.favIconView.image = [UIImage imageWithContentsOfFile:faviconPath];
	}else {
		cell.favIconView.image = [UIImage imageNamed:@"Feed.png"];
	}

	return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NewsItem *aNews = [[[[parentFolder feedsList] objectAtIndex:indexPath.section] newsItems] objectAtIndex:indexPath.row];

	
	NSString *htmlWrapper = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SimpleRSSTest" ofType:@"html"]];

	NSLog(@"Content: %@", [aNews summary]);
	NSString *formattedContent = [[NSString alloc] initWithFormat:htmlWrapper, 
									[aNews link],
									[aNews title],
									[aNews summary]];
	
	
	[detailVC.webview loadHTMLString:formattedContent baseURL:nil];
	
	[[NSURLCache sharedURLCache] removeAllCachedResponses];

	[formattedContent release];
	[htmlWrapper release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
#warning may have to remove observer
}

- (void) newsItemAdded:(NSNotification *) notification {
	NewsItem *aNewsItem = [notification object];

	NSMutableArray *paths = [[[NSMutableArray alloc] init] autorelease];
	if ([[parentFolder feedsDict] objectForKey:[aNewsItem feedID]] != nil){
		[newsList insertObject:aNewsItem atIndex:0];
		int count = [[[[parentFolder feedsDict] objectForKey:[aNewsItem feedID]] unreadCount] intValue];
		count++;
		[[[parentFolder feedsDict] objectForKey:[aNewsItem feedID]] setUnreadCount:[NSNumber numberWithInt:count]];
		
		NSLog(@"adding new object to newslist");
		NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
		[paths addObject:path];
	}
	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationNone];
	[self.tableView endUpdates];

	

	
}



@end

