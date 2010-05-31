//
//  FolderCell.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 5/27/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FolderCell : UITableViewCell {

	UIImageView *iconView;
	UILabel *titleLabel;
	UILabel *countLabel;
	
}

@property (nonatomic, retain) IBOutlet UIImageView *iconView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *countLabel;
@end
