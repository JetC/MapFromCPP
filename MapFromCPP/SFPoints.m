//
//  SFPoints.m
//  MapFromCPP
//
//  Created by 孙培峰 on 4/5/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "SFPoints.h"
#import "SFViewController.h"

@interface SFPoints()

@property (weak, nonatomic)SFViewController *vc;

@end
@implementation SFPoints

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}


- (void)drawWithStringsArray:(NSMutableArray *)stringsArray andSurfaceArray:(NSMutableArray *)surfaceArray andLineArray:(NSMutableArray *)lineArray
{
    for (id i in stringsArray)
    {
        static NSString *objectKind;
 
        if ([i rangeOfString:@"surface"].length > 0)//当遇到表示surface开始的内容时，若在读文件第一行时则忽略，其余时候则将上一组点去组成path，保存至数组
        {
            if (surfaceArray.count >0)//将上一组Surface点去组成path，保存至数组
            {
                
                UIColor *color = [UIColor redColor];
                [color setFill];
                
                UIBezierPath *path = [self setupedBezierPath];
                
                
                [path moveToPoint:[self setupPointFromArray:surfaceArray atIndex:0]];
                
                for (NSUInteger i = 1; i<surfaceArray.count ; i++)
                {
                    //利用上面已经创建的path,添加点，并完成path，添加到view
                    [self addPointsForPath:path fromArray:surfaceArray atIndex:i];
                }
                [surfaceArray removeAllObjects];
            }
            else if(lineArray.count >0)//将上一组line点去组成path，保存至数组
            {
                UIColor *color = [UIColor redColor];
                [color set];
                
                UIBezierPath *path = [self setupedBezierPath];

                
                [path moveToPoint:[self setupPointFromArray:surfaceArray atIndex:0]];
                for (NSUInteger i = 1; i<surfaceArray.count ; i++)
                {
                    [self addPointsForPath:path fromArray:lineArray atIndex:i];
                }
                [lineArray removeAllObjects];
                
            }
            else//在读文件第一行时则忽略
            {
                objectKind = @"surface";
            }
            
        }
        else if([i rangeOfString:@"line"].length > 0)//当遇到表示line开始的内容时
        {
            objectKind = @"line";
        }
        else if([i rangeOfString:@","].length > 0)
        {
            if ([objectKind isEqual:@"surface"])
            {
                [surfaceArray addObject:[NSValue valueWithCGPoint:CGPointFromString([NSString stringWithFormat:@"{%@}",i])]];
            }
            else if ([objectKind isEqual:@"line"])
            {
                [lineArray addObject:[NSValue valueWithCGPoint:CGPointFromString([NSString stringWithFormat:@"{%@}",i])]];
            }
            else
            {
                NSLog(@"error!");
            }
            
        }
        else
        {
            NSLog(@"error");
        }
        
    }
    
}

- (UIBezierPath *)setupedBezierPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 5.0;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    return path;
}

- (CGPoint)setupPointFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index
{
    NSValue *val = [array objectAtIndex:index];
    CGPoint p = [val CGPointValue];
    p.x = p.x/2000;
    p.y = p.y/2000;
    NSLog(@"x:%f  y:%f",p.x,p.y);
    return p;
}

- (UIBezierPath *)finalizePath:(UIBezierPath *)path
{
    [path closePath];
    [path stroke];
    return path;
}

- (void)addPointsForPath:(UIBezierPath *)path fromArray:(NSMutableArray *)array atIndex:(NSUInteger)index
{
    if (index == array.count-1)//当读取到最后一个元素时
    {
        [path addLineToPoint:[self setupPointFromArray:array atIndex:index]];
        [self finalizePath:path];
    }
    else
    {
        [path addLineToPoint:[self setupPointFromArray:array atIndex:index]];
    }
}

@end
