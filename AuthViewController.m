    //
//  AuthViewController.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 20/04/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "AuthViewController.h"
#import "GoogleReaderHelper.h"
#import "MySingleton.h"
@interface AuthViewController ()

- (void) dismissKeyboard;


@end


@implementation AuthViewController

@synthesize txtPassword, txtUsername, delegate;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)dealloc {
    [super dealloc];
//Nil out the delegate
	delegate = nil;
}

-(IBAction) Authenticate {

	[self dismissKeyboard];
	
	if ([txtUsername.text length] == 0 || [txtPassword.text length] ==0 ) {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Authentication failed" message:@"Please enter your username/password" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease];
		[alert show];
	}else {
		
		googleSID = [[NSString alloc] initWithString:[GoogleReaderHelper getGoogleSID:txtUsername.text password:txtPassword.text]];
		NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
		if ([googleSID isEqualToString:kGoogleReaderAuthenticationFailed]) {
			//Re-Authenticate
			tokenID = nil;
			NSLog(@"Cannot get tokenID due to failed authentication");
			[settings setBool:NO forKey:@"authenticated"];
			
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Incorrect Username/Password" message:@"Please enter correct Username/Password" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease];
			[alert show];
			
		}else {
			tokenID = [[NSString alloc] initWithString:[GoogleReaderHelper getTokenID:googleSID]];	
			
						
			[settings setObject:googleSID forKey:@"googleSID"];
			[settings setObject:tokenID forKey:@"tokenID"];
			[settings setBool:YES forKey:@"authenticated"];
//Sending delegate to the parent class
			[[self delegate] AuthenticationSucceeded:YES];
			
			NSLog(@"Google SID: %@",googleSID);
			
			NSLog(@"Token ID: %@", tokenID);
		}
		
		
	}

	
}

- (void) dismissKeyboard {
	[txtPassword resignFirstResponder];
	[txtUsername resignFirstResponder];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
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
	txtPassword  = nil;
	txtUsername = nil;
	
}




@end
