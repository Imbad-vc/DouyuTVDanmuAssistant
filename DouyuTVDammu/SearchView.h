//
//  SearchView.h
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/22.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchView : UIView

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong)NSMutableArray *data;


+ (instancetype)appView;
@end
