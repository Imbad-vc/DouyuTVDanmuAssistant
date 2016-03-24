//
//  DetailView.h
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/15.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomDetailModel.h"

@interface DetailView : UIView
/*
 @property (nonatomic,copy)NSString *roomName;
 @property (nonatomic,copy)NSString *ownerName;
 @property (nonatomic,copy)NSString *details;
 @property (nonatomic,copy)NSString *ownerWeight;
 @property (nonatomic,copy)NSString *fans;
 @property (nonatomic,copy)NSString *gameName;
 @property (nonatomic,strong)NSArray *gift;
 */

@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *details;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (weak, nonatomic) IBOutlet UILabel *online;
@property (weak, nonatomic) IBOutlet UILabel *ownerWeight;
@property (weak, nonatomic) IBOutlet UILabel *fans;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (nonatomic,strong)RoomDetailModel *model;

+ (instancetype)appView;

@end
