//
//  ViewController.m
//  ZYRunLoopDemo
//
//  Created by 张宇 on 2017/5/26.
//  Copyright © 2017年 张宇. All rights reserved.
//

#import "ViewController.h"
#import "ZYThread.h"
@interface ViewController ()

@property (nonatomic, strong) ZYThread *zyThread;

@end

@implementation ViewController

- (IBAction)test1:(id)sender {
    
    [self performSelector:@selector(source1Working) onThread:_zyThread withObject:nil waitUntilDone:NO];
    
}

- (void)source1Working{
    NSLog(@"（source1）执行任务---射击");
}

- (IBAction)test2:(id)sender {
    
    [self performSelector:@selector(source2Working) onThread:_zyThread withObject:nil waitUntilDone:NO];
}

- (void)source2Working{
    NSLog(@"（source1）执行任务---跑步");
}

- (IBAction)test3:(id)sender {
    
    [self performSelector:@selector(source3Working) onThread:_zyThread withObject:nil waitUntilDone:NO];

}
  
- (void)source3Working{
    _zyThread.continued = NO;
}


- (IBAction)drawLine:(id)sender {
    
    NSLog(@"----------------华丽的分隔线");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _zyThread = [[ZYThread alloc] init];
    [_zyThread setName:@"线程章鱼号"];
    [_zyThread start];
}

@end
