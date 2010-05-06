//
//  AuthViewController.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 20/04/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthenticationProtocol

-(void)AuthenticationSucceeded:(BOOL) succeeded;

@end


@interface AuthViewController : UIViewController <UITextFieldDelegate >{

@private
	IBOutlet UITextField *txtUsername;
	IBOutlet UITextField *txtPassword;
@public
	id <AuthenticationProtocol> delegate;
	NSString *googleSID;
	NSString *tokenID;
	NSString *cookies;
	
}


@property (nonatomic,retain) IBOutlet UITextField *txtUsername;
@property (nonatomic, retain) IBOutlet UITextField *txtPassword;
@property (retain) id delegate;

-(IBAction) Authenticate;


@end
