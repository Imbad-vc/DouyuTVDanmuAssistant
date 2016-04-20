//
//  SocketData.m
//  DouyuTVDammuAssistant
//
//  Created by LuChen on 16/4/20.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "SocketData.h"
#import "AuthSocket.h"
@interface SocketData ()

@property (nonatomic,assign)NSInteger loction;
@property (nonatomic,assign)NSInteger length;

@end

@implementation SocketData


+ (void)douyuData:(NSData *)data{
    SocketData *socketData = [SocketData new];
    NSMutableArray *contents = @[].mutableCopy;
    NSData *subData = data.copy;
    socketData.loction = 0;
    do {
        
        socketData.loction += 12;
        [subData getBytes:&socketData->_length range:NSMakeRange(0, 4)];
        socketData.length -= 8;
        NSData *contentData = [subData subdataWithRange:NSMakeRange(12, socketData.length)];
        NSString *content = [[NSString alloc]initWithData:contentData encoding:NSUTF8StringEncoding];
        
        subData = [data subdataWithRange:NSMakeRange(socketData.length+socketData.loction, data.length-socketData.length-socketData.loction)];
        
        [contents addObject:content];
        
        socketData.loction += socketData.length;

    } while (socketData.loction < data.length);
    
    
    AuthSocket *authSocket = [AuthSocket sharedInstance];
    //遍历数组，提取ID
    for (NSString *msg in contents) {
        
        if ([msg rangeOfString:@"login"].location != NSNotFound) {
            NSRange range = [msg rangeOfString:@"username@="];
            NSString *unSubString = [msg substringFromIndex:range.location + range.length];
            authSocket.vistorID = [unSubString substringToIndex:[unSubString rangeOfString:@"/"].location];
        }else if ([msg rangeOfString:@"gid"].location != NSNotFound) {
            NSRange range = [msg rangeOfString:@"gid@="];
            NSString *unSubSring = [msg substringFromIndex:range.location + range.length];
            authSocket.groupID = [unSubSring substringToIndex:[unSubSring rangeOfString:@"/"].location];
        }
    }
    //将2个ID传出去
    if (authSocket.vistorID.length != 0 && authSocket.groupID.length != 0) {
        NSLog(@"---获得游客ID以及弹幕组---");
        
        authSocket.InfoBlock(authSocket.vistorID,authSocket.groupID);
    }
    
}

@end
