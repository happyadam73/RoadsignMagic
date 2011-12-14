//
//  UIImage+NonCached.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 09/10/2011.
//  Copyright 2011 happyadam development. All rights reserved.
//

#import "UIImage+NonCached.h"

@implementation UIImage (NonCached)

//+ (UIImage*)imageFromFile:(NSString*)aFileName 
//{
//    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
//    NSString *imageFilename = [NSString stringWithFormat:@"%@/%@", bundlePath, aFileName];
//    UIImage *image = [UIImage imageWithContentsOfFile:imageFilename];
//    if (!image) {
//        image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@@2x.%@", [imageFilename stringByDeletingPathExtension], [imageFilename pathExtension]]];
//    }
//    return image;
//}

+ (UIImage *)imageFromFile:(NSString*)filename
{
    return [[[UIImage alloc] initFromFile:filename withNoUpscaleForNonRetina:NO] autorelease];
}

+ (UIImage *)imageFromFile:(NSString*)filename withNoUpscaleForNonRetina:(BOOL)noUpscaleForNonRetina
{
    return [[[UIImage alloc] initFromFile:filename withNoUpscaleForNonRetina:noUpscaleForNonRetina] autorelease];
}

- (id)initFromFile:(NSString *)filename withNoUpscaleForNonRetina:(BOOL)noUpscaleForNonRetina
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", bundlePath, filename];
    NSString *path2x = [[path stringByDeletingLastPathComponent] 
                        stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.%@", 
                                                        [[path lastPathComponent] stringByDeletingPathExtension], 
                                                        [path pathExtension]]];

    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 ) 
    {
        //retina device - iPad3, iPhone 4, 4S - check for a 2x file first
        if ([[NSFileManager defaultManager] fileExistsAtPath:path2x]) 
        {
            return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path2x]] CGImage] scale:2.0 orientation:UIImageOrientationUp];               
        } else {
            //no 2x file found
            return [self initWithData:[NSData dataWithContentsOfFile:path]];    
        }
    } else {
        //non-retina display.  First check there's a file with the normal path - if not, then use the 2x path
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) 
        {
            return [self initWithData:[NSData dataWithContentsOfFile:path]];
        } else {
            if (noUpscaleForNonRetina) {
                //don't use a 2.0 scale for non-retina display
                return [self initWithData:[NSData dataWithContentsOfFile:path2x]];             
            } else {
                return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path2x]] CGImage] scale:2.0 orientation:UIImageOrientationUp];
            }
        }
    }
}

//- (id)initWithContentsOfResolutionIndependentFile:(NSString *)aFileName {
//    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
//    NSString *path = [NSString stringWithFormat:@"%@/%@", bundlePath, aFileName];
//    NSString *path2x = [[path stringByDeletingLastPathComponent] 
//                        stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.%@", 
//                                                        [[path lastPathComponent] stringByDeletingPathExtension], 
//                                                        [path pathExtension]]];
//    
//    if ( [[NSFileManager defaultManager] fileExistsAtPath:path2x] ) {
//        if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 ) {
//            return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path2x]] CGImage] scale:2.0 orientation:UIImageOrientationUp];   
//            
//        } else {
//            return [self initWithData:[NSData dataWithContentsOfFile:path2x]]; 
//        }
//    } else {
//        return [self initWithData:[NSData dataWithContentsOfFile:path]];        
//    }
//}
//
//+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)aFileName {
//    return [[[UIImage alloc] initWithContentsOfResolutionIndependentFile:aFileName] autorelease];
//}

@end
