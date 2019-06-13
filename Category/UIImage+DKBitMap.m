//
//  UIImage+DKBitMap.m
//  BitMapTest
//
//  Created by Dikey on 2019/6/12.
//  Copyright © 2019 Dikey. All rights reserved.
//

#import "UIImage+DKBitMap.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIImage (DKBitMap)

- (NSData *)dk_toJpegData:(CGFloat )compressionQuality
              hasAlpha:(BOOL)hasAlpha
           orientation:(int)orientation
{
    if (!self.CGImage) {
        return nil;
    }
    
    NSDictionary *options =  @{
                               (NSString*)kCGImagePropertyOrientation:[NSNumber numberWithInt:orientation],
                               (NSString*)kCGImagePropertyHasAlpha:[NSNumber numberWithBool:hasAlpha],
                               (NSString*)kCGImageDestinationLossyCompressionQuality: [NSNumber numberWithFloat:compressionQuality]
                               };
    return [self dk_toData:options type:DKBitMapImageTypeJpeg];
}

- (NSData *)dk_toData:(NSDictionary *)options
              type:(DKBitMapImageType)imageType
{
    if (!self.CGImage) {
        return nil;
    }
    return [self dk_toDataWith:options type:[self dk_imageType:imageType]];
}

- (CFStringRef)dk_imageType:(DKBitMapImageType)type
{
    /*
     case .image: return kUTTypeImage
     case .jpeg: return kUTTypeJPEG
     case .jpeg2000: return kUTTypeJPEG2000
     case .tiff: return kUTTypeTIFF
     case .pict: return kUTTypePICT
     case .gif: return kUTTypeGIF
     case .png: return kUTTypePNG
     case .quickTimeImage: return kUTTypeQuickTimeImage
     case .appleICNS: return kUTTypeAppleICNS
     case .bmp: return kUTTypeBMP
     case .ico: return kUTTypeICO
     case .rawImage: return kUTTypeRawImage
     case .scalableVectorGraphics: return kUTTypeScalableVectorGraphics
     case .livePhoto: return kUTTypeLivePhoto
     */
    switch (type) {
        case DKBitMapImageTypeBMP:{
            return kUTTypeBMP;
        }
            break;
            
        case DKBitMapImageTypePNG:{
            return kUTTypePNG;
        }
            break;
            
        case DKBitMapImageTypeJpeg:{
            return kUTTypeJPEG;
        }
            break;
    }
    return kUTTypeJPEG;
}

- (NSData *)dk_toDataWith:(NSDictionary *)options
                  type:(CFStringRef)type
{
    if (!self.CGImage) {
        return nil;
    }
    @autoreleasepool {
        NSMutableData *data = [NSMutableData new];
        CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data,
                                                                                  type,
                                                                                  1,
                                                                                  nil);
        if (imageDestination == NULL) {
            return nil;
        }
        CGImageDestinationAddImage(imageDestination, self.CGImage, (__bridge CFDictionaryRef)options);
        CGImageDestinationFinalize(imageDestination);
        CFRelease(imageDestination);
        return data;
    }
}

@end
