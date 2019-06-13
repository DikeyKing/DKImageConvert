# DKImageConvert

Convert JPG or PNG to BMP in Objective-C

Usage：

```objective-c
    UIImage *image = [UIImage imageNamed:@"停云馆.jpg"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    NSString *fileName = @"/停云.bmp";
    NSString *dirFile = [cacheDirectory stringByAppendingString:fileName];
    
    NSDictionary *options = [NSDictionary new];
    NSData *imageData = [image dk_toData:options type:DKBitMapImageTypeBMP];
    [imageData writeToFile:dirFile atomically:YES];
```

