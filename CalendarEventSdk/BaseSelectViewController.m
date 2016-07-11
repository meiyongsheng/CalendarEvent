//
//  BaseSelectViewController.m
//  CalendarEventSdk
//
//  Created by Clement on 15/1/16.
//  Copyright (c) 2015年 Clement. All rights reserved.
//

#import "BaseSelectViewController.h"
#import "EventViewController.h"
@interface BaseSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *goBack;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BaseSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.titleLabel.text = self.baseTitle;
    
    [self.goBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.image = [UIImage imageNamed:@"gou.png"];
    imageV.tag = 123;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 5,300, 30)];
    label.text = [self.sourceArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:imageV];
    [cell.contentView addSubview:label];
    if ( !(self.defaultIndex == indexPath.row) ) {
        imageV.hidden = YES;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.defaultIndex inSection:0]];
    UIImageView *vi = (UIImageView *)[cell.contentView viewWithTag:123];
    vi.hidden = YES;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    vi = (UIImageView *)[cell.contentView viewWithTag:123];
    vi.hidden = NO;
    self.defaultIndex = indexPath.row;
    
    [self.delegate didSelectedObject:[self.sourceArray objectAtIndex:self.defaultIndex] title:self.baseTitle];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goBack:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
