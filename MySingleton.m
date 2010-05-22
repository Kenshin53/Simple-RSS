//
//  MySingleton.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 12/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//
#import "MySingleton.h"

@implementation MySingleton
@synthesize tokenID, doneParsingFeed, googleSID, timeStamp;
static MySingleton * sharedInstance = nil;


+( id )sharedInstance {
    @synchronized( [ MySingleton class ] ) {
        if( sharedInstance == nil )
            sharedInstance = [ [ MySingleton alloc ] init ];
    }
	
    return sharedInstance;
}

+( id )allocWithZone:( NSZone * )zone {
    @synchronized( [ MySingleton class ] ) {
        if( sharedInstance == nil )
            sharedInstance = [ super allocWithZone:zone ];
    }
	
    return sharedInstance;
}

-( id )init {
    @synchronized( [ MySingleton class ] ) {
        self = [ super init ];
        if( self != nil ) {
            // Insert initialization code here
        }
		
        return self;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}



@end