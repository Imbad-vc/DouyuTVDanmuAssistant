//
//  DetailView.m
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/15.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "DetailView.h"
#import "MyDataService.h"
#import "NSString+InfoGet.h"

@implementation DetailView

+ (instancetype)appView{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"DetailView" owner:nil options:nil];
    return [objs lastObject];
}


- (void)setModel:(RoomDetailModel *)model{
    _model = model;
    _roomName.text = _model.roomName;
    _details.text = _model.details;
    _ownerName.text = _model.ownerName;
    _online.text = _model.online;
    _ownerWeight.text = _model.ownerWeight;
    _fans.text = _model.fans;
    _gameName.text = _model.gameName;
    [self layoutIfNeeded];
}
@end
