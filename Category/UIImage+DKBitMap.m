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
#import <Accelerate/Accelerate.h>

@implementation UIImage (DKBitMap)

+ (unsigned char *)dk_convertUIImageToBitmapRGBA8:(UIImage *) image
{
    vImage_Buffer src = [UIImage dk_convertImage:image];
    return src.data;
}

+ (unsigned char *)dk_convertARGBImageToBitmapRGBA8:(UIImage *)image
{
    vImage_Buffer src = [UIImage dk_convertImage:image];
    const uint8_t map[4] = {1,2,3,0};
    vImage_Buffer dest = [UIImage dk_convertImage:image];
    vImagePermuteChannels_ARGB8888(&src, &dest, map, kvImageNoFlags);
    return dest.data;
}

+ (vImage_Buffer)dk_convertImage:(UIImage *)image
{
    CGImageRef sourceRef = [image CGImage];
    NSUInteger sourceWidth = CGImageGetWidth(sourceRef);
    NSUInteger sourceHeight = CGImageGetHeight(sourceRef);
    
    CGDataProviderRef provider = CGImageGetDataProvider(sourceRef);
    CFDataRef bitmapData = CGDataProviderCopyData(provider);
    
    unsigned char *sourceData = (unsigned char*)calloc(sourceHeight * sourceWidth * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger sourceBytesPerRow = bytesPerPixel * sourceWidth;
    
    CFDataGetBytes(bitmapData, CFRangeMake(0, CFDataGetLength(bitmapData)), sourceData);
    
    vImage_Buffer v_image = {
        .data = (void *)sourceData,
        .height = sourceHeight,
        .width = sourceWidth,
        .rowBytes = sourceBytesPerRow
    };
    
    CFRelease(bitmapData);
    
    return v_image;
}

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
