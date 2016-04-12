//
//  DanmuTableView.m
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/20.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "DanmuTableView.h"


@implementation DanmuTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.data = @[].mutableCopy;
        self.dataCache = @[].mutableCopy;
        //绑定代理
        self.delegate = self;
        self.dataSource = self;
        //取消下划线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        //设置背景色
        self.backgroundColor = [UIColor colorWithRed:236/255.0 green:237/255.0 blue:241/255.0 alpha:1];
        //注册Cell
        [self registerClass:[DanmuCell class] forCellReuseIdentifier:@"danmuCell"];
        self.isNeedScroll = YES;
        if ([self respondsToSelector:@selector(setEstimatedRowHeight:)]) {
            self.estimatedRowHeight = 40;
        }
        //监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"kReceiveMessageNotification" object:nil];
        

    }
    return self;
}


#pragma mark ----UITableViewDataSource----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DanmuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"danmuCell" forIndexPath:indexPath];
    cell.model = self.data[indexPath.row];
    cell.label.preferredMaxLayoutWidth = CGRectGetWidth(self.frame)-10;
    cell.label.textContainer = [cell.label.textContainer createTextContainerWithTextWidth:CGRectGetWidth(self.frame)-10];
    return cell;
}

#pragma  mark -- UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;

}

#pragma mark --UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    if (distanceFromBottom < height) {
        self.isNeedScroll = YES;
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (velocity.y < 0 | velocity.y == 0) {
        self.isNeedScroll = NO;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isNeedScroll = NO;
}

- (void)receiveNotification:(NSNotification *)notification {
    
    NSString *string = notification.object;
    //判断消息类型
    if ([string rangeOfString:@"type@=mrkl"].location == NSNotFound) {
        DanmuModel *model = [DanmuModel new];
        if ([string rangeOfString:@"type@=chatmsg"].location != NSNotFound) {
            model.cellType = CellNewChatMessageType;
            
        }else if ([string rangeOfString:@"type@=dgb"].location != NSNotFound){
            model.cellType = CellNewGiftType;
            model.gift = self.giftInfo;
            
        }else if ([string rangeOfString:@"type@=uenter"].location != NSNotFound){
            model.cellType = CellNewUserEnterType;
            
        }else if ([string rangeOfString:@"type@=blackres"].location != NSNotFound){
            model.cellType = CellBanType;
            
        }else if ([string rangeOfString:@"type@=bc_buy_deserve"].location != NSNotFound){
            model.cellType = CellDeserveType;
        }else{
            NSLog(@"%@",string);
            model = nil;
            return;
        }
        [model setModelFromStirng:string];
        
        if (self.data.count > 200) {
            
            [self.dataCache addObjectsFromArray:[self.data subarrayWithRange:NSMakeRange(0, 100)]];
            [self.data removeObjectsInRange:NSMakeRange(0, 100)];
        }
        
        //将model对象加入到信息model数组里面
        [self.data addObject:model];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //刷新数据，更新界面
            [self reloadData];
            //是否需要滑动到最后
            if (self.isNeedScroll == YES) {
                //将最后一个单元格滚动到表视图的底部显示
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.data.count-1 inSection:0];
                [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                
            }
        });
        
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DanmuModel *model = self.data[indexPath.row];
    NSLog(@"%@",model.dataString);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
