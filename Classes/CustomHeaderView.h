//
//  CustomHeaderView.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 6/10/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomHeaderView : UIView {
	UIImage		*headerImage;
	NSString	*headerTitle;
}

@property (nonatomic, retain) NSString *headerTitle;
@property (nonatomic, retain) UIImage *headerImage;
@end
