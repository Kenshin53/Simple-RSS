//
//  Section.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 6/11/10.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Section : NSObject {
	NSString *sectionName;
	NSString *sectionID;
	NSInteger numberOfRows;
	
}

@property (nonatomic,retain) NSString *sectionName;
@property (nonatomic, retain) NSString *sectionID;
@property (nonatomic, assign) NSInteger numberOfRows;
@end
