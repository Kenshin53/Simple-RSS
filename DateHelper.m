//
//  DateHelper.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 13/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import "DateHelper.h"


@implementation DateHelper

+(NSInteger) getTimeStampFromNDaysAgo: (NSInteger )days {
	NSDate *today = [NSDate date];
	int numberOfSecondInADay = 86400;
	NSInteger result = (NSInteger) ([today timeIntervalSince1970] - days* numberOfSecondInADay);
	
	return result;
	
}
@end
