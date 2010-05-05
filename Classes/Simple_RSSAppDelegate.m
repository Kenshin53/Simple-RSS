//
//  Simple_RSSAppDelegate.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 20/04/2010.
//  Copyright University of Sunderland 2010. All rights reserved.
//

#import "Simple_RSSAppDelegate.h"


#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AuthViewController.h"
#import "FolderViewController.h"

@implementation Simple_RSSAppDelegate

@synthesize window, splitViewController, folderViewController, detailViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    
	folderViewController= [[FolderViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:folderViewController];
    
    detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
    folderViewController.detailViewController = detailViewController;
    
    splitViewController = [[UISplitViewController alloc] init];
    splitViewController.viewControllers = [NSArray arrayWithObjects:navigationController, detailViewController, nil];
	splitViewController.delegate = detailViewController;
    
	[navigationController  release];
	
    // Add the split view controller's view to the window and display.
    [window addSubview:splitViewController.view];
    [self authenticate];
	//AuthViewController *login = [[AuthViewController alloc] initWithNibName:@"AuthViewController" bundle:nil];
	//[window addSubview:login.view];
	[window makeKeyAndVisible];
    
    return YES;
}

- (void) authenticate {
	
	//Test code
	
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	//[settings setBool:NO forKey:@"authenticated"];
	//End test code
	
	
	
	
	//NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	if ([settings boolForKey:@"authenticated"]) {
		NSLog(@"Authenticated!");
		NSLog(@"Google SID: %@",[settings objectForKey:@"googleSID"]);
		NSLog(@"Token ID: %@",[settings objectForKey:@"tokenID"]);
	} else{
							   
		AuthViewController *loginVC = [[AuthViewController alloc] initWithNibName:@"AuthViewController" bundle:nil];
		loginVC.modalPresentationStyle = UIModalPresentationFormSheet;
		loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		loginVC.delegate = self;
		[splitViewController presentModalViewController:loginVC animated:YES];
		[loginVC release];
	}
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Save data if appropriate
}
#pragma mark AuthenticationProtocol implementation

- (void)AuthenticationSucceeded:(BOOL)succeeded {
	if (succeeded) {
		[splitViewController dismissModalViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [splitViewController release];
    [window release];
    [super dealloc];
}


@end

