//
//  NSString+InfoGet.m
//  
//
//  Created by LuChen on 16/2/26.
//
//

#import "NSString+InfoGet.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (InfoGet)

- (NSString *)getMd5_32Bit {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

@end
