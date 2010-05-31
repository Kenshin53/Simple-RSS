//
//  NewsCell.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 5/28/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "NewsCell.h"


@implementation NewsCell

@synthesize feedTitleLabel,newsTitleLabel, timeLabel, briefContentLabel,favIconView;

- (void)dealloc {
	[feedTitleLabel release];
	[timeLabel release];
	[newsTitleLabel release];
	[briefContentLabel release];
	[favIconView release];
    [super dealloc];

}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}




@end
