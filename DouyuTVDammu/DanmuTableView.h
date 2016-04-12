//
//  DanmuTableView.h
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/20.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DanmuCell.h"
#import "DanmuModel.h"

@interface DanmuTableView : UITableView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSMutableArray *dataCache;
@property (nonatomic,strong)NSArray *giftInfo;
@property (nonatomic,assign)BOOL isNeedScroll;

@end
