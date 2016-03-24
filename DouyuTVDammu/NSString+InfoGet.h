//
//  NSString+InfoGet.h
//  
//
//  Created by LuChen on 16/2/26.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (InfoGet)

- (NSString *)getMd5_32Bit;//MD5加密
+ (NSString *)uuid;//获取随机UUID
+ (NSString *)timeString;//获取时间戳（秒）
- (NSMutableData *)stringToHexData;//转换16位的data
+ (NSString *)hexDateToString:(NSData *)data;//将16进制的data转换为字符串
- (NSString *)regexString:(NSString *)pattern;
- (CGFloat)getLableSize:(NSString *)content sizeNeed:(NSString *)heightOrWidth font:(UIFont *)font;
@end
