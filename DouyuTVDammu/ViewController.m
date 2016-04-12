//
//  ViewController.m
//  DouyuTVDammu
//
//  Created by LuChen on 16/2/26.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "ViewController.h"
#import "DanmuViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建maskView
    self.maskView = [[UIView alloc]initWithFrame:self.view.frame];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.maskView addGestureRecognizer:tapGesture];
    self.maskView.hidden = YES;
    [self.view addSubview:self.maskView];
    [self.favroiteTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.favroiteTableView.backgroundColor = [UIColor clearColor];
    self.favroiteTableView.rowHeight = 35;
    [self requestData];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
    [self.favroiteTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.favData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *room = self.favData[indexPath.row];
    NSString *cellString = [NSString stringWithFormat:@"主播:%@",room[@"ownerName"]];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = cellString;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DanmuViewController *dmViewC = [DanmuViewController new];
    NSDictionary *room = self.favData[indexPath.row];
    dmViewC.roomID = room[@"roomID"];
    dmViewC.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:dmViewC animated:YES];
}

#pragma mark ----UITextFieldDelegate----
//监听return按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length != 0) {
        
        //拼接字符串
        NSString *roomAdr = [NSString stringWithFormat:@"http://www.douyutv.com/%@",textField.text];
        //定义房间的URL
        NSURL *roomURL = [NSURL URLWithString:roomAdr];
        //讲网页源码转换成字符串
        NSString *htmlCode = [[NSString alloc] initWithContentsOfURL:roomURL encoding:NSUTF8StringEncoding error:nil];
        //找到相关字典所在的位置并截取
        NSRange serverRange = [htmlCode rangeOfString:@"server_config"];
        if (serverRange.location != NSNotFound) {
            [textField resignFirstResponder];
            DanmuViewController *dmViewC = [DanmuViewController new];
            dmViewC.roomID = textField.text;
            dmViewC.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationController pushViewController:dmViewC animated:YES];
            
        }else{
            UIAlertView *warning = [[UIAlertView alloc]initWithTitle:@"出错了！" message:@"该房间不存在或者已被斗鱼关闭，请确认输入无误。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [warning show];
        }
    }
    self.maskView.hidden = YES;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.maskView.hidden = NO;
}

- (void)hideKeyboard{
    [self.roomTextField resignFirstResponder];
    self.maskView.hidden = YES;
}

- (void)requestData{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSArray *favroite = [defaults objectForKey:@"favroiteRoom"];
    if (favroite != nil) {
        self.favData = favroite;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
