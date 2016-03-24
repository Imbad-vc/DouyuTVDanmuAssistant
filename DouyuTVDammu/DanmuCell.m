//
//  DanmuCell.m
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/12.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "DanmuCell.h"

@implementation DanmuCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //取消单元格选中效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //创建子视图
        [self _createSubViews];
    }
    return self;
}

- (void)_createSubViews{
    
    _msg = [[UILabel alloc]initWithFrame:CGRectZero];
    _msg.font = [UIFont systemFontOfSize:15];
    _msg.numberOfLines = 0;
    [self.contentView addSubview:_msg];
}

- (void)setModel:(DanmuModel *)model{
    _model = model;
    _msg.attributedText = _model.coloredMsg;
    NSString *msg = _model.unColoredMsg;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [msg sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(width-16, MAXFLOAT)];
    //取出内容计算后的高度
    CGFloat height = size.height;
    
    
    _msg.frame = CGRectMake(8, 8, width-16, height);

    
}

@end
