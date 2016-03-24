//
//  DanmuViewController.h
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/15.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthSocket.h"
#import "DanmuSocket.h"
#import "RoomDetailModel.h"
#import "DetailView.h"
#import "HMSegmentedControl.h"
#import "DanmuTableView.h"
#import "GiftTableView.h"
#import "SearchView.h"

@interface DanmuViewController : UIViewController <UIScrollViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong)AuthSocket *authSocket;
@property (nonatomic,strong)DanmuSocket *danmuSocket;
@property (nonatomic,strong)HMSegmentedControl *sgmControl;
@property (nonatomic,strong)DanmuTableView *danmuTableView;
@property (nonatomic,strong)GiftTableView *giftTableView;
@property (nonatomic,strong)DetailView *detailView;
@property (nonatomic,strong)SearchView *searchView;
@property (nonatomic,strong)UIView *maskView;
@property (nonatomic,strong)NSString *roomID;
@property (nonatomic,strong)RoomDetailModel *detailModel;

@end
