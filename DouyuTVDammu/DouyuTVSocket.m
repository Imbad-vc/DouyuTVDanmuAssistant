//
//  DouyuTVSocket.m
//  DouyuTVDammu
//
//  Created by LuChen on 16/2/26.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "DouyuTVSocket.h"




@implementation DouyuTVSocket

- (void)setServerConfig{
    
}

//连接服务器
- (void)connectSocketHost{
    self.socket = [[AsyncSocket alloc]initWithDelegate:self];
    [self setServerConfig];
    NSError *error = nil;
    ServerModel *sevCfg = self.server[5];

    [self.socket connectToHost:sevCfg.ip onPort:sevCfg.port withTimeout:30 error:&error];
    
}
//用户切断链接
- (void)cutOffSocket{
    [self.connectTimer invalidate];
    [self.socket disconnect];
    
}
//心跳包
- (void)longConnectToSocket{
    
    //keep live 所发送的信息
}

#pragma marl --回调方法
//连接成功
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    

}
//断开链接
- (void)onSocketDidDisconnect:(AsyncSocket *)sock{

}

//发送消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //读取消息
    [self.socket readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:kMaxBuffer tag:0];
}
//接受数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    if (data.length != 0){
        NSInteger endCode;
        //获取data末尾字节
        [data getBytes:&endCode range:NSMakeRange(data.length-1, 1)];
        if (self.combieData == nil) {
            self.combieData = [[NSMutableData alloc]init];
        }
        //如果为0则代表这是一段完整的数据，可以进行解析
        //若无，则需要拼接至一段完整数据才进行解析
        if (endCode == 0) {
            [self.combieData appendData:data];
            [SocketData douyuData:self.combieData isAuthData:NO];
            self.combieData = nil;
        }else{
            [self.combieData appendData:data];
        }
    }
    [self.socket readDataWithTimeout:kReadTimeOut buffer:nil bufferOffset:0 maxLength:kMaxBuffer tag:0];
}

- (NSData *)packToData:(NSString *)string{
    NSMutableData *stringData = [string stringToHexData];
    unsigned int hexLength = (int)string.length+9;
    PostPack pack = {hexLength,hexLength,kPostCode};
    
    NSMutableData *postDate = [NSData dataWithBytes:&pack length:sizeof(pack)].mutableCopy;
    [postDate appendData:stringData];
    [postDate appendBytes:&kEnd length:1];
    return postDate;
}

@end
