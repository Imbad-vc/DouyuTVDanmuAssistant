//
//  DanmuModel.h
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/12.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DanmuModel : NSObject

typedef NS_ENUM(NSInteger,CellType){
    CellChatMessageType,
    CellGiftType,
    CellUserEnterType,
    CellBanType,
    CellNewChatMessageType,
    CellNewGiftType,
    CellNewUserEnterType,
    CellDeserveType,
};
@property (nonatomic,copy)NSMutableAttributedString *coloredMsg;
@property (nonatomic,copy)NSString *unColoredMsg;
@property (nonatomic,assign)CellType cellType;
@property (nonatomic,strong)NSArray *gift;
- (void)setModelFromStirng:(NSString *)string;

@end
