//
//  DetailViewController.m
//  CalendarEventSdk
//
//  Created by Clement on 15/1/14.
//  Copyright (c) 2015年 Clement. All rights reserved.
//

#import "DetailViewController.h"
#import <EventKit/EventKit.h>
#import "EventViewController.h"
#import "EventManger.h"

@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)goBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
- (IBAction)addNewEvent:(id)sender;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSLog(@"%@",self.eventArray);
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    EKEvent *event = [self.eventArray objectAtIndex:indexPath.row];
    NSLog(@"%@",event);
    cell.textLabel.text = event.title;
    NSLog(@"%@",event.title);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy年MM月dd日 HH:mm"];
    cell.detailTextLabel.text = [formatter stringFromDate:event.startDate];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EKEvent *event = [self.eventArray objectAtIndex:indexPath.row];
    EventViewController *eventView = [[EventViewController alloc]initWithNibName:@"EventViewController" bundle:nil];
    eventView.event = event;
    eventView.status = 2;
    [self presentViewController:eventView animated:YES completion:^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addNewEvent:(id)sender {
    EventViewController *eventView = [[EventViewController alloc]initWithNibName:@"EventViewController" bundle:nil];
    eventView.status = 1;
    [self presentViewController:eventView animated:YES completion:nil];
    
}
@end
