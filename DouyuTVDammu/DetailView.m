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
    _headImage.layer.cornerRadius = CGRectGetWidth(_headImage.bounds)/2;
    _headImage.layer.masksToBounds = YES;
    
    _headImage.layer.borderWidth = 2;
    _headImage.layer.borderColor = [[UIColor orangeColor] CGColor];
    _headImage.image = [UIImage imageNamed:@"Image_column_default"];
    _stautsView.layer.cornerRadius = 4*M_PI;
    _stautsView.layer.masksToBounds = YES;
    [self layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(), ^{
        _headImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.ownerAvatarURL]]];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *rmScreen = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_model.roomSrceenURL]]];
        UIImageView *roomScreen = [[UIImageView alloc]initWithImage:rmScreen];
        roomScreen.frame = CGRectMake(0, 0, CGRectGetWidth(_stautsView.frame), CGRectGetHeight(_stautsView.frame));
        [_stautsView addSubview:roomScreen];
        switch (_model.showStatus) {
            case 1:
            {
                UIImage *playing = [UIImage imageNamed:@"Image_playing"];
                UIImageView *isPlaying = [[UIImageView alloc]initWithImage:playing];
                isPlaying.frame = CGRectMake(0, 0, 86, 28);
                [_stautsView addSubview:isPlaying];
            }
                break;
             case 2:
            {
                UIImage *offLine = [UIImage imageNamed:@"image_finished"];
                UIImageView *isOffLine = [[UIImageView alloc]initWithImage:offLine];
                isOffLine.frame = CGRectMake(0, 0, CGRectGetWidth(_stautsView.frame), CGRectGetHeight(_stautsView.frame));
                [_stautsView addSubview:isOffLine];
 
            }
            default:
                break;
        }
        
        
        
    });
    [self layoutIfNeeded];
}
@end
