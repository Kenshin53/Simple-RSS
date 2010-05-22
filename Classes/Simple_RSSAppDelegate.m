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
#import "Experiment.h"
#import "MySingleton.h"

//The 
@interface Simple_RSSAppDelegate ()
- (void) copySQLiteDBToDocumentDirectory;

@end


@implementation Simple_RSSAppDelegate

@synthesize window, splitViewController, folderViewController, detailViewController;

- (void)dealloc {
    [splitViewController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	

	//Code for copying file from the Bundle to Document directory
	
	[self copySQLiteDBToDocumentDirectory];
	
	
	
	[self testCode];
	
	
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
		[[MySingleton sharedInstance] setGoogleSID:[settings objectForKey:@"googleSID"]];
		//[[MySingleton sharedInstance] setTokenID:[settings objectForKey:@"tokenID"]];
		
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
		NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
		[[MySingleton sharedInstance] setGoogleSID:[settings objectForKey:@"googleSID"]];
	}
}

#pragma mark -
#pragma mark Memory management

//The purpose of this methods is to return the Value of the ID which is encoded in Hex 
//The Value is in fact is an signed long long (64-bit integer)
//This method is to support the syncing process in which 
#pragma mark -
#pragma mark Supporting Codes

- (void) copySQLiteDBToDocumentDirectory {
	NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SimpleRSS.sqlite"];
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if (![fileManager fileExistsAtPath:filePath]) {
		NSError *error = nil;
		[fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"SimpleRSS" ofType:@"sqlite"] toPath:filePath error:&error];
		if (error != NULL) {
			NSLog(@"Error in copying file: err %@", [error description]);
		} else {
			NSLog(@"Copied");
		}
		
	} else {
		NSLog(@"Already existed");
	}
	[fileManager release];
}

#pragma mark -
#pragma mark Test Codes

- (void) testCode {
	[Experiment TestDatabase];
}

@end

