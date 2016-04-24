//
//  SocketData.m
//  DouyuTVDammuAssistant
//
//  Created by LuChen on 16/4/20.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "SocketData.h"
#import "AuthSocket.h"
#import "DanmuSocket.h"


@implementation SocketData


+ (void)douyuData:(NSData *)data isAuthData:(BOOL)yesOrNo{
    NSMutableArray *contents = @[].mutableCopy;
    NSData *subData = data.copy;
    NSInteger _loction = 0;
    NSInteger _length;
    do {
        
        _loction += 12;
        //获取数据长度
        [subData getBytes:&_length range:NSMakeRange(0, 4)];
        _length -= 8;
        //截取相对应的数据
        NSData *contentData = [subData subdataWithRange:NSMakeRange(12, _length)];
        NSString *content = [[NSString alloc]initWithData:contentData encoding:NSUTF8StringEncoding];
        //截取余下的数据
        subData = [data subdataWithRange:NSMakeRange(_length+_loction, data.length-_length-_loction)];
        
        [contents addObject:content];
        
        _loction += _length;
        
    } while (_loction < data.length);
    if (yesOrNo) {
        [self readAuthMsg:contents];
    }else{
        [self readDanmuMsg:contents];
    }
    
    
}
+ (void)readDanmuMsg:(NSArray *)array{
    DanmuSocket *danmuSocket = [DanmuSocket sharedInstance];
    if (array.count == 1){
        NSString *string = [array firstObject];
        if ([string rangeOfString:@"type@=login"].location != NSNotFound) {
            //加入弹幕组
            NSString *jionGroup = [NSString stringWithFormat:@"type@=joingroup/rid@=%@/gid@=%@/",danmuSocket.room,danmuSocket.groupID];
            NSData *jGroupData = [danmuSocket packToData:jionGroup];
            [danmuSocket.socket writeData:jGroupData withTimeout:30 tag:1];
            //开始发送心跳包
            [danmuSocket startKLTimer];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kReceiveMessageNotification" object:string];
        }
    }else{
        for (NSString * msg in array) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kReceiveMessageNotification" object:msg];
        }
    }
    
}
+ (void)readAuthMsg:(NSArray *)array{
    AuthSocket *authSocket = [AuthSocket sharedInstance];
    //遍历数组，提取ID
    for (NSString *msg in array) {
        
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
    [authSocket cutOffSocket];
}

@end
