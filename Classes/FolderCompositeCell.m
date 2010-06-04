//
//  FolderCompositeCell.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 6/3/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "FolderCompositeCell.h"

@interface CompositeSubviewFolderCellContent : UIView
{
    FolderCompositeCell *_cell;
    BOOL _highlighted;
}

@end


@implementation CompositeSubviewFolderCellContent

- (id)initWithFrame:(CGRect)frame cell:(FolderCompositeCell *)cell
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
	[_cell.iconView drawInRect:CGRectMake(15.0, 7.0, 31.0, 31.0)];
    _highlighted ? [[UIColor whiteColor] set] : [[UIColor grayColor] set];
    [_cell.titleLabel drawAtPoint:CGPointMake(65.0, 12.0) withFont:[UIFont boldSystemFontOfSize:16.0]];
    
//    _highlighted ? [[UIColor whiteColor] set] : [[UIColor colorWithWhite:0.23 alpha:1.0] set];
    [_cell.countLabel drawAtPoint:CGPointMake(245.0, 12.0) withFont:[UIFont boldSystemFontOfSize:13.0]];
    
   
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



@implementation FolderCompositeCell

@synthesize iconView, titleLabel, countLabel;

- (void)dealloc {
	[iconView release];
	[titleLabel release];
	[countLabel release];
	[cellContentView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        cellContentView = [[CompositeSubviewFolderCellContent alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0) cell:self];
		
        cellContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cellContentView.contentMode = UIViewContentModeRedraw;
        [self.contentView addSubview:cellContentView];		
	
    }
    return self;
}

/*
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	
    [UIView setAnimationsEnabled:NO];
    CGSize contentSize = cellContentView.bounds.size;
    cellContentView.contentStretch = CGRectMake(225.0 / contentSize.width, 0.0, (contentSize.width - 260.0) / contentSize.width, 1.0);
    [UIView setAnimationsEnabled:YES];
}

 */


@end
