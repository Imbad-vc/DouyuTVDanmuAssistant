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

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if ([self.searchTableView respondsToSelector:@selector(setEstimatedRowHeight:)]) {
            self.searchTableView.estimatedRowHeight = 40;
        }
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
