//
//  CCRunLoopInputSource.m
//  RunLoopDemo
//
//  Created by Chun Ye on 10/20/14.
//  Copyright (c) 2014 Chun Tips. All rights reserved.
//

#import "CCRunLoopInputSource.h"
#import "AppDelegate.h"

@interface CCRunLoopInputSource ()
{
    CFRunLoopSourceRef _runLoopSource;
    NSMutableArray *_commands;
 }

@end

/* Run Loop Source Context的三个回调方法 */

//当source添加进runloop的时候，调用此回调方法,将源注册到其他线程 <== CFRunLoopAddSource(runLoop, source, mode);
void runLoopSourceScheduleRoutine (void *info, CFRunLoopRef runLoopRef, CFStringRef mode)
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    CCRunLoopInputSource *runLoopInputSource = (__bridge CCRunLoopInputSource *)info;

    //2.主线程和当前线程的通信使用CCRunLoopContext对象来完成。
    CCRunLoopContext *runLoopContext = [[CCRunLoopContext alloc] initWithSource:runLoopInputSource runLoop:runLoopRef];
    
    //3.主线程管理该Input source，所以使用performSelectorOnMainThread通知主线程。
    [appDelegate performSelectorOnMainThread:@selector(registerSource:) withObject:runLoopContext waitUntilDone:NO];
}

// 当前Input source被告知需要处理事件的回调方法
void runLoopSourcePerformRoutine (void *info)
{
    CCRunLoopInputSource *runLoopInputSource = (__bridge CCRunLoopInputSource *)info;
    [runLoopInputSource inputSourceFired];
}

// 如果使用CFRunLoopSourceInvalidate函数把输入源从Run Loop里面移除的话,系统会回调该方法。
// 我们在该方法中移除了主线程对当前Input source context的引用。
void runLoopSourceCancelRoutine (void *info, CFRunLoopRef runLoopRef, CFStringRef mode)
{
    CCRunLoopInputSource *runLoopInputSource = (__bridge CCRunLoopInputSource *)info;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    CCRunLoopContext *runLoopContext = [[CCRunLoopContext alloc] initWithSource:runLoopInputSource runLoop:runLoopRef];
    [appDelegate performSelectorOnMainThread:@selector(removeSource:) withObject:runLoopContext waitUntilDone:YES];
}

@implementation CCRunLoopInputSource

#pragma mark - Public

- (instancetype)init
{
    self = [super init];
    if (self) {
        CFRunLoopSourceContext context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
            &runLoopSourceScheduleRoutine,
            &runLoopSourceCancelRoutine,
            &runLoopSourcePerformRoutine};
        
        _runLoopSource = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
        
        _commands = [NSMutableArray array];
    }
    return self;
}

- (void)addToCurrentRunLoop
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, _runLoopSource, kCFRunLoopDefaultMode);
}

- (void)invalidate
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopRemoveSource(runLoop, _runLoopSource, kCFRunLoopDefaultMode);
}

- (void)inputSourceFired
{
    NSLog(@"开始处理事件");
    
        if ([self.delegate respondsToSelector:@selector(activeInputSourceForTestPrintStringEvent:)]) {
            [self.delegate activeInputSourceForTestPrintStringEvent:@"a"];
        }
    
    NSLog(@"结束 处理事件");
}

// 其他线程注册事件

- (void)addCommand:(NSInteger)command data:(NSData *)data
{
    
}





// 其他线程注册事件
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runLoop
{
    NSLog(@"在主线程注册了一个事件，准备使用CFRunLoopSourceSignal标记为待处理，使用CFRunLoopWakeUp手动唤醒事件");
    
    //• Source0 只包含了一个回调（函数指针），它并不能主动触发事件。使用时，你需要先调用 CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒 RunLoop，让其处理这个事件。

    CFRunLoopSourceSignal(_runLoopSource);
    CFRunLoopWakeUp(runLoop);
}

@end



@implementation CCRunLoopContext

- (instancetype)initWithSource:(CCRunLoopInputSource *)runLoopInputSource runLoop:(CFRunLoopRef)runLoop
{
    self = [super init];
    if (self) {
        _runLoopInputSource = runLoopInputSource;
        _runLoop = runLoop;
    }
    return self;
}

@end
