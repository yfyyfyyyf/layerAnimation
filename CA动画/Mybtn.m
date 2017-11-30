//
//  Mybtn.m
//  LayerText
//
//  Created by 杨果果 on 2017/6/5.
//  Copyright © 2017年 yangyangyang. All rights reserved.
//

#import "Mybtn.h"

@implementation Mybtn

-(instancetype)init{
    if (self = [super init]) {
        [self creat];
    }
    return self;
}
- (void)creat{
    UILabel *lab = [[UILabel alloc]init];
//    lab.center = self.center;
    lab.frame = CGRectMake(10, 5, 80, 40);
    lab.text = @"21323";
    lab.textColor = [UIColor redColor];
    lab.backgroundColor = [UIColor whiteColor];
    [self addSubview:lab];
    
}
@end
