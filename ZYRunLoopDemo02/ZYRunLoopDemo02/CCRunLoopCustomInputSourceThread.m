//
//  CCRunLoopCustomInputSourceThread.m
//  RunLoopDemo
//
//  Created by Chun Ye on 10/20/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "CCRunLoopCustomInputSourceThread.h"
#import "CCRunLoopInputSource.h"

@interface CCRunLoopCustomInputSourceThread () <CCRunLoopInputSourceTestDelegate>

@property (nonatomic, strong) CCRunLoopInputSource *customInputSource;

@end

@implementation CCRunLoopCustomInputSourceThread

#pragma mark - Observer CallBack

void currentRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    NSLog(@"Current thread Run Loop activity: %@", printActivity(activity));
}

static inline NSString* printActivity(CFRunLoopActivity activity)
{
    NSString *activityDescription;
    switch (activity) {
        case kCFRunLoopEntry:
            activityDescription = @"kCFRunLoopEntry";
            break;
        case kCFRunLoopBeforeTimers:
            activityDescription = @"kCFRunLoopBeforeTimers";
            break;
        case kCFRunLoopBeforeSources:
            activityDescription = @"kCFRunLoopBeforeSources";
            break;
        case kCFRunLoopBeforeWaiting:
            activityDescription = @"kCFRunLoopBeforeWaiting";
            break;
        case kCFRunLoopAfterWaiting:
            activityDescription = @"kCFRunLoopAfterWaiting";
            break;
        case kCFRunLoopExit:
            activityDescription = @"kCFRunLoopExit";
            break;
        default:
            break;
    }
    return activityDescription;
}


- (void)main
{
    @autoreleasepool {
        NSLog(@"进入 CustomInputSourceThread");
        
        NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
        
        self.customInputSource = [[CCRunLoopInputSource alloc] init];
        self.customInputSource.delegate = self;
        [self.customInputSource addToCurrentRunLoop];
        
        CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
        
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &currentRunLoopObserver, &context);
        
        if (observer) {
            
            CFRunLoopRef runLoopRef = currentRunLoop.getCFRunLoop;
            
            CFRunLoopAddObserver(runLoopRef, observer, kCFRunLoopDefaultMode);
        }
        
        
        while (!self.cancelled) {
            NSLog(@"Enter Run Loop");
            
            [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];

            NSLog(@"Exit Run Loop");
        }
        
        NSLog(@"离开 CustomInputSourceThread ");
    }
}

- (void)finishOtherTask
{
    NSLog(@"开始任务");
    NSLog(@"执行任务");
    NSLog(@"结束任务");

}

#pragma mark - CCRunLoopInputSourceTestDelegate

- (void)activeInputSourceForTestPrintStringEvent:(NSString *)string
{
    NSLog(@"正在处理事件 现在的线程是：%@",[NSThread currentThread]) ;

//    NSLog(@"activeInputSourceForTestPrintStringEvent : %@", string);
}

@end
