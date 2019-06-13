//
//  ViewController.m
//  BitMapTest
//
//  Created by Dikey on 2019/6/12.
//  Copyright © 2019 Dikey. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+DKBitMap.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"停云馆.jpg"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *fileName = @"/停云.bmp";
    NSString *dirFile = [cacheDirectory stringByAppendingString:fileName];
    
    NSDictionary *options = [NSDictionary new];
    NSData *imageData = [image dk_toData:options type:DKBitMapImageTypeBMP];
    [imageData writeToFile:dirFile atomically:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
