//
//  DanmuCell.h
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/12.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DanmuModel.h"
#import "TYAttributedLabel.h"

@interface DanmuCell : UITableViewCell

@property (nonatomic,strong)UILabel *msg;
@property (nonatomic, weak, readonly) TYAttributedLabel *label;
@property (nonatomic,strong)DanmuModel *model;

@end
