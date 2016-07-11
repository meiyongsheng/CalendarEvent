//
//  EventViewController.h
//  CalendarEventSdk
//
//  Created by Clement on 15/1/15.
//  Copyright (c) 2015年 Clement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "BaseSelectViewController.h"


@interface EventViewController : UIViewController <baseSelectDelegate>

@property int status; //  1表示新增事件；2表示事件查看事件详情，可修改
@property (strong,nonatomic) EKEvent *event;


@end
