//
//  GoogleReaderHelperClass.h
//  Smart RSS Reader
//
//  Created by Cao Manh Tuan on 03/09/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

extern NSString * const kGoogleReaderAuthenticationFailed;
extern NSString * const kGoogleReaderAtomURL;
extern NSString * const kGoogleReaderAPI;
extern NSString * const kGoogleReaderView;
extern NSString * const kGoogleReaderShared;
extern NSString * const kGoogleReaderSettings;
extern NSString * const kGoogleReaderLoginURL;

#import <Foundation/Foundation.h>


@interface GoogleReaderHelper: NSObject {

}
//+ (id)fetchJSONValueForURL:(NSURL *)url;
+ (id)fetchJSONValueForData:(NSData *)data;
+ (NSDictionary *)fetchInfoForURLWithGoogleSID:(NSString*) url SID:(NSString *)SID;
+ (NSString *)getGoogleSID:(NSString *)userName password:(NSString *)passwd;
+(NSData *)fetchRawDataForURLWithGoogleSID:(NSString*)url SID:(NSString *)SID;
+(NSString *)getTokenID:(NSString *) googleSID;
+(NSDictionary *) getUserInfo:(NSString *) googleSID;
@end
