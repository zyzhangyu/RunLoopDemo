//
//  AppDelegate.h
//  ZYRunLoopDemo02
//
//  Created by 张宇 on 2017/5/27.
//  Copyright © 2017年 张宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCRunLoopInputSource.h"
#import "CCRunLoopCustomInputSourceThread.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) NSMutableArray *sources;
@property (nonatomic, strong) CCRunLoopCustomInputSourceThread *customInputSourceThread;
@property (strong, nonatomic) UIWindow *window;

//RunLoopSourceScheduleRoutine
- (void)registerSource:(CCRunLoopContext *)sourceContext;
//RunLoopSourceCancelRoutine
- (void)removeSource:(CCRunLoopContext *)sourceContext;

@end

