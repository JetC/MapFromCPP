//
//  SFViewController.m
//  MapFromCPP
//
//  Created by 孙培峰 on 4/2/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "SFViewController.h"

@interface SFViewController ()

@property (nonatomic, strong)NSMutableArray *stringOfPointsArray;
@property (nonatomic, strong)NSMutableArray *surfacePoints;
@property (nonatomic, strong)NSMutableArray *linePoints;
@property (nonatomic, strong)NSMutableDictionary *dic;


@end

@implementation SFViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.surfacePoints = [[NSMutableArray alloc]init];
    
    
    NSError *error = [[NSError alloc]init];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"china1" ofType:@"txt"];
    NSArray *plainText = [[NSString stringWithContentsOfFile:filePath usedEncoding:nil error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] ;
    NSMutableArray *removedOtherObjects = [[NSMutableArray alloc]initWithArray:plainText];
    
    for (NSUInteger i = 0;i<removedOtherObjects.count ; i++)
    {
//        NSLog(@"%d",[[removedOtherObjects objectAtIndex:i] rangeOfString:@","].length);
//        NSLog(@"%d",[[removedOtherObjects objectAtIndex:i] rangeOfString:@"surface"].length);
        
        BOOL hasToKeep = NO;
        
        if ([[removedOtherObjects objectAtIndex:i] rangeOfString:@","].length > 0 || [[removedOtherObjects objectAtIndex:i] rangeOfString:@"surface"].length >0 || [[removedOtherObjects objectAtIndex:i] rangeOfString:@"line"].length>0)
        {
            hasToKeep = YES;
        }

        
        
        if (hasToKeep == NO)
        {
            NSLog(@"%@ IS DELETED!!",[removedOtherObjects objectAtIndex:i]);
            [removedOtherObjects removeObjectAtIndex:i];
        }
        
    }
    
    if (removedOtherObjects.count ==0 )
    {
        NSLog(@"Error reading text : %@",[error localizedFailureReason]);
    }
    else
    {
        self.stringOfPointsArray = removedOtherObjects;
        NSLog(@"Reading Finish!");
    }
    [self draw];
    
    
}

- (void)convertStringsToCGPoints
{
    for (id i in self.stringOfPointsArray)
    {
        NSArray *pointArr = [i componentsSeparatedByString:@","];
        CGPoint *point;
        point->x = [[pointArr objectAtIndex:0] floatValue];
        point->y = [[pointArr objectAtIndex:1] floatValue];
        [self.stringOfPointsArray addObject:CFBridgingRelease(point)];
    }
}


- (void)draw
{
    for (id i in self.stringOfPointsArray)
    {
        static NSString *objectKind;
        static BOOL isLoadingPieceOfPathFinished = NO;
        
        if ([i rangeOfString:@"surface"].length > 0)//当遇到表示surface开始的内容时
        {
            if (self.surfacePoints.count >0)
            {
                UIBezierPath *path = [[UIBezierPath alloc]init];
                NSValue *val = [self.surfacePoints objectAtIndex:0];
                CGPoint p = [val CGPointValue];
                [path moveToPoint:p];
                for (NSUInteger i = 1; i<self.surfacePoints.count ; i++)
                {
                    if (i == self.surfacePoints.count-1)
                    {
                        NSValue *val1 = [self.surfacePoints objectAtIndex:i];
                        CGPoint p1 = [val1 CGPointValue];
                        [path addLineToPoint:p1];
                        [path stroke];
                    }
                    else
                    {
                        NSValue *val1 = [self.surfacePoints objectAtIndex:i];
                        CGPoint p1 = [val1 CGPointValue];
                        [path addLineToPoint:p1];
                    }
                }
            }
            else if(self.linePoints.count >0)
            {
                
            }
            else
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
                [self.surfacePoints addObject:[NSValue valueWithCGPoint:CGPointFromString([NSString stringWithFormat:@"{%@}",i])]];
            }
            else if ([objectKind isEqual:@"line"])
            {
                [self.linePoints addObject:[NSValue valueWithCGPoint:CGPointFromString([NSString stringWithFormat:@"{%@}",i])]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
