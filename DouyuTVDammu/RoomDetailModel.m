//
//  RoomDetailModel.m
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/17.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "RoomDetailModel.h"

@implementation RoomDetailModel

- (void)setModelFromDictionary:(NSDictionary *)dic{
    NSDictionary *data = dic[@"data"];
    _roomName = data[@"room_name"];
    _gameName = data[@"game_name"];
    _ownerName = data[@"nickname"];
    _details = data[@"show_details"];
    _ownerWeight = data[@"owner_weight"];
    _ownerAvatarURL = data[@"owner_avatar"];
    _roomSrceenURL = data[@"room_src"];
    _showStatus = [data[@"show_status"]integerValue];
    _online =[NSString stringWithFormat:@"%@",data[@"online"]];
    _gift = data[@"gift"];
    _fans = [NSString stringWithFormat:@"%@",data[@"fans"]];
}

@end
