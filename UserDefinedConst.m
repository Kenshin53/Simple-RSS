//
//  UserDefinedConst.m
//  Simple RSS
//
//  Created by Manh Tuan Cao on 13/05/2010.
//  Copyright 2010 University of Sunderland. All rights reserved.
//

//Notification Constant

NSString * const kNotificationFinishedParsingArticles =@"FinishedParsingArticles";

NSString * const kNotificationFeedListDidChanged =@"FeedListDidChanged";
NSString * const kNotificationAddedNewFolder = @"AddedNewFolder";
NSString * const kNotificationNewsItemAdded = @"NewsItemAdded";

//URL constant
NSString * const kURLgetUnreadItemIDsFormat = @"http://google.com/reader/api/0/stream/items/ids?n=5000&s=user/-/state/com.google/reading-list&ot=%d&xt=user/-/state/com.google/read&output=json";

NSString * const  kURLSubscriptionFetchingFormat = @"http://www.google.com/reader/api/0/subscription/list?allcomments=true&output=json&ck=%d&client=scroll";

NSString * const kURLGetTagList = @"http://www.google.com/reader/api/0/tag/list?output=json";

NSString * const kURLGetArticleContent =@"http://www.google.com/reader/api/0/stream/items/contents";

NSString * const kURLGetTokenID =@"http://www.google.com/reader/api/0/token";



