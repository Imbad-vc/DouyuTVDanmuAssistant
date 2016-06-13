//
//  AuthSocket.m
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/2.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "AuthSocket.h"

static AuthSocket *instance = nil;
@implementation AuthSocket
//单例
+ (id)sharedInstance{
    @synchronized(self) {
        if (instance == nil) {
            
            instance = [[AuthSocket alloc]init];
        }
    }
    return instance;
}

- (void)setServerConfig{
    
    //拼接字符串
    NSString *roomAdr = [NSString stringWithFormat:@"http://www.douyutv.com/%@",self.room];
    //定义房间的URL
    NSURL *roomURL = [NSURL URLWithString:roomAdr];
    //讲网页源码转换成字符串
    NSString *htmlCode = [[NSString alloc] initWithContentsOfURL:roomURL encoding:NSUTF8StringEncoding error:nil];
    //找到相关字典所在的位置并截取
    NSRange serverRange = [htmlCode rangeOfString:@"server_config"];
    NSString *jsRoomDic = [htmlCode substringFromIndex:serverRange.location + serverRange.length+3];
    NSRange jsDic = [jsRoomDic rangeOfString:@"def_disp_gg"];
    NSString *room_args = [jsRoomDic substringToIndex:jsDic.location-3];
    //拿到登陆服务器并decode
    NSString *encodeCfg = room_args;
    NSString *decodeCfg = [encodeCfg stringByRemovingPercentEncoding];
    NSData *sevIP = [decodeCfg dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *sevArray = [NSJSONSerialization JSONObjectWithData:sevIP options:NSJSONReadingMutableLeaves error:nil];
    //转换成model，添加到属性
    self.server = @[].mutableCopy;
    for (int i = 0; i < sevArray.count; i++) {
        ServerModel *model = [ServerModel new];
        NSDictionary *sevCfg = sevArray[i];
        model.ip = sevCfg[@"ip"];
        model.port = [sevCfg[@"port"] intValue];
        [self.server addObject:model];
    }
    
    
}

#pragma marl --回调方法
//连接成功
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"---认证服务器连接成功---");
    /*
     验证服务器包
     type@=loginreq/username@=/ct@=0/password@=/roomid@=43053/devid@=479512DA70520865088A9A52B53242FB/rt@=1450509705/vk@=d2494e478b4229e3c98a398c8ae2c8f3/ver@=20150929/
     roomid:房间id
     devid:随机UUID
     rt:时间戳
     vk:时间戳+"7oE9nPEG9xXV69phU31FYCLUagKeYtsF"+devid的字符串拼接结果的MD5值
     ver:版本号
     */
    NSString *devid = [NSString uuid];
    NSString *timeString = [NSString timeString];
    NSString *unMD5vk = [NSString stringWithFormat:@"%@%@%@",timeString,kMagicCode,devid];
    NSString *vk = [unMD5vk getMd5_32Bit];
    
    NSString *postLogin = [NSString stringWithFormat:@"type@=loginreq/username@=/ct@=0/password@=/roomid@=%@/devid@=%@/rt@=%@/vk@=%@/ver@=20150929/",self.room,devid,timeString,vk];
    NSData *postLoginData = [self packToData:postLogin];
    [self.socket writeData:postLoginData withTimeout:30 tag:1];
    
}

//接受数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    if (data.length != 0){
        NSInteger endCode = 0;
        //获取data末尾字节
        [data getBytes:&endCode range:NSMakeRange(data.length-1, 1)];
        if (self.combieData == nil) {
            self.combieData = [[NSMutableData alloc]init];
        }
        //如果为0则代表这是一段完整的数据，可以进行解析
        //若无，则需要拼接至一段完整数据才进行解析
        if (endCode == 0) {
            [self.combieData appendData:data];
            [SocketData douyuData:self.combieData isAuthData:YES];
            self.combieData = nil;
        }else{
            [self.combieData appendData:data];
        }
    }
    [self.socket readDataWithTimeout:kReadTimeOut buffer:nil bufferOffset:0 maxLength:kMaxBuffer tag:0];
    
}


//断开链接
- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"---认证服务器断开---");
}

@end
