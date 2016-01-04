//
//  ImageHandle.m
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/14.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import "ImageHandle.h"

@implementation ImageHandle
+ (NSString *)imageFileWithImageName:(NSString *)imageName {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    return fullPathToFile;
}
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = [NSData data];
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(tempImage)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(tempImage);
    }
    else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
    }
    if (imageData.bytes) {
        // and then we write it out
        [imageData writeToFile:[self imageFileWithImageName:imageName] atomically:NO];
    }
}
+ (NSData *)readImageWithImageName:(NSString *)imageName {
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString * fullPathToFile = [self imageFileWithImageName:imageName];
    NSData * imageData = [NSData data];
    if ([manager fileExistsAtPath:fullPathToFile]) {
        imageData = [manager contentsAtPath:fullPathToFile];
    }
    return imageData;
}
+ (void)deleteImageWithImageName:(NSString *)imageName {
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[self imageFileWithImageName:imageName]]) {
        [manager removeItemAtPath:[self imageFileWithImageName:imageName] error:nil];
    }
}
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}
@end
