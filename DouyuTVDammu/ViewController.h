//
//  ViewController.h
//  DouyuTVDammu
//
//  Created by LuChen on 16/2/26.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *roomTextField;
@property (weak, nonatomic) IBOutlet UITableView *favroiteTableView;
@property (nonatomic,strong)UIView *maskView;
@property (nonatomic,strong)NSArray *favData;

@end

