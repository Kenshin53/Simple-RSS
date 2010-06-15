//
//  CustomHeaderView.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 6/10/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "CustomHeaderView.h"


#define DEFAULT_HEIGHT 24
#define DEFAULT_WIDTH = 320


@implementation CustomHeaderView

@synthesize headerImage, headerTitle;

- (void)dealloc {
	[headerImage release];
	[headerTitle release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.clearsContextBeforeDrawing = YES;
		
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code for rectangles
	CGContextRef context = UIGraphicsGetCurrentContext(); 
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0); // Black line
	CGContextSetRGBFillColor(context, 0.5, 0.5, 0.0, 1.0);	
    CGContextBeginPath(context);
	
    CGContextMoveToPoint(context, 0.0, 0.0); //start point
    CGContextAddLineToPoint(context, 316.0, 0.0);
    CGContextAddLineToPoint(context, 316.0, 24.0);
    CGContextAddLineToPoint(context, 0.0, 24.0); // end path
	
    CGContextClosePath(context); // close path
	
    CGContextSetLineWidth(context, 1.0); // this is set from now on until you explicitly change it
	
    CGContextStrokePath(context); // do actual stroking
	
 // green color, half transparent
	CGContextFillRect(context, CGRectMake(0.0, 0.0, 24.0, 320.0));
	
	//[headerImage drawInRect:CGRectMake(6.0, 4.0, 16.0, 16.0)];
	[headerImage drawInRect:CGRectMake(6.0, 4.0, 16.0, 16.0)];
	
}




@end
