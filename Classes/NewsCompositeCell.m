//
//  NewsCompositeCell.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 6/3/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "NewsCompositeCell.h"

@interface CompositeSubviewNewsCellContent : UIView
{
    NewsCompositeCell *_cell;
    BOOL _highlighted;
}

@end

@implementation CompositeSubviewNewsCellContent

- (id)initWithFrame:(CGRect)frame cell:(NewsCompositeCell *)cell
{
    if (self = [super initWithFrame:frame]) {
        _cell = cell;
        
        self.opaque = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
	//    [_cell.iconView drawAtPoint:CGPointMake(31.0, 31.0)];
	[_cell.favIconView drawInRect:CGRectMake(7.0, 23.0, 16.0, 16.0)];
	if (_cell.unreadState) {
		_highlighted ? [[UIColor whiteColor] set] : [[UIColor blackColor] set];
		//    [_cell.titleLabel drawAtPoint:CGPointMake(65.0, 12.0) withFont:[UIFont boldSystemFontOfSize:16.0]];
		
//		[_cell.feedTitleLabel drawAtPoint:CGPointMake(8.0, 0.0) withFont:[UIFont boldSystemFontOfSize:13.0]];

		[_cell.timeLabel drawAtPoint:CGPointMake(220.0, 0.0) withFont:[UIFont boldSystemFontOfSize:13.0]];
//		[_cell.newsTitleLabel drawAtPoint:CGPointMake(36.0, 20.0) withFont:[UIFont boldSystemFontOfSize:14.0]];

			[_cell.newsTitleLabel drawInRect:CGRectMake(36.0, 20.0, 280.0, 21.0) withFont:[UIFont boldSystemFontOfSize:14.0]];	
		//    _highlighted ? [[UIColor whiteColor] set] : [[UIColor colorWithWhite:0.23 alpha:1.0] set];
		//    [_cell.briefContentLabel drawAtPoint:CGPointMake(36.0, 43.0) withFont:[UIFont systemFontOfSize:13.0]];    
		//[_cell.briefContentLabel drawAtPoint:CGPointMake(36.0, 43.0) forWidth:28.0 withFont:[UIFont systemFontOfSize:13.0] lineBreakMode:UILineBreakModeWordWrap];
		[_cell.briefContentLabel drawInRect:CGRectMake(36.0, 43.0, 280.0, 50.0) withFont:[UIFont systemFontOfSize:13.0] lineBreakMode:UILineBreakModeWordWrap];
		
	}else {
		_highlighted ? [[UIColor whiteColor] set] : [[UIColor lightGrayColor] set];
		
		[_cell.feedTitleLabel drawAtPoint:CGPointMake(8.0, 0.0) withFont:[UIFont systemFontOfSize:13.0]];
		[_cell.feedTitleLabel drawInRect:CGRectMake(8.0, 0.0, 204.0, 21.0) withFont:[UIFont systemFontOfSize:13.0]];
		[_cell.timeLabel drawAtPoint:CGPointMake(220.0, 0.0) withFont:[UIFont systemFontOfSize:13.0]];

		//[_cell.newsTitleLabel drawAtPoint:CGPointMake(36.0, 20.0) withFont:[UIFont systemFontOfSize:14.0]];
		[_cell.newsTitleLabel drawInRect:CGRectMake(36.0, 20.0, 280.0, 21.0) withFont:[UIFont systemFontOfSize:14.0]];
		//    _highlighted ? [[UIColor whiteColor] set] : [[UIColor colorWithWhite:0.23 alpha:1.0] set];
		//    [_cell.briefContentLabel drawAtPoint:CGPointMake(36.0, 43.0) withFont:[UIFont systemFontOfSize:13.0]];    
//		[_cell.briefContentLabel drawAtPoint:CGPointMake(36.0, 43.0) forWidth:28.0 withFont:[UIFont systemFontOfSize:13.0] lineBreakMode:UILineBreakModeWordWrap];
		[_cell.briefContentLabel drawInRect:CGRectMake(36.0, 43.0, 280.0, 50.0) withFont:[UIFont systemFontOfSize:13.0] lineBreakMode:UILineBreakModeWordWrap];
		
		
	}

	
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    [self setNeedsDisplay];
}

- (BOOL)isHighlighted
{
    return _highlighted;
}

@end

/* ---------------------------------
 Implement NewsCompositeCell
 
 -----------------------------------*/

@implementation NewsCompositeCell

@synthesize feedTitleLabel,newsTitleLabel, timeLabel, briefContentLabel,favIconView, unreadState;

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
		cellContentView = [[CompositeSubviewNewsCellContent alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0) cell:self];
		
        cellContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cellContentView.contentMode = UIViewContentModeRedraw;
        [self.contentView addSubview:cellContentView];	
    }
    return self;
}





@end
