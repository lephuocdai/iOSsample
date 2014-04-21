//
//  SDAFParseAPIClient.h
//  SignificantDates
//
//  Created by レー フックダイ on 4/17/14.
//
//

#import "AFHTTPClient.h"

@interface SDAFParseAPIClient : AFHTTPClient

+ (SDAFParseAPIClient*)sharedClient;

- (NSMutableURLRequest*)GETRequestForClass:(NSString*)className parameters:(NSDictionary*)parameters;
- (NSMutableURLRequest*)GEtRequestForAllRecordsOfClass:(NSString*)className updatedAfterDate:(NSDate*)updatedDate;

- (NSMutableURLRequest*)POSTRequestForClass:(NSString*)className parameters:(NSDictionary*)parameters;

@end
