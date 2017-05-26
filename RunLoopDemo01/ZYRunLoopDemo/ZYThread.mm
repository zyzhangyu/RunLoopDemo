//
//  ZYThread.m
//  ZYRunLoopDemo
//
//  Created by 张宇 on 2017/5/26.
//  Copyright © 2017年 张宇. All rights reserved.
//

#import "ZYThread.h"

@implementation ZYThread

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
        NSLog(@"进入线程");
        
        //控制RunLoop是否继续的开关 BOOL类型变量
        self.continued = YES;
        
        //注释1:
        NSRunLoop *currentThreadRunLoop = [NSRunLoop currentRunLoop];
        CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &currentRunLoopObserver, &context);
        
        //注释2:
        if (observer) {
            
            CFRunLoopRef runLoopRef = currentThreadRunLoop.getCFRunLoop;
            
            CFRunLoopAddObserver(runLoopRef, observer, kCFRunLoopDefaultMode);
        }
        
        //注释3:
        do {
            [currentThreadRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (self.continued);

        NSLog(@"离开线程");
    }
}


@end
