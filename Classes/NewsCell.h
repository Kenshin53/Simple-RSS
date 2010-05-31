//
//  NewsCell.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 5/28/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsCell : UITableViewCell {
	UILabel *feedTitleLabel;
	UILabel *timeLabel;
	UILabel *newsTitleLabel;
	UIImageView *favIconView;
	UILabel *briefContentLabel;	
}

@property (nonatomic, retain) IBOutlet UILabel *feedTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *newsTitleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *favIconView;
@property (nonatomic, retain) IBOutlet UILabel *briefContentLabel;

@end
