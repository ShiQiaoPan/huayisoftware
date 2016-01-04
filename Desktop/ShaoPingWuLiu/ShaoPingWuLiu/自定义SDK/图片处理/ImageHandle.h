//
//  ImageHandle.h
//  ShaoPingWuLiu
//
//  Created by WeiPan on 15/12/14.
//  Copyright © 2015年 HuaYiSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHandle : NSObject
+ (NSString *)imageFileWithImageName:(NSString *)imageName;
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
+ (NSData *)readImageWithImageName:(NSString *)imageName;
+ (void)deleteImageWithImageName:(NSString *)imageName;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
@end
