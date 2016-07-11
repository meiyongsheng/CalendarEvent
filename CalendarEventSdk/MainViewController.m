//
//  MainViewController.m
//  CalendarEventSdk
//
//  Created by Clement on 15/1/5.
//  Copyright (c) 2015年 Clement. All rights reserved.
//

#import "MainViewController.h"
#import "EventManger.h"
#import "DetailViewController.h"
#import "EventViewController.h"

@interface MainViewController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (retain,nonatomic) EKEventStore *store;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) NSArray *optionList;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"start");
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = @"事件列表";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navItem.titleView = titleLabel;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewEvent)];
    self.navItem.rightBarButtonItem = rightItem;
    
    
    self.optionList = @[@"今天的事件",@"本周从周日算起的事件",@"本周从周一算起的事件",@"本月从一号算起的事件",@"今天15天前到15天后的事件"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    
    
//    EventManger *manger = [EventManger shareInstance];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"SSSS"];
//        NSLog(@"%@",[formatter stringFromDate:[NSDate date]]);
//    self.store = [[EKEventStore alloc]init];
//    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//        
//    }];
//        NSLog(@"%@",[formatter stringFromDate:[NSDate date]]);
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"mmssSSS"];
//    NSLog(@"ssss:%d",[self microSecondWithString:[[formatter stringFromDate:[NSDate date]] integerValue]]);
//    NSInteger startSecond = 0;
//    NSInteger endSecond;
//    NSInteger count = 1000000;
//    NSInteger numCount = count;
//    while (count--) {
//        if (count == numCount-1) {
//            startSecond = [[formatter stringFromDate:[NSDate date]] integerValue];
//        }
//        self.store = [[EKEventStore alloc]init];
//        [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//            
//        }];
//    }
//    endSecond = [[formatter stringFromDate:[NSDate date]] integerValue];
//    NSLog(@"eeee:%d",[self microSecondWithString:[[formatter stringFromDate:[NSDate date]] integerValue]]);
//    endSecond = [self microSecondWithString:endSecond];
//    startSecond = [self microSecondWithString:startSecond];
//    NSLog(@"%d",(endSecond-startSecond) );
//    NSLog(@"%d",(endSecond - startSecond)/numCount);
//
    
}

-(void)addNewEvent
{
    EventViewController *eventView = [[EventViewController alloc]initWithNibName:@"EventViewController" bundle:nil];
    eventView.status = 1;
    [self presentViewController:eventView animated:YES completion:nil];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.optionList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = [self.optionList objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *eventsArray;
    switch (indexPath.row) {
        case 0:
            eventsArray = [[EventManger shareInstance] getTodayEvent];
            break;
        case 1:
            eventsArray = [[EventManger shareInstance] getThisWeekEventFromSunday];
            break;
        case 2:
            eventsArray = [[EventManger shareInstance] getThisWeekEventFromMonday];
            break;
        case 3:
            eventsArray = [[EventManger shareInstance] getThisMonthFromFirstDay];
            break;
        default:
            eventsArray = [[EventManger shareInstance] getThisMonthFromFifteenDaysAgo];
            break;
    }
    
    DetailViewController *detailView = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    detailView.eventArray = eventsArray;
    [self presentViewController:detailView animated:YES completion:nil];    
}

//-(NSInteger)microSecondWithString:(NSInteger)timeInt
//{
//    NSInteger mInt = timeInt/1e5;
//    NSInteger sInt = (timeInt%100000)/1000;
//    NSInteger microSInt = timeInt%1000;
//    sInt += mInt * 60;
//    return sInt*1000+microSInt;
//}


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
