//
//  NewsCompositeCell.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 6/3/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsCompositeCell : UITableViewCell {
	NSString *feedTitleLabel;
	NSString *timeLabel;
	NSString *newsTitleLabel;
	UIImage *favIconView;
	NSString *briefContentLabel;	
	UIView *cellContentView;
	BOOL unreadState;
	
}

@property (nonatomic, retain) NSString *feedTitleLabel;
@property (nonatomic, retain) NSString *timeLabel;
@property (nonatomic, retain) NSString *newsTitleLabel;
@property (nonatomic, retain) UIImage *favIconView;
@property (nonatomic, retain) NSString *briefContentLabel;	
@property (nonatomic) BOOL unreadState;


@end
