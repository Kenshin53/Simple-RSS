//
//  FolderCell.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 5/27/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "FolderCell.h"


@implementation FolderCell

@synthesize iconView, titleLabel, countLabel;

- (void)dealloc {
	[iconView release];
	[titleLabel release];
	[countLabel release];
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
