//
//  ViewController.m
//  ZYRunLoopDemo02
//
//  Created by 张宇 on 2017/5/27.
//  Copyright © 2017年 张宇. All rights reserved.
//

#import "ViewController.h"
#import "CCRunLoopInputSource.h"
#import "AppDelegate.h"
@interface ViewController ()<NSPortDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self testDemo3];
}
- (IBAction)source0Task:(id)sender {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    CCRunLoopContext *runLoopContext = [app.sources objectAtIndex:0];
    CCRunLoopInputSource *inputSource = runLoopContext.runLoopInputSource;
    [inputSource fireAllCommandsOnRunLoop:runLoopContext.runLoop];
    
}
- (IBAction)portTask:(id)sender {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    [self performSelector:@selector(port) onThread:app.customInputSourceThread withObject:nil waitUntilDone:NO];
}


- (IBAction)timerTask:(id)sender {

}

- (void)port
{
    NSMachPort *mainPort = [[NSMachPort alloc]init];
    NSPort *threadPort = [NSMachPort port];
    threadPort.delegate = self;
    
    //给主线程runloop加一个端口
    [[NSRunLoop mainRunLoop]addPort:mainPort forMode:NSDefaultRunLoopMode];
    
    //给当前线程也就是customInputSourceThread添加一个端口
    [[NSRunLoop currentRunLoop]addPort:threadPort forMode:NSDefaultRunLoopMode];
    
    NSString *s1 = @"通过port在线程间传递任务。";
    NSData *data = [s1 dataUsingEncoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *array = [NSMutableArray arrayWithArray:@[mainPort,data]];
        [threadPort sendBeforeDate:[NSDate date] msgid:1000 components:array from:mainPort reserved:0];
    });
}

- (void)handlePortMessage:(id)message
{
    NSLog(@"收到消息了，线程为：%@",[NSThread currentThread]);
    NSArray *array = [message valueForKeyPath:@"components"];
    NSData *data =  array[1];
    NSString *s1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"消息为:%@",s1);
}



@end
