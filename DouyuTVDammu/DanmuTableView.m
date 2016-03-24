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
        //绑定代理
        self.delegate = self;
        self.dataSource = self;
        //取消下划线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册Cell
        [self registerClass:[DanmuCell class] forCellReuseIdentifier:@"danmuCell"];
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
    return cell;
}

#pragma  mark -- UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DanmuModel *model = self.data[indexPath.row];
    CGSize size = [model.unColoredMsg sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-16, MAXFLOAT)];
    CGFloat height = size.height + 16;
    
    return height;
}
- (void)receiveNotification:(NSNotification *)notification {
    
    NSString *string = notification.object;
    //判断消息类型
    if ([string rangeOfString:@"type@=mrkl"].location == NSNotFound) {
        DanmuModel *model = [DanmuModel new];
        if ([string rangeOfString:@"type@=chatmsg"].location != NSNotFound) {
            model.cellType = CellNewChatMessageType;
            [model setModelFromStirng:string];
            
        }else if ([string rangeOfString:@"type@=dgb/gfid"].location != NSNotFound){
            model.cellType = CellNewGiftType;
            model.gift = self.giftInfo;
            [model setModelFromStirng:string];
            
        }else if ([string rangeOfString:@"type@=uenter"].location != NSNotFound){
            model.cellType = CellNewUserEnterType;
            
        }else if ([string rangeOfString:@"type@=blackres"].location != NSNotFound){
            model.cellType = CellBanType;
        }else if ([string rangeOfString:@"type@=userenter"].location != NSNotFound){
            model.cellType = CellUserEnterType;
            
        }else if ([string rangeOfString:@"type@=chatmessage"].location != NSNotFound){
            model.cellType = CellChatMessageType;
        }else if ([string rangeOfString:@"type@=dgn/gfid"].location != NSNotFound){
            model.cellType = CellGiftType;
             model.gift = self.giftInfo;
        }else if ([string rangeOfString:@"type@=bc_buy_deserve"].location != NSNotFound){
            model.cellType = CellDeserveType;
        }else{
            NSLog(@"%@",string);
            model = nil;
            return;
        }
        [model setModelFromStirng:string];
        //将model对象加入到信息model数组里面
        [self.data addObject:model];
        //刷新数据，更新界面
        [self reloadData];
        //将最后一个单元格滚动到表视图的底部显示
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.data.count-1 inSection:0];
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
