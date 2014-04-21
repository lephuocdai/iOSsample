//
//  SDAFParseAPIClient.m
//  SignificantDates
//
//  Created by レー フックダイ on 4/17/14.
//
//

#import "SDAFParseAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kSDFParseAPIBaseURLString = @"https://api.parse.com/1/";
static NSString * const kSDFParseAPIApplicationId = @"Nr8CoJV2lQzSjYdrFJcW7XTVaOuKtaEa08EXQrcC";
static NSString * const kSDFParseAPIKey = @"jLYpn4gI7mBKvBJbKOQylglwagnggrBnmANAcRHe";


@implementation SDAFParseAPIClient

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self setDefaultHeader:@"X-Parse-Application-Id" value:kSDFParseAPIApplicationId];
        [self setDefaultHeader:@"X-Parse-REST-API-Key" value:kSDFParseAPIKey];
    }
    return self;
}

#pragma mark - Singleton
+ (SDAFParseAPIClient*)sharedClient {
    static SDAFParseAPIClient *shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareClient = [[SDAFParseAPIClient alloc]
                       initWithBaseURL:[NSURL URLWithString:kSDFParseAPIBaseURLString]];
    });
    return shareClient;
}

- (NSDateFormatter*)formatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    });
    return formatter;
}


#pragma mark - GET Request Methods
- (NSMutableURLRequest*)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"GET"
                                 path:[NSString stringWithFormat:@"classes/%@", className]
                           parameters:parameters];
    return request;
}

- (NSMutableURLRequest*)GEtRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate {
    NSMutableURLRequest *request = nil;
    NSDictionary *parameters = nil;
    if (updatedDate) {
        NSString *jsonString = [NSString stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
                                [[self formatter] stringFromDate:updatedDate]];
        parameters = [NSDictionary dictionaryWithObject:jsonString forKey:@"where"];
    }
    request = [self GETRequestForClass:className parameters:parameters];
    return request;
}

#pragma mark - POST Request Methods
- (NSMutableURLRequest*)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"POST"
                                 path:[NSString stringWithFormat:@"classes/%@", className]
                           parameters:parameters];
    return request;
}





@end


















































