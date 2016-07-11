//
//  BaseSelectViewController.h
//  CalendarEventSdk
//
//  Created by Clement on 15/1/16.
//  Copyright (c) 2015年 Clement. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol baseSelectDelegate <NSObject>

-(void)didSelectedObject:(id)obj title:(NSString *)ti;

@end

@interface BaseSelectViewController : UIViewController

@property (strong,nonatomic) NSArray *sourceArray;

@property (copy,nonatomic) NSString *baseTitle;

@property NSInteger defaultIndex;

@property id <baseSelectDelegate>delegate;

@end
