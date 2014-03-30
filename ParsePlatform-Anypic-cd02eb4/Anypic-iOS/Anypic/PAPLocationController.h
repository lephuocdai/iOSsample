//
//  PAPLocationController.h
//  AnyPhoto
//
//  Created by Hector Ramos on 4/9/12.
//

#import <Foundation/Foundation.h>

@interface PAPLocationController : NSObject <CLLocationManagerDelegate>
@property (strong, readonly) CLLocation *lastLocation;
@property (nonatomic, strong) NSString *lastLocationName;
@property (copy) PAPLocationUpdateBlock locationUpdateBlock; 

+ (PAPLocationController*)sharedInstance;
+ (id)allocWithZone:(NSZone *)zone;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
