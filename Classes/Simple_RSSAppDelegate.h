//
//  Simple_RSSAppDelegate.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 20/04/2010.
//  Copyright University of Sunderland 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthViewController.h"

@class MasterViewController;
@class DetailViewController;
@class FolderViewController;




@interface Simple_RSSAppDelegate : NSObject <UIApplicationDelegate, AuthenticationProtocol> {
    
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
    FolderViewController *folderViewController;
    DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic,retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic,retain) IBOutlet FolderViewController *folderViewController;
@property (nonatomic,retain) IBOutlet DetailViewController *detailViewController;

- (void)authenticate;
+ (NSNumber *)hexString2Number:(NSString *)hex;
@end
