//
//  RSSEntry.m
//  RSSFun
//
//  Created by レー フックダイ on 3/8/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "RSSEntry.h"

@implementation RSSEntry
@synthesize blogTitle = _blogTitle;
@synthesize articleTitle = _articleTitle;
@synthesize articleUrl = _articleUrl;
@synthesize articleDate = _articleDate;

- (id)initWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate
{
    if ((self = [super init])) {
        _blogTitle = blogTitle;
        _articleTitle = articleTitle;
        _articleUrl = articleUrl;
        _articleDate = articleDate;
    }
    return self;
}
/**
- (void)dealloc {
    [_blogTitle release];
    _blogTitle = nil;
    [_articleTitle release];
    _articleTitle = nil;
    [_articleUrl release];
    _articleUrl = nil;
    [_articleDate release];
    _articleDate = nil;
    [super dealloc];
}
**/



@end