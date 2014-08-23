//
//  ImageInfo.m
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "ImageInfo.h"

@implementation ImageInfo

@synthesize sourceURL;
@synthesize imageName;
@synthesize image;

- (void)getImage {
    
    NSLog(@"Getting %@...", sourceURL);
    
    NSData * data = [NSData dataWithContentsOfURL:sourceURL];
    if (!data) {
        NSLog(@"Error retrieving %@", sourceURL);
        return;
    }
    
    image = [[UIImage alloc] initWithData:data];
}

- (id)initWithSourceURL:(NSURL *)URL {
    if ((self = [super init])) {
        sourceURL = [URL retain];
        imageName = [[URL lastPathComponent] retain];
        [self getImage];
    }
    return self;
}

- (id)initWithSourceURL:(NSURL *)URL imageName:(NSString *)name image:(UIImage *)i {
    if ((self = [super init])) {
        sourceURL = [URL retain];
        imageName = [name retain];
        image = [i retain];
    }
    return self;
}

- (void)dealloc {
    [sourceURL release];
    [imageName release];
    [image release];
    [super dealloc];
}

@end
