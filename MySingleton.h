//
//  MySingleton.h
//  Simple RSS
//
//  Created by Manh Tuan Cao on 12/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MySingleton : NSObject {
	NSString *tokenID;
	BOOL doneParsingFeed;
	NSString *googleSID;
	NSInteger timeStamp; 
	
}

@property (retain) NSString *tokenID;
@property BOOL doneParsingFeed;
@property (retain) NSString *googleSID;
@property NSInteger timeStamp;

+( id )sharedInstance;
@end
