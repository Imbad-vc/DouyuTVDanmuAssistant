//
//  SearchView.m
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/22.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

+ (instancetype)appView{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"SearchView" owner:nil options:nil];
    return [objs lastObject];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
