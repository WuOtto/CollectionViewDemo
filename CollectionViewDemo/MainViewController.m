//
//  MainViewController.m
//  CollectionViewDemo
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 otto. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray *titleArr;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArr = [NSMutableArray array];
    
    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
    [self addCellTitle:@"iOS9 CollectionViewCell移动" class:@"SystemViewController"];
    [self addCellTitle:@"自定义 CollectionViewCell移动" class:@"CustomViewController"];
    [self addCellTitle:@"自定义 CollectionViewCell移动 不切换位置" class:@"CustomFileViewController"];

}

- (void)addCellTitle:(NSString *)title class:(NSString *)className {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",className,@"className", nil];
    [self.titleArr addObject:dic];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"newCell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    NSDictionary *dic = self.titleArr[indexPath.row];
    
    cell.textLabel.text = dic[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.titleArr[indexPath.row];
    NSString *className = dic[@"className"];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctl = class.new;
        ctl.navigationItem.title = dic[@"title"];
        [self.navigationController pushViewController:ctl animated:YES];
    }
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
