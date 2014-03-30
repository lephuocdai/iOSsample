//
//  PAPImageView.m
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/14/12.
//

#import "PAPImageView.h"

@interface PAPImageView ()

@property (nonatomic, strong) PFFile *currentFile;
@property (nonatomic, strong) NSString *url;

@end

@implementation PAPImageView

@synthesize currentFile,url;
@synthesize placeholderImage;

#pragma mark - PAPImageView

- (void) setFile:(PFFile *)file {
    UIImageView *border = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowsProfilePicture-43.png"]];
    [self addSubview:border];
    
    NSString *requestURL = file.url; // Save copy of url locally (will not change in block)
    [self setUrl:file.url]; // Save copy of url on the instance
    
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            if ([requestURL isEqualToString:self.url]) {
                [self setImage:image];
                [self setNeedsDisplay];
            }
        } else {
            NSLog(@"Error on fetching file");
        }
    }]; 
}

@end
