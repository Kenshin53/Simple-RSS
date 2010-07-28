//
//  NewsListVC.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 6/11/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "NewsListVC.h"
#import "NewsCompositeCell.h"
#import "NewsItem.h"
#import "MyHTMLStripper.h"
#import "DateHelper.h"
#import "MySingleton.h"
#import "UserDefinedConst.h"
#import "GoogleReaderSync.h"
#import "DetailViewController.h"
#import "Section.h"
@implementation NewsListVC
@synthesize newsList,sectionsList, feedsDict, groupID,detailVC;


- (void)dealloc {
	[newsList release];
	[sectionsList release];
	[feedsDict release];
	[groupID release];
	[detailVC release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		newsList = [[NSMutableArray alloc] initWithCapacity:0];
		sectionsList = [[NSMutableArray alloc] initWithCapacity:0];
	}
	return self;
}


- (CGSize)contentSizeForViewInPopoverView {
    return CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Calculating Section
	_currentRow = 0;
	if ([newsList count] >0) {
		NSString *currentFeedID = [[newsList objectAtIndex:0] feedID];
		int newsCount = 0;
		for (int i = 0; i < [newsList count]-1; i++) {
			newsCount ++;
			if (![currentFeedID isEqualToString:[[newsList objectAtIndex:i+1] feedID]]) {
//				NSDictionary *aSection = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:newsCount],@"count",currentFeedID, @"FeedID", nil];
				Section *aSection = [[Section alloc] init];
				aSection.sectionID = currentFeedID;
				aSection.numberOfRows = newsCount;
				aSection.sectionName = [feedsDict objectForKey:currentFeedID];
				[sectionsList addObject:aSection];
				[aSection release];
				
				currentFeedID = [[newsList objectAtIndex:i+1] feedID];
				newsCount = 0;
			}
			if (i == [newsList count]-2) {
				//NSDictionary *aSection = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:newsCount+1],@"count",currentFeedID,@"FeedID",nil];
				Section *aSection = [[Section alloc] init];
				aSection.sectionID = currentFeedID;
				aSection.sectionName = [feedsDict objectForKey:currentFeedID];
				aSection.numberOfRows = newsCount +1;
				[sectionsList addObject:aSection];
				[aSection release];
			}
			
			
		}
//		for (NSDictionary *aSection  in sectionsList) {
//			NSLog(@"Section - FeedID:%@  Count: %d", [aSection objectForKey:@"FeedID"], [[aSection objectForKey:@"count"] intValue]);
//		}
		
	}
	
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
	//setting header view height
	self.tableView.sectionHeaderHeight = 24.0;
	
	//	self.currentIndex = [[NSIndexPath alloc] init];
	_currentRow =0;
	_currentSection =0;
	
	self.tableView.rowHeight = 100;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsItemAdded:) name:kNotificationNewsItemAdded object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendNextUnreadNews:) name:kNotificationRequestingNextUnreadNews object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadQueueDidFinish:) name:kNotificationDownloadQueueDidFinish object:nil];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	
	
    return [sectionsList count];
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// The header for the section is the region name -- get this from the region at the section index.
	
	return [[sectionsList objectAtIndex:section] sectionName];
	//return [feedsDict objectForKey:[[sectionsList objectAtIndex:section] objectForKey:@"FeedID"]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	/*	Feed *aFeed = [[[[parentFolder feedsList] objectAtIndex:section] newsItems] count];
	 NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"feedID == %@",[aFeed feedID]];
	 NSArray *filteredArray = [newsList filteredArrayUsingPredicate:myPredicate];
	 */
	if ([newsList count] == 0) {
		return 0;
	}
	return [[sectionsList objectAtIndex:section] numberOfRows];
//	return	[[[sectionsList objectAtIndex:section] objectForKey:@"count"] intValue];
}


// Customize the appearance of table view cells.

#pragma mark Header View



//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([newsList count] == 0) {
		return nil;
	}
	
	static NSString *CellIdentifier = @"NewsCell";
	
	
	NewsCompositeCell *cell = (NewsCompositeCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[NewsCompositeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	int currentIndex = 0;
	for (int i = 0; i< indexPath.section; i++) {
//		currentIndex += [[[sectionsList objectAtIndex:i] objectForKey:@"count"] intValue];
		currentIndex += [[sectionsList objectAtIndex:i] numberOfRows];
	}
	currentIndex += indexPath.row;
	NewsItem *aNews = [newsList objectAtIndex:currentIndex];
	
	MyHTMLStripper *stripper = [[MyHTMLStripper alloc] init];
	//NSString *summaryContent = [[NSString alloc] initWithFormat:@"<x> %@</x>",[aNews summary] ];
	NSString *strippedContent = [stripper parse:[aNews summary]];
	
	[stripper release];
	cell.unreadState = [aNews unread];
	cell.newsTitleLabel = [aNews title];
	cell.feedTitleLabel = [feedsDict objectForKey:[aNews feedID]];
	cell.briefContentLabel = strippedContent;
	cell.timeLabel = [DateHelper dateDiff:[aNews published]];
	
	
	NSString *faviconPath = [[[MySingleton sharedInstance] faviconPaths] objectForKey:[aNews feedID]];
	if (faviconPath != nil && ![faviconPath isEqualToString:@"None"]) {
		NSLog(@"File Path %@", faviconPath);
		cell.favIconView = [UIImage imageWithContentsOfFile:faviconPath];
	}else {
		cell.favIconView = [UIImage imageNamed:@"Feed.png"];
	}
	
	
	return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	

	//Set NewsItem at index as Read
	int currentIndex = 0;
	for (int i = 0; i< indexPath.section; i++) {
//		currentIndex += [[[sectionsList objectAtIndex:i] objectForKey:@"count"] intValue];
		currentIndex += [[sectionsList objectAtIndex:i] numberOfRows];
	}
	currentIndex += indexPath.row;
	_currentRow = currentIndex;
	NewsItem *aNews = [newsList objectAtIndex:currentIndex];

	if ([ aNews unread]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidMarkNewsAsRead object:[self groupID]];		
	}
	
	[[newsList objectAtIndex:currentIndex] setUnread:NO];
	
	//	NewsItem *aNews = [[[[parentFolder feedsList] objectAtIndex:indexPath.section] newsItems] objectAtIndex:indexPath.row];
	
	
	[GoogleReaderSync setNewsAsRead:[aNews newsID]];
	
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationFade];
	
//	NSString *htmlWrapper = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SimpleRSSTest" ofType:@"html"]];
	NSString *htmlWrapper = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ReederWrapper" ofType:@"html"]];
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
 
	//	self.feedsList = nil;

}

#pragma mark -
#pragma mark Notification Respond Methods

-(void) downloadQueueDidFinish:(NSNotification *)notification {
	[self.tableView reloadData];
}

- (void) newsItemAdded:(NSNotification *) notification {
	NewsItem *aNewsItem = [notification object];
	
	NSMutableArray *paths = [[[NSMutableArray alloc] init] autorelease];
	int rowForInsert =0, section =0;
	BOOL foundFeed = NO;

	for (section = 0; section < [sectionsList count]; section++) {

		//if ([[[sectionsList objectAtIndex:section] objectForKey:@"FeedID"] isEqualToString:[aNewsItem feedID]]) {
		if ([[[sectionsList objectAtIndex:section] sectionID] isEqualToString:[aNewsItem feedID]]) {
			
		
			foundFeed = YES;
			int count = [[sectionsList objectAtIndex:section] numberOfRows];
	 		count ++;
			
			[[sectionsList objectAtIndex:section] setNumberOfRows:count];
			[newsList insertObject:aNewsItem atIndex:rowForInsert];

			break;
		}

		rowForInsert += [[sectionsList objectAtIndex:section] numberOfRows];
	}
	

	if (!foundFeed && [feedsDict objectForKey:[aNewsItem feedID]] != nil) {

/*		NSDictionary *aSection = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:1], @"count", [aNewsItem feedID], @"FeedID", nil];
		[sectionsList insertObject:aSection atIndex:0];
*/
		Section *aSection = [[Section alloc] init];
		aSection.numberOfRows = 1;
		aSection.sectionID = [aNewsItem feedID];
		aSection.sectionName = [feedsDict objectForKey:[aNewsItem feedID]];
//		[sectionsList insertObject:aSection atIndex:0];
		[sectionsList addObject:aSection];
		[aSection release];
		
	//	[self.tableView beginUpdates];
		//[self.tableView insertSections:[NSIndexSet indexSetWithIndex:[sectionsList count]-1] withRowAnimation:UITableViewRowAnimationNone];
	//	[self.tableView endUpdates];
		foundFeed = YES;
		[newsList addObject:aNewsItem];
		section = [sectionsList count] -1;
	}
	
	if (foundFeed) {
		NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:section ];
		[paths addObject:path];
//		[self.tableView beginUpdates];
	//	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationNone];
//		[self.tableView endUpdates]; 
	}
	
	

	NSLog(@"News Added");
	
	
}

- (void) sendNextUnreadNews: (NSNotification *)notification {
	NSLog(@"Send Unread News");
	
	NewsItem *aNews = [self getNextUnreadNewsItem];
	if (aNews != nil) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidGetNextUnreadNews object:aNews];
	}
	
}

-(NewsItem *) getNextUnreadNewsItem {
	//return object at Index 0.0 if currentIndex is not initialized
	BOOL reachLastUnreadNews = YES;
	/*for (section = _currentSection; section < [sectionsList count]; section++) {
		Feed *aFeed = [[parentFolder feedsList] objectAtIndex:section];
		if (section == _currentSection) {
			startRow = _currentRow;
		}else {
			startRow = 0;
		}
		
		for (row = startRow; row < [[aFeed newsItems] count]; row++ ) {
			if ([[[aFeed newsItems] objectAtIndex:row] unread]){
				reachLastUnreadNews = NO;
				_currentRow = row;
				_currentSection = section;
				[GoogleReaderSync setNewsAsRead:[[[aFeed newsItems] objectAtIndex:row] newsID]];
				[[[[[parentFolder feedsList] objectAtIndex:section] newsItems] objectAtIndex:row] setUnread:NO];
				NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
				
				[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationNone];
				
				//Send out a notification that contains groupID of the folder that contains the news	
				[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidMarkNewsAsRead object:[parentFolder groupID]];
				return [[[[parentFolder feedsList] objectAtIndex:section] newsItems] objectAtIndex:row];
			}
		}
	}*/
	for (int i = _currentRow; i < [newsList count]; i++) {
		if ([[newsList objectAtIndex:i] unread]) {
			reachLastUnreadNews = NO;
			_currentRow = i;
			[GoogleReaderSync setNewsAsRead:[[newsList objectAtIndex:i] newsID]];
			[[newsList objectAtIndex:i] setUnread:NO];
			
			//Calculating the Section/Row of the current news
			int section =0;
			int row = 0, k= i;
			while (k >= [[sectionsList objectAtIndex:section] numberOfRows]){
				k -= [[sectionsList objectAtIndex:section] numberOfRows];
				section ++;
			}
			row = k;
			
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
			
			[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationNone];
			
			return [newsList objectAtIndex:i];
		}
	}
	if (reachLastUnreadNews){
		return [newsList objectAtIndex:_currentRow];
	}
	return nil;
}








@end
