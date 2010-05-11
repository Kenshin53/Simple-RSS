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

- (void)dealloc {
    [splitViewController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    

//	char szNumbers[] = "2001 fb073e82d9943339 -1101110100110100100000 0xfb073e82d9943339";
//	char * pEnd;
//	long long int li1, li2, li3, li4;
//	li1 = strtol (szNumbers,&pEnd,10);
//	li2 = strtol (pEnd,&pEnd,16);
//	li3 = strtol (pEnd,&pEnd,2);
//	li4 = strtol (pEnd,NULL,0);
//	printf ("The decimal equivalents are: %ld, %ld, %ld and %qd.\n", li1, li2, li3, li4);
//	//return 0;
//	unsigned long long num =1;
//	
//	for (int i=1; i<=64; i++) {
//		num = num * 2;
//		
//	}
//	NSLog(@"2^64 = %qu", num-1);

	//[num release];
	NSLog(@"Decimal number of 2387af3e8483a97a is %qd", [[Simple_RSSAppDelegate hexString2Number:@"2387af3e8483a97a"] longLongValue]);
	//[Simple_RSSAppDelegate hexString2Number:@"123afd123"];
	
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

//The purpose of this methods is to return the Value of the ID which is encoded in Hex 
//The Value is in fact is an signed long long (64-bit integer)
//This method is to support the syncing process in which 
+ (NSNumber *) hexString2Number: (NSString *)hex {
	long long result =0;
	
	int digitValue = 0;
	for (int i=0; i < [hex length]; i++) {

		char currentCharacter = [hex characterAtIndex:i];
		if (currentCharacter >= '0' && currentCharacter <='9' ) {
			digitValue = currentCharacter- '0';
			
		} else if ( currentCharacter >= 'a' &&  currentCharacter <= 'f') {
			digitValue = currentCharacter - 'a' +10;
		} else 	if (currentCharacter >= 'A' && currentCharacter <= 'F') {
			digitValue = currentCharacter - 'A' + 10;
		} else {
			return [NSNumber numberWithLongLong:-1];
		}
		result = result * 16 + digitValue;
	}
	return [NSNumber numberWithLongLong:result];
}


@end

