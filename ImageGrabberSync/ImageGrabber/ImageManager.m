//
//  ImageManager.m
//  ImageGrabber
//
//  Created by Ray Wenderlich on 7/3/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "ImageManager.h"
#import "ImageInfo.h"
#import "ZipArchive.h"

@implementation ImageManager
@synthesize html;
@synthesize delegate;

- (void)processZip:(NSData *)data sourceURL:(NSURL *)sourceURL {
    
    NSLog(@"Processing zip file...");
    
    // Write file to disk
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directories objectAtIndex:0];
    NSString *zipFilePath = [documentDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];    
    [data writeToFile:zipFilePath atomically:YES];                                    
    NSLog(@"Wrote to: %@", zipFilePath);
    
    // Open zip
    ZipArchive *zip = [[[ZipArchive alloc] init] autorelease];
    BOOL success = [zip UnzipOpenFile:zipFilePath];    
    if (!success) {
        NSLog(@"Failed to open zip");
        return;
    }
    
    // Unzip
    NSString *zipDirName = [sourceURL.lastPathComponent substringWithRange:NSMakeRange(0, sourceURL.lastPathComponent.length - sourceURL.pathExtension.length - 1)];
    NSString *zipDirPath = [documentDirectory stringByAppendingPathComponent:zipDirName];
    NSLog(@"Unzipping to %@", zipDirPath);
    
    success = [zip UnzipFileTo:zipDirPath overWrite:YES];
    if (!success) {
        NSLog(@"Failed to unzip zip");
        return;
    }
    
    // Enumerate directory
    NSError * error = nil;
    NSArray * items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:zipDirPath error:&error];
    if (error) {
        NSLog(@"Could not enumerate %@", zipDirPath);
        return;
    }
    
    NSMutableArray *imageInfos = [NSMutableArray array];
    for (NSString *file in items) {
        if ([file.pathExtension compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
            [file.pathExtension compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            
            NSString *imagePath = [zipDirPath stringByAppendingPathComponent:file];
            UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
            NSLog(@"Found image in zip: %@", file);
            
            ImageInfo *info = [[[ImageInfo alloc] initWithSourceURL:sourceURL imageName:file image:image] autorelease];
            [imageInfos addObject:info];            
        }        
    }
    
    pendingZips--;
    
    [delegate imageInfosAvailable:imageInfos done:(pendingZips==0)];
        
}

- (void)retrieveZip:(NSURL *)sourceURL {
    
    NSLog(@"Getting %@...", sourceURL);
    
    NSData * data = [NSData dataWithContentsOfURL:sourceURL];
    if (!data) {
        NSLog(@"Error retrieving %@", sourceURL);
        return;
    }
    
    [self processZip:data sourceURL:sourceURL];
    
}

- (void)processHtml {
    
    NSLog(@"Processing HTML...");
    
    // Simple regex to search for links
    NSError *error = nil;
    NSString *pattern = @"(href|src)=\"([\\w:\\/\\.-]*)";
    NSLog(@"Searching HTML with pattern: %@", pattern);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
    
    // Search for links and add to set
    NSMutableSet *linkURLs = [NSMutableSet set];
    [regex enumerateMatchesInString:html options:0 range:NSMakeRange(0, html.length-1) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSString *link = [html substringWithRange:[result rangeAtIndex:2]];
        NSURL *linkURL = [NSURL URLWithString:link];
        if ([linkURL.pathExtension compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
            [linkURL.pathExtension compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
            [linkURL.pathExtension compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame) {               
            [linkURLs addObject:linkURL];
        }
        
    }];
    
    // Create an image info for each link (except zip)
    NSMutableArray * imageInfos = [NSMutableArray array];
    for(NSURL *linkURL in linkURLs) {
        if ([linkURL.pathExtension compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            [self retrieveZip:linkURL];
            pendingZips++;
        } else {
            ImageInfo *info = [[[ImageInfo alloc] initWithSourceURL:linkURL] autorelease];
            [imageInfos addObject:info];
        }
    }
    
    // Notify delegate in main thread that new image infos
    // available
    [delegate imageInfosAvailable:imageInfos done:(pendingZips==0)];
    
}

- (void)process {
    
    [self processHtml];
    
}

- (id)initWithHTML:(NSString *)theHtml delegate:(id<ImageManagerDelegate>) theDelegate {
    
    if ((self = [super init])) {
        html = theHtml;      
        delegate = theDelegate;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
