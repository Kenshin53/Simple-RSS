//
//  MasterViewController.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 20/04/2010.
//  Copyright University of Sunderland 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController {
    DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
