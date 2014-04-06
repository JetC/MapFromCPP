//
//  SFPoints.m
//  MapFromCPP
//
//  Created by 孙培峰 on 4/5/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "SFPoints.h"

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
//- (void)drawRect:(CGRect)rect
//{
//
//}


- (void)drawWithStringsArray:(NSMutableArray *)stringsArray andSurfaceArray:(NSMutableArray *)surfaceArray andLineArray:(NSMutableArray *)lineArray
{
    for (id i in stringsArray)
    {
        static NSString *objectKind;
        static BOOL isLoadingPieceOfPathFinished = NO;
        
        NSUInteger locationOfComma = [i rangeOfString:@","].location;
        NSUInteger lengthOfComma = [i rangeOfString:@","].length;
        
        //        i stringByReplacingCharactersInRange:[NSMakeRange(locationOfComma, lengthOfComma)] withString:
        
        
        if ([i rangeOfString:@"surface"].length > 0)//当遇到表示surface开始的内容时，若在读文件第一行时则忽略，其余时候则将上一组点去组成path，保存至数组
        {
            if (surfaceArray.count >0)//将上一组Surface点去组成path，保存至数组
            {
                UIColor *color = [UIColor redColor];
                [color setFill];
                UIBezierPath *path = [UIBezierPath bezierPath];
                path.lineWidth = 5.0;
                path.lineCapStyle = kCGLineCapRound;
                path.lineJoinStyle = kCGLineCapRound;
                NSValue *val = [surfaceArray objectAtIndex:0];
                CGPoint p = [val CGPointValue];
                p.x = p.x/1000;
                p.y = p.y/1000;
                
                [path moveToPoint:p];
                
                for (NSUInteger i = 1; i<surfaceArray.count ; i++)
                {
                    if (i == surfaceArray.count-1)
                    {
                        NSValue *val1 = [surfaceArray objectAtIndex:i];
                        CGPoint p1 = [val1 CGPointValue];
                        p1.x = p1.x/1000;
                        p1.y = p1.y/1000;
                        [path addLineToPoint:p1];
                        NSLog(@"x:%f  y:%f",p1.x,p1.y);
                        [path closePath];
                        [path stroke];
                    }
                    else if (i == 1)
                    {
                        NSValue *val1 = [surfaceArray objectAtIndex:i];
                        CGPoint p1 = [val1 CGPointValue];
                        p1.x = p1.x/1000;
                        p1.y = p1.y/1000;
                        
                        [path addcurve];
                    }
                    else
                    {
                        NSValue *val1 = [surfaceArray objectAtIndex:i];
                        CGPoint p1 = [val1 CGPointValue];
                        p1.x = p1.x/1000;
                        p1.y = p1.y/1000;
                        [path addLineToPoint:p1];
                    }
                }
            }
            else if(lineArray.count >0)//将上一组line点去组成path，保存至数组
            {
                UIColor *color = [UIColor redColor];
                [color set];
                UIBezierPath *path = [UIBezierPath bezierPath];
                path.lineWidth = 5.0;
                path.lineCapStyle = kCGLineCapRound;
                path.lineJoinStyle = kCGLineCapRound;
                NSValue *val = [surfaceArray objectAtIndex:0];
                CGPoint p = [val CGPointValue];
                p.x = p.x/1000;
                p.y = p.y/1000;
                [path moveToPoint:p];
                for (NSUInteger i = 1; i<surfaceArray.count ; i++)
                {
                    if (i == surfaceArray.count-1)
                    {
                        NSValue *val1 = [surfaceArray objectAtIndex:i];
                        CGPoint p1 = [val1 CGPointValue];
                        p1.x = p1.x/1000;
                        p1.y = p1.y/1000;
                        [path addLineToPoint:p1];
                        [path closePath];
//                        [path point]
                        [path stroke];
                    }
                    else
                    {
                        NSValue *val1 = [surfaceArray objectAtIndex:i];
                        CGPoint p1 = [val1 CGPointValue];
                        p1.x = p1.x/1000;
                        p1.y = p1.y/1000;
                        [path addLineToPoint:p1];
                    }
                }
                
            }
            else//在读文件第一行时则忽略
            {
                
            }
            objectKind = @"surface";
            
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


@end
