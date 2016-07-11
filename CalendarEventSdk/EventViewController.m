//
//  EventViewController.m
//  CalendarEventSdk
//
//  Created by Clement on 15/1/15.
//  Copyright (c) 2015年 Clement. All rights reserved.
//

#import "EventViewController.h"
#import "EventManger.h"
#import "BaseSelectViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

typedef enum : NSUInteger {
    PickerStatusNone = 0,
    PickerStatusStart,
    PickerStatusEnd,
} PickerStatus;


@interface EventViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) UITextField *titleTF;
@property (retain,nonatomic) UIDatePicker *datePicker;
@property (retain,nonatomic) UISwitch *allDaySwitch;
@property (retain,nonatomic) UILabel *startLabel;
@property (retain,nonatomic) UILabel *endLabel;
@property (retain,nonatomic) UILabel *repeateLabel;
@property (retain,nonatomic) UILabel *travelLabel;
@property (retain,nonatomic) UILabel *remindersLabel;
@property (retain,nonatomic) UITextField *URLTextField;
@property (retain,nonatomic) UITextField *PSTextField;
@property (assign) PickerStatus pickerStatus;

@property (retain,nonatomic) NSDate *selectedDate;

@property (retain,nonatomic) UIButton *deleteButton;

@property CGFloat keyboardHeightOffset;

- (IBAction)goBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *EventTitle;
- (IBAction)finishToDo:(id)sender;

@property (retain,nonatomic) NSDateFormatter  *formatter;
@property (retain,nonatomic) UITapGestureRecognizer *tapGes;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.formatter = [[NSDateFormatter alloc]init];
    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.tableView addGestureRecognizer:self.tapGes];
    [self keyboardMoveUp:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [self.tableView removeGestureRecognizer:self.tapGes];
    [self keyboardMoveDown];
}

-(void)keyboardMoveUp:(UITextField *)textField
{
    UIView *view = [[textField superview]superview];
    CGRect rect = view.frame;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if ( screenBounds.size.height - ( rect.origin.y + rect.size.height ) < 216 + 44 ) {
        self.keyboardHeightOffset = screenBounds.size.height - ( rect.origin.y + rect.size.height ) - 216 - 105;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect viewRect = self.view.frame;
            viewRect.origin.y += self.keyboardHeightOffset;
            self.view.frame = viewRect;
        }];
    }
}

-(void)keyboardMoveDown
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect viewRect = self.view.frame;
        viewRect.origin.y -= self.keyboardHeightOffset;
        self.view.frame = viewRect;
    }];
}

-(void)dismissKeyboard
{
    [self.titleTF resignFirstResponder];
    [self.URLTextField resignFirstResponder];
    [self.PSTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRow;
    if (section == 0) {
        numberOfRow = 1;
    }
    else if(section == 1)
    {
        numberOfRow = 5;
        if ( (self.pickerStatus == PickerStatusEnd) || (self.pickerStatus == PickerStatusStart) ) {
            numberOfRow++;
        }
    }
    else if(section == 2)
    {
        numberOfRow = 1;
    }
    else if(section == 3)
    {
        numberOfRow = 2;
    }
    else
    {
        numberOfRow = 1;
    }
    return numberOfRow;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 30;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    if ( (self.pickerStatus == PickerStatusStart) && (indexPath.section == 1 && indexPath.row == 2) ) {
        height = 216;
    }
    else if( (self.pickerStatus == PickerStatusEnd) && (indexPath.section == 1 && indexPath.row == 3) )
    {
        height = 216;
    }
    else if( (indexPath.section == 3) && (indexPath.row == 1) )
    {
        height = 80;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    switch (section) {
        case 0:
        {
            if (row == 0) {
                cell.textLabel.text = @"标题";
                self.titleTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 0, 375- 60-20, 44)];
                [cell.contentView addSubview:self.titleTF];
                self.titleTF.textAlignment = NSTextAlignmentRight;
                self.titleTF.text = self.event.title;
                self.titleTF.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
//            else
//            {
//                cell.textLabel.text = @"位置";
//                self.titleTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 375- 60, 44)];
//                [cell.contentView addSubview:self.titleTF];
//            }
        }
            break;
        case 1:
        {
            NSArray *arr;
            if (self.pickerStatus == PickerStatusNone) {
                arr = @[@"全天",@"开始",@"结束",@"重复",@"行程时间"];
            }
            else if(self.pickerStatus == PickerStatusStart)
            {
                arr = @[@"全天",@"开始",@"picker",@"结束",@"重复",@"行程时间"];
            }
            else
            {
                arr = @[@"全天",@"开始",@"结束",@"picker",@"重复",@"行程时间"];
            }
            
           cell = [self createCellsWithTableView:tableView indexPath:indexPath titleOfRows:arr];
            
        }
            break;
        case 2:
        {
            if (row == 0) {
                cell.textLabel.text = @"提醒";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                self.remindersLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, kScreenWidth-60-30, 40)];
                self.remindersLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:self.remindersLabel];
                if (self.event.alarms == nil) {
                    self.remindersLabel.text = @"不提醒";
                    
                }
                else
                {
                    EKAlarm *alerm = [self.event.alarms objectAtIndex:0];
//                    NSDate *aDate = alerm.absoluteDate;
//                    NSDate *sDate = self.event.startDate;
//                   NSTimeInterval timeInt = [sDate timeIntervalSinceDate:aDate];
                    self.remindersLabel.text = [NSString stringWithFormat:@"%.0fs",alerm.relativeOffset];
                }
                
            }
        }
            break;
        case 3:
        {
            if (row == 0) {
                cell.textLabel.text = @"URL";
                self.URLTextField = [[UITextField alloc]initWithFrame:CGRectMake(60, 0, kScreenWidth-60-20, 44)];
                self.URLTextField.textAlignment = NSTextAlignmentRight;
                self.URLTextField.text = self.event.URL.resourceSpecifier;
                [cell.contentView addSubview:self.URLTextField];
                self.URLTextField.delegate = self;
            }
            else
            {
                self.PSTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
                self.PSTextField.placeholder = @"备注";
                [cell.contentView addSubview:self.PSTextField];
                self.PSTextField.text = self.event.notes;
                self.PSTextField.delegate = self;
            }
        }
        default:
        {
            if (section == 4 && row == 0 && self.status == 2) {
                //删除事件
                self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
                [self.deleteButton setTitle:@"删除事件" forState:UIControlStateNormal];
                [self.deleteButton addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
                self.deleteButton.titleLabel.textAlignment = NSTextAlignmentRight;
                self.deleteButton.backgroundColor = [UIColor orangeColor];
                [cell.contentView addSubview:self.deleteButton];
            }
            
        }
            break;
    }
    
    return cell;
}

-(UITableViewCell *)createCellsWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath titleOfRows:(NSArray *)titleArray
{
//    @[@"全天",@"开始",@"picker",@"结束",@"重复",@"行程时间"];
    NSLog(@"%@",titleArray);
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    NSString *title = [titleArray objectAtIndex:indexPath.row];
    if ([title isEqualToString:@"全天"]) {
        cell.textLabel.text = @"全天";
        self.allDaySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-60-10, 0, 40, 44)];
        [cell.contentView addSubview:self.allDaySwitch];
        if (self.event.allDay) {
            self.allDaySwitch.on = YES;
        }
    }
    else if([title isEqualToString:@"开始"])
    {
        cell.textLabel.text = @"开始";
        self.startLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, kScreenWidth - 60 - 20, 44)];
        self.startLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:self.startLabel];
        self.startLabel.text = [self.formatter stringFromDate:self.event.startDate];
        
    }
    else if([title isEqualToString:@"结束"])
    {
        cell.textLabel.text = @"结束";
        self.endLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, kScreenWidth-60 - 20, 44)];
        self.endLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:self.endLabel];
        self.endLabel.text = [self.formatter stringFromDate:self.event.endDate];
        
    }
    else if([title isEqualToString:@"重复"])
    {
        cell.textLabel.text = @"重复";
        self.repeateLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, kScreenWidth-60-30, 44)];
        self.repeateLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:self.repeateLabel];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSString *str;
        if ([self.event.recurrenceRules count] > 0) {
            EKRecurrenceRule *rule = [self.event.recurrenceRules objectAtIndex:0];
            switch (rule.frequency) {
                case EKRecurrenceFrequencyDaily:
                    str = @"每天";
                    break;
                case EKRecurrenceFrequencyWeekly:
                    str = @"每周";
                    break;
                case EKRecurrenceFrequencyMonthly:
                    str = @"每月";
                    break;
                case EKRecurrenceFrequencyYearly:
                    str = @"每年";
                default:
                    str = @"永不";
                    break;
            }
        }
        self.repeateLabel.text = str;
    }
    else if([title isEqualToString:@"行程时间"])
    {
        //
        cell.textLabel.text = @"行程时间";
        self.travelLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, kScreenWidth-100-30, 44)];
        self.travelLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:self.travelLabel];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,216)];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [cell.contentView addSubview:self.datePicker];
        [self.datePicker addTarget:self action:@selector(didSelectDate:) forControlEvents:UIControlEventValueChanged];
        
    }
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        
        case 1:
        {
            if (row == 1) {
                if (self.pickerStatus == PickerStatusNone) {
                    self.pickerStatus = PickerStatusStart;
                    NSIndexPath *indexPathForInsert = [NSIndexPath indexPathForRow:(row + 1) inSection:section];
                    NSArray *arr = [NSArray arrayWithObject:indexPathForInsert];
                    [tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                else if(self.pickerStatus == PickerStatusStart)
                {
                    self.pickerStatus = PickerStatusNone;
                    NSIndexPath *indexPathForInsert = [NSIndexPath indexPathForRow:(row + 1) inSection:section];
                    NSArray *arr = [NSArray arrayWithObject:indexPathForInsert];
                    [tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                else
                {
                    self.pickerStatus = PickerStatusStart;
                    NSIndexPath *indexPathFrom = [NSIndexPath indexPathForRow:(row + 2) inSection:section];
                    NSIndexPath *indexPathTo = [NSIndexPath indexPathForRow:(row+1) inSection:section];
                    [tableView moveRowAtIndexPath:indexPathFrom toIndexPath:indexPathTo];
                }
            }
            else if ( (row == 2) && (self.pickerStatus == PickerStatusNone) ) {
                self.pickerStatus = PickerStatusEnd;
                NSIndexPath *indexPathForInsert = [NSIndexPath indexPathForRow:(row + 1) inSection:section];
                [tableView insertRowsAtIndexPaths:@[indexPathForInsert] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else if ( (row == 2) && (self.pickerStatus == PickerStatusEnd) ) {
                self.pickerStatus = PickerStatusNone;
                NSIndexPath *indexPathForDelete = [NSIndexPath indexPathForRow:(row + 1) inSection:section];
                [tableView deleteRowsAtIndexPaths:@[indexPathForDelete] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else if ( (row == 3) && (self.pickerStatus == PickerStatusStart) ) {
                self.pickerStatus = PickerStatusEnd;
                NSIndexPath *indexPathFrom = [NSIndexPath indexPathForRow:(row - 1) inSection:section];
                NSIndexPath *indexPathTo = [NSIndexPath indexPathForRow:row inSection:section];
                [tableView moveRowAtIndexPath:indexPathFrom toIndexPath:indexPathTo];
            }
            else if ( row == 3 )
            {
                NSArray *arr = @[@"永不",@"每天",@"每周",@"每月",@"每年"];
                NSString *title = @"重复频率";
                BaseSelectViewController *baseView = [[BaseSelectViewController alloc]initWithNibName:@"BaseSelectViewController" bundle:nil];
                baseView.sourceArray = arr;
                baseView.baseTitle = title;
                if( ![self.repeateLabel.text isEqualToString:@""] && (self.remindersLabel.text != nil) )
                {
                    NSInteger defaultIndex = [arr indexOfObject:self.repeateLabel.text];
                    baseView.defaultIndex = defaultIndex;
                }
                else
                {
                    baseView.defaultIndex = 0;
                }
                baseView.delegate = self;
                [self presentViewController:baseView animated:NO completion:^{
                    [tableView deselectRowAtIndexPath:indexPath animated:NO];
                }];
                
            }
            
        }
            break;
        case 2:
        {
            if ( row == 0 ) {
                NSArray *arr = @[@"不提醒",@"事件发生时",@"5分钟前",@"30分钟前",@"2小时前",@"1天前",@"1周前"];
                NSString *title = @"提醒";
                BaseSelectViewController *baseView = [[BaseSelectViewController alloc]initWithNibName:@"BaseSelectViewController" bundle:nil];
                baseView.sourceArray = arr;
                baseView.baseTitle = title;
                if (![self.remindersLabel.text isEqualToString:@""] && (self.remindersLabel.text != nil)) {
                    NSInteger defaultIndex = [arr indexOfObject:self.remindersLabel.text];
                    baseView.defaultIndex = defaultIndex;
                }
                else
                {
                    baseView.defaultIndex = 0;
                }
                
                baseView.delegate = self;
                [self presentViewController:baseView animated:NO completion:^{
                    [tableView deselectRowAtIndexPath:indexPath animated:NO];
                }];
            }
        }
            break;
        default:
            break;
    }
}

-(void)didSelectDate:(id)sender
{
    self.selectedDate = self.datePicker.date;
    if (self.pickerStatus == PickerStatusStart) {
        self.startLabel.text = [_formatter stringFromDate:_selectedDate];
    }
    if (self.pickerStatus == PickerStatusEnd) {
        self.endLabel.text = [_formatter stringFromDate:_selectedDate];
    }
}

-(void)deleteEvent:(id)sender
{
    [[EventManger shareInstance] deleteEvent:self.event];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)finishToDo:(id)sender {
    if (self.status == 1) {
        ////PS.创建事件必须用[EKEvent eventWithEventStore:store]去初始化一个新的事件
    EKEvent *newEvent = [EKEvent eventWithEventStore:[[EventManger shareInstance] store]];
    EKRecurrenceRule *rule;
    if ([self.repeateLabel.text isEqualToString:@"永不"]) {
        rule = nil;
    }
    else if ([self.repeateLabel.text isEqualToString:@"每天"])
    {
        rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:nil];
    }
    else if ([self.repeateLabel.text isEqualToString:@"每周"])
    {
        rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:nil];
    }
    else if ([self.repeateLabel.text isEqualToString:@"每月"])
    {
        rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:1 end:nil];
    }
    else if ([self.repeateLabel.text isEqualToString:@"每年"])
    {
        rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 end:nil];
    }
    else
    {
        rule = nil;
    }
    
    EKAlarm *alarm;
    if ([self.remindersLabel.text isEqualToString:@"事件发生时"]) {
        alarm = [EKAlarm alarmWithRelativeOffset:0];
    }
    else if ([self.remindersLabel.text isEqualToString:@"5分钟前"])
    {
        alarm = [EKAlarm alarmWithRelativeOffset:-5*60];
    }
    else if ([self.remindersLabel.text isEqualToString:@"30分钟前"])
    {
        alarm = [EKAlarm alarmWithRelativeOffset:-30*60];
    }
    else if ([self.remindersLabel.text isEqualToString:@"2小时前"])
    {
        alarm = [EKAlarm alarmWithRelativeOffset:-2*60*60];
    }
    else if ([self.remindersLabel.text isEqualToString:@"1天前"])
    {
        alarm = [EKAlarm alarmWithRelativeOffset:-24*60*60];
    }
    else if ([self.remindersLabel.text isEqualToString:@"1周前"])
    {
        alarm = [EKAlarm alarmWithRelativeOffset:-7*24*60*60];
    }
    
    [newEvent setTitle:self.titleTF.text];
    [newEvent setAllDay:self.allDaySwitch.on];
    [newEvent setStartDate:[self.formatter dateFromString:self.startLabel.text]];
    [newEvent setEndDate:[self.formatter dateFromString:self.endLabel.text]];
    if (rule != nil) {
       [newEvent setRecurrenceRules:@[rule]];
    }
    if (alarm != nil) {
        [newEvent setAlarms:@[alarm]];
    }
    
    [newEvent setURL:[NSURL URLWithString:self.URLTextField.text]];
    [newEvent setNotes:self.PSTextField.text];
    
    [[EventManger shareInstance] createEvent:newEvent];
    
    }
    else
    {
        EKRecurrenceRule *rule;
        if ([self.repeateLabel.text isEqualToString:@"永不"]) {
            rule = nil;
        }
        else if ([self.repeateLabel.text isEqualToString:@"每天"])
        {
            rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:nil];
        }
        else if ([self.repeateLabel.text isEqualToString:@"每周"])
        {
            rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyWeekly interval:1 end:nil];
        }
        else if ([self.repeateLabel.text isEqualToString:@"每月"])
        {
            rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyMonthly interval:1 end:nil];
        }
        else if ([self.repeateLabel.text isEqualToString:@"每年"])
        {
            rule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyYearly interval:1 end:nil];
        }
        else
        {
            rule = nil;
        }
        
        EKAlarm *alarm;
        if ([self.remindersLabel.text isEqualToString:@"事件发生时"]) {
            alarm = [EKAlarm alarmWithRelativeOffset:0];
        }
        else if ([self.remindersLabel.text isEqualToString:@"5分钟前"])
        {
            alarm = [EKAlarm alarmWithRelativeOffset:-5*60];
        }
        else if ([self.remindersLabel.text isEqualToString:@"30分钟前"])
        {
            alarm = [EKAlarm alarmWithRelativeOffset:-30*60];
        }
        else if ([self.remindersLabel.text isEqualToString:@"2小时前"])
        {
            alarm = [EKAlarm alarmWithRelativeOffset:-2*60*60];
        }
        else if ([self.remindersLabel.text isEqualToString:@"1天前"])
        {
            alarm = [EKAlarm alarmWithRelativeOffset:-24*60*60];
        }
        else if ([self.remindersLabel.text isEqualToString:@"1周前"])
        {
            alarm = [EKAlarm alarmWithRelativeOffset:-7*24*60*60];
        }
        
        [self.event setTitle:self.titleTF.text];
        [self.event setAllDay:self.allDaySwitch.on];
        [self.event setStartDate:[self.formatter dateFromString:self.startLabel.text]];
        [self.event setEndDate:[self.formatter dateFromString:self.endLabel.text]];
        if (rule != nil) {
            [self.event setRecurrenceRules:@[rule]];
        }
        if (alarm != nil) {
            [self.event setAlarms:@[alarm]];
        }
        
        [self.event setURL:[NSURL URLWithString:self.URLTextField.text]];
        [self.event setNotes:self.PSTextField.text];
        
        [[EventManger shareInstance] saveEvent:self.event];

    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSelectedObject:(id)obj title:(NSString *)ti
{
    if ([ti isEqualToString:@"重复频率"]) {
        self.repeateLabel.text = (NSString *)obj;
    }
    else if([ti isEqualToString:@"提醒"])
    {
        self.remindersLabel.text = (NSString *)obj;
    }
}

@end
