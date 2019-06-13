//
//  UIImage+DKBitMap.h
//  BitMapTest
//
//  Created by Dikey on 2019/6/12.
//  Copyright © 2019 Dikey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DKBitMapImageType) {
    DKBitMapImageTypeJpeg,
    DKBitMapImageTypePNG,
    DKBitMapImageTypeBMP,
};

@interface UIImage (DKBitMap)

- (NSData *)dk_toData:(NSDictionary *)options
              type:(DKBitMapImageType)imageTyp;

@end



