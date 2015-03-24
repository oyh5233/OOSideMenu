//
//  ViewController.m
//  OOSideMenu
//
//  Created by oo on 15-3-24.
//  Copyright (c) 2015年 comein. All rights reserved.
//

#import "ViewController.h"
#import "OOSideMenu.h"
static NSString * cellId=@"cellId";
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=_backgroundColor;
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.rowHeight=64;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textAlignment=_alignment;
    cell.textLabel.text=[NSString stringWithFormat:@"------%ld------",indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_backgroundColor) {
        ViewController *viewController=[[ViewController alloc]init];
        viewController.backgroundColor=[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
        self.ooSideMenu.centerViewController=viewController;
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
