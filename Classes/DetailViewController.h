//
//  DetailViewController.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 20/04/2010.
//  Copyright University of Sunderland 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    
    UIPopoverController *popoverController;
    UINavigationBar *navigationBar;
    
    id detailItem;
}

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;

@property (nonatomic, retain) id detailItem;

@end
