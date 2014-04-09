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
@property (strong, nonatomic)NSMutableArray *stringsArray;
@property (strong, nonatomic)NSMutableArray *surfaceArray;
@property (strong, nonatomic)NSMutableArray *lineArray;


@end
@implementation SFPoints

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    for (id i in _stringsArray)
    {
        static NSString *objectKind;
        
        if ([i rangeOfString:@"surface"].length > 0)//当遇到表示surface开始的内容时，若在读文件第一行时则忽略，其余时候则将上一组点去组成path，保存至数组
        {
            if (_surfaceArray.count >0)//将上一组Surface点去组成path，保存至数组
            {
                
                UIColor *color = [UIColor redColor];
                [color setFill];
                
                UIBezierPath *path = [self setupedBezierPath];
                
                
                [path moveToPoint:[self setupPointFromArray:_surfaceArray atIndex:0]];
                
                for (NSUInteger i = 1; i<_surfaceArray.count ; i++)
                {
                    //利用上面已经创建的path,添加点，并完成path，添加到view
                    [self addPointsForPath:path fromArray:_surfaceArray atIndex:i];
                }
                [_surfaceArray removeAllObjects];
            }
            else if(_lineArray.count >0)//将上一组line点去组成path，保存至数组
            {
                UIColor *color = [UIColor redColor];
                [color set];
                
                UIBezierPath *path = [self setupedBezierPath];
                
                
                [path moveToPoint:[self setupPointFromArray:_surfaceArray atIndex:0]];
                for (NSUInteger i = 1; i<_surfaceArray.count ; i++)
                {
                    [self addPointsForPath:path fromArray:_lineArray atIndex:i];
                }
                [_lineArray removeAllObjects];
                
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
            if ([objectKind isEqual:@"surface"] && ![i isEqualToString:@"-99999,-99999"])
            {
                [_surfaceArray addObject:[NSValue valueWithCGPoint:CGPointFromString([NSString stringWithFormat:@"{%@}",i])]];
            }
            else if ([objectKind isEqual:@"line"] && ![i isEqualToString:@"-99999,-99999"])
            {
                [_lineArray addObject:[NSValue valueWithCGPoint:CGPointFromString([NSString stringWithFormat:@"{%@}",i])]];
            }
            else if ([i isEqualToString:@"-99999,-99999"])
            {
                NSLog(@"Scanned to an end of path");
            }
            else
            {
                NSLog(@"Not containing ','  error!");
            }
            
        }
        else
        {
            NSLog(@"Can't recognize, will now skip this line %@",i);
        }
        
    }

}


- (void)drawWithStringsArray:(NSMutableArray *)stringsArray andSurfaceArray:(NSMutableArray *)surfaceArray andLineArray:(NSMutableArray *)lineArray
{
    self.stringsArray = stringsArray;
    self.surfaceArray = surfaceArray;
    self.lineArray = lineArray;
    [self drawRect:CGRectMake(1, 1, 1, 1)];
}

- (UIBezierPath *)setupedBezierPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 0.5;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    return path;
}

- (CGPoint)setupPointFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index
{
    NSValue *val = [array objectAtIndex:index];
    CGPoint p = [val CGPointValue];
    p.x = p.x + 2432833;
    p.y = p.y + 2372515;
    p.x = p.x/4000;
    p.y = p.y/4000;
    p.x = 1134-p.x;
//    NSLog(@"x:%f  y:%f",p.x,p.y);
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
