//
//  RoomDetailModel.h
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/17.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomDetailModel : NSObject

@property (nonatomic,copy)NSString *roomName;
@property (nonatomic,copy)NSString *ownerName;
@property (nonatomic,copy)NSString *details;
@property (nonatomic,copy)NSString *ownerWeight;
@property (nonatomic,copy)NSString *gameName;
@property (nonatomic,strong)NSArray *gift;
@property (nonatomic,copy)NSString *online;
@property (nonatomic,copy)NSString *fans;
@property (nonatomic,copy)NSString *ownerAvatarURL;
@property (nonatomic,copy)NSString *roomSrceenURL;
@property (nonatomic,assign)NSInteger showStatus;


- (void)setModelFromDictionary:(NSDictionary *)dic;

@end
