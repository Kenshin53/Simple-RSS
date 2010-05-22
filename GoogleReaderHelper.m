//
//  GoogleReaderHelperClass.m
//  Smart RSS Reader
//
//  Created by Cao Manh Tuan on 03/09/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GoogleReaderHelper.h"
#import "JSON.h"
NSString * const kGoogleReaderAuthenticationFailed = @"Failed";
NSString * const kGoogleReaderAtomURL = @"http://www.google.com/reader/atom/";
NSString * const kGoogleReaderAPI = @"http://www.google.com/reader/api/0/";
NSString * const kGoogleReaderView = @"http://www.google.com/reader/view/";
NSString * const kGoogleReaderShared = @"http://www.google.com/reader/shared/";
NSString * const kGoogleReaderSettings = @"http://www.google.com/reader/settings/";
NSString * const kGoogleReaderLoginURL = @"https://www.google.com/accounts/ClientLogin";


@implementation GoogleReaderHelper

+ (NSString *)getGoogleSID:(NSString *)userName password:(NSString *)passwd{
	
	
	NSString *postMessage = [[NSString alloc] initWithFormat:@"Email=%@&Passwd=%@",userName,passwd];
	NSData *myRequestData = [[NSData alloc]  initWithBytes: [ postMessage UTF8String ] length: [ postMessage length ] ];

	NSMutableURLRequest *request = [[NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: kGoogleReaderLoginURL]]; 
	[ request setHTTPMethod: @"POST" ];
	[ request setHTTPBody: myRequestData ];
	
	[postMessage release];
	[myRequestData release];
	NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	
	
	NSRange range = [responseString rangeOfString:@"LSID="];
	if (range.location != NSNotFound) {
		range.length = range.location - 5;
		range.location =4;
	} else{
		if ([responseString rangeOfString:@"SID="].location == NSNotFound){
			[request release];
			[responseString release];
			
			return kGoogleReaderAuthenticationFailed;
		}
		
	}
	
	NSString *result = [responseString substringWithRange:range];
	[responseString release];
	[request release];
	
	return  result;
	
}

+(NSString *)getTokenID:(NSString *) googleSID{
	
	NSURL *tokenURL = [[NSURL alloc] initWithString:@"http://www.google.com/reader/api/0/token"];
	NSMutableURLRequest *getXMLRequest = [[NSMutableURLRequest alloc ] initWithURL: tokenURL ]; 
	
	NSString *cookie = [[NSString alloc] initWithFormat:@"SID=%@;Domain=.google.com;path=/;expires=1600000000",googleSID];
	
	[getXMLRequest setValue:[NSString stringWithString:cookie] forHTTPHeaderField:@"Cookie"];
	[getXMLRequest setHTTPMethod: @"GET" ];
	NSData *returnData = [NSURLConnection sendSynchronousRequest: getXMLRequest returningResponse: nil error: nil];
	NSString *token = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
	
	[cookie release];
	[tokenURL release];
	[getXMLRequest release];
	
	return token;
}

+(NSDictionary *) getUserInfo:(NSString *) googleSID {
	NSString *url = [[[NSString alloc] initWithString:@"http://www.google.com/reader/api/0/user-info?&ck=1255643091105&client=SimpleRSS"] autorelease];
	return [self fetchInfoForURLWithGoogleSID:url SID:googleSID];
	
	
	
}

+ (id)fetchJSONValueForData:(NSData *)data
{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    id jsonValue = [jsonString JSONValue];
    
	[jsonString release];
    
    return jsonValue;
}

+ (NSDictionary *)fetchInfoForURLWithGoogleSID:(NSString*)url SID:(NSString *)SID{
	//NSString *atomURL = [NSString stringWithString:url];
	NSMutableURLRequest *getXMLRequest = [[NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: url ] ]; 
	
	NSString *cookie = [[NSString alloc] initWithFormat:@"SID=%@;Domain=.google.com;path=/;expires=1600000000",SID];
	
	[getXMLRequest setValue:[NSString stringWithString:cookie] forHTTPHeaderField:@"Cookie"];
	[getXMLRequest setHTTPMethod: @"GET" ];
	NSData *returnData = [NSURLConnection sendSynchronousRequest: getXMLRequest returningResponse: nil error: nil];
		
	
	[cookie release];
	
	[getXMLRequest release];
	return [self fetchJSONValueForData:returnData];
}
    

+ (NSData *)fetchRawDataForURLWithGoogleSID:(NSString*)url SID:(NSString *)SID{
	
	NSMutableURLRequest *getXMLRequest = [[NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: url ] ]; 
	
	NSString *cookie = [[NSString alloc] initWithFormat:@"SID=%@;Domain=.google.com;path=/;expires=1600000000",SID];
	
	[getXMLRequest setValue:[NSString stringWithString:cookie] forHTTPHeaderField:@"Cookie"];
	[getXMLRequest setHTTPMethod: @"GET" ];
	NSData *returnData = [ NSURLConnection sendSynchronousRequest: getXMLRequest returningResponse: nil error: nil ];
	
	[cookie release];
	[getXMLRequest release];
	 
	return returnData;
}

@end
