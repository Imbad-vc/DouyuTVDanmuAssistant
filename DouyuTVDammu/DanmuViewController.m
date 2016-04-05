//
//  DanmuViewController.m
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/15.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "DanmuViewController.h"
#import "DanmuModel.h"
#import "DanmuCell.h"
#import "MyDataService.h"
#import "HMSegmentedControl.h"



@interface DanmuViewController ()

@end

@implementation DanmuViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    CGFloat screenWidth = CGRectGetWidth(self.view.frame);
    CGFloat screenHeight = CGRectGetHeight(self.view.frame);
    CGFloat topLayOut = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])+CGRectGetHeight(self.navigationController.navigationBar.frame);
    //保持屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    //添加收藏按钮★☆hi
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"☆" style:UIBarButtonItemStylePlain target:self action:@selector(favroiteButtonAciton)];
    if ([self isFavroiteRoom]) {
        self.navigationItem.rightBarButtonItem.title = @"★";
    }
    
    //创建SegmentedControl
    self.sgmControl = [[HMSegmentedControl alloc]initWithFrame:CGRectMake(0, topLayOut, screenWidth, 40)];
    self.sgmControl.sectionTitles = @[@"弹幕",@"礼物",@"详情",@"搜索"];
    self.sgmControl.selectedSegmentIndex = 0;
    self.sgmControl.backgroundColor = [UIColor whiteColor];
    self.sgmControl.titleTextAttributes = @{
                                            NSForegroundColorAttributeName: [UIColor grayColor],
                                            NSFontAttributeName: [UIFont systemFontOfSize:15],
                                        };
    self.sgmControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    self.sgmControl.selectionIndicatorColor = [UIColor orangeColor];
    self.sgmControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.sgmControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    [self.view addSubview:self.sgmControl];
    //创建ScrollView
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sgmControl.frame), screenWidth,screenHeight-topLayOut-CGRectGetHeight(self.sgmControl.frame))];
    scrollView.contentSize = CGSizeMake(screenWidth*4, 200);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    [self.sgmControl setIndexChangeBlock:^(NSInteger index) {
        [scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(scrollView.frame)*index, 0, CGRectGetWidth(scrollView.frame), 200) animated:YES];
    }];
    //
    //添加两个tableView
    self.danmuTableView = [[DanmuTableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, CGRectGetHeight(scrollView.frame))];
    self.giftTableView = [[GiftTableView alloc]initWithFrame:CGRectMake(screenWidth, 0, screenWidth, CGRectGetHeight(scrollView.frame))];
    //添加detailView
    self.detailView = [DetailView appView];
    self.detailView.frame = CGRectMake(screenWidth*2, 0, screenWidth, CGRectGetHeight(scrollView.frame));
    //添加searchView
    self.searchView = [SearchView appView];
    [self.searchView.searchTableView registerClass:[DanmuCell class] forCellReuseIdentifier:@"danmuCell"];
    self.searchView.frame = CGRectMake(screenWidth*3, 0,CGRectGetWidth(self.view.frame), CGRectGetHeight(scrollView.frame));
    self.searchView.searchBar.delegate = self;
    //先读缓存的礼物信息
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"gift.plist" ofType:nil];
    NSArray *giftInfo = [NSArray arrayWithContentsOfFile:filePath];
    if (giftInfo.count != 0) {
        self.danmuTableView.giftInfo = giftInfo;
        self.giftTableView.giftInfo = giftInfo;
    }
    
    [scrollView addSubview:self.danmuTableView];
    [scrollView addSubview:self.giftTableView];
    [scrollView addSubview:self.detailView];
    [scrollView addSubview:self.searchView];
    //创建maskView
    self.maskView = [[UIView alloc]initWithFrame:self.view.frame];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.maskView addGestureRecognizer:tapGesture];
    self.maskView.hidden = YES;
    [self.view addSubview:self.maskView];

    [self _requestData];
   
        //链接服务器
    _authSocket = [AuthSocket new];
    _authSocket.room = self.roomID;
    [_authSocket connectSocketHost];
    _danmuSocket = [DanmuSocket new];
    _danmuSocket.room = _authSocket.room;
    //weak处理防止block循环
    __weak DanmuSocket *danmuSocket = _danmuSocket;
    _authSocket.InfoBlock = ^(NSString *vistorID,NSString *groupID){
        danmuSocket.vistorID = vistorID;
        danmuSocket.groupID = groupID;
        [danmuSocket connectSocketHost];
        
    };
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //关闭常亮
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    //断开链接
    [_authSocket cutOffSocket];
    [_danmuSocket cutOffSocket];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (self.searchView.data == nil) {
        self.searchView.data = @[].mutableCopy;
    }else{
        [self.searchView.data removeAllObjects];
    }
    
    dispatch_queue_t search = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(search, ^{
        if (self.danmuTableView.dataCache.count != 0) {
            for (DanmuModel *model in self.danmuTableView.data) {
                NSInteger searchText = [model.unColoredMsg rangeOfString:searchBar.text].location;
                if (searchText != NSNotFound) {
                    [self.searchView.data addObject:model];
                }
                
            }
            for (DanmuModel *model in self.danmuTableView.dataCache) {
                NSInteger searchText = [model.unColoredMsg rangeOfString:searchBar.text].location;
                if (searchText != NSNotFound) {
                    [self.searchView.data addObject:model];
                }
                
            }
        }else{
            for (DanmuModel *model in self.danmuTableView.data) {
                NSInteger searchText = [model.unColoredMsg rangeOfString:searchBar.text].location;
                if (searchText != NSNotFound) {
                    [self.searchView.data addObject:model];
                }
                
            }
            
        }
        [self.searchView.searchTableView reloadData];
        
    });
    
    self.maskView.hidden = YES;
    [searchBar resignFirstResponder];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.maskView.hidden = NO;
}

- (void)hideKeyboard{
    [self.searchView.searchBar resignFirstResponder];
    self.maskView.hidden = YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    switch (page) {
        case 0:
            self.giftTableView.isNeedScroll = NO;
            self.danmuTableView.isNeedScroll = YES;
            [self.danmuTableView reloadData];
            break;
        case 1:
            self.giftTableView.isNeedScroll = YES;
            self.danmuTableView.isNeedScroll = NO;
            [self.giftTableView reloadData];
            break;
        default:
            self.giftTableView.isNeedScroll = NO;
            self.danmuTableView.isNeedScroll = NO;
            break;
    }
    [self.sgmControl setSelectedSegmentIndex:page animated:YES];
}

//获取房间（礼物）信息
- (void)_requestData{
    /*
     aid=android&client_sys=android&time=<time>&auth=c0a6170a754ca187e8a52a3343ecf273
     auth: md5("room/"+roomid+"?aid=android&clientsys=android&time="+1231)
     */
    NSString *url = [NSString stringWithFormat:@"room/%@",_roomID];
    NSString *time = [NSString timeString];
    NSString *auth = [[NSString stringWithFormat:@"room/%@?aid=android&client_sys=android&time=%@1231",_roomID,time] getMd5_32Bit];
    NSDictionary *params = @{@"aid":@"android",
                             @"client_sys":@"android",
                             @"time":time,
                             @"auth":auth
                             };
   [MyDataService requestURL:url
                  httpMethod:@"GET"
                  params:params
                  completion:^(id result, NSError *error) {
                      NSDictionary *jsDic = result;
                      self.detailModel = [RoomDetailModel new];
                      [self.detailModel setModelFromDictionary:jsDic];
                      self.detailView.model = self.detailModel;
                      //将礼物信息储存到本地
                      NSString *filePath = [[NSBundle mainBundle] pathForResource:@"gift.plist" ofType:nil];
                      [self.detailModel.gift writeToFile:filePath atomically:YES];
                      //赋值给tableView
                      self.danmuTableView.giftInfo = self.detailModel.gift;
                      self.giftTableView.giftInfo = self.detailModel.gift;
                      
                      self.navigationItem.title = _detailModel.ownerName;
                  }];
    
    
}
#pragma mark - 收藏按钮Action
- (void)favroiteButtonAciton{

    NSDictionary *room = @{@"roomID":self.roomID,@"ownerName":_detailModel.ownerName};
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSArray *favroite = [defaults objectForKey:@"favroiteRoom"];
    NSMutableArray *newArry;
    NSArray *newFavroite;
    if (favroite == nil) {
        newFavroite = @[room];
        self.navigationItem.rightBarButtonItem.title = @"★";
    }else{
        newArry = favroite.mutableCopy;
        if ([self isFavroiteRoom]) {
            for (int i = 0; i <= newArry.count; i++) {
                NSDictionary *room = newArry[i];
                if ([self.roomID isEqualToString:room[@"roomID"]]) {
                    [newArry removeObjectAtIndex:i];
                    break;
                }
            }
            self.navigationItem.rightBarButtonItem.title = @"☆";
        }else{
            [newArry addObject:room];
            self.navigationItem.rightBarButtonItem.title = @"★";
        }
        newFavroite = newArry;
    }
    [defaults setObject:newFavroite forKey:@"favroiteRoom"];
}



- (BOOL)isFavroiteRoom{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSArray *favroite = [defaults objectForKey:@"favroiteRoom"];
    if (favroite != nil) {
        for (NSDictionary *room in favroite) {
            if ([self.roomID isEqualToString:room[@"roomID"]]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
