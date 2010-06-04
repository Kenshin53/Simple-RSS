//
//  FolderCompositeCell.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 6/3/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FolderCompositeCell : UITableViewCell {

	UIImage *iconView;
	NSString *titleLabel;
	NSString *countLabel;
	UIView *cellContentView;
}

@property (nonatomic, retain) UIImage *iconView;
@property (nonatomic, retain) NSString *titleLabel;
@property (nonatomic, retain) NSString *countLabel;


@end
