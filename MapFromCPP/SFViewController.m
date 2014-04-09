//
//  SFViewController.m
//  MapFromCPP
//
//  Created by 孙培峰 on 4/2/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "SFViewController.h"
#import "SFPoints.h"

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
    NSArray *plainText = [[NSMutableString stringWithContentsOfFile:filePath usedEncoding:nil error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] ;
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
    
    SFPoints *pointV = [[SFPoints alloc]init];
    [pointV drawWithStringsArray:self.stringOfPointsArray andSurfaceArray:self.surfacePoints andLineArray:self.linePoints];
    [pointV setTranslatesAutoresizingMaskIntoConstraints:NO];
    CGAffineTransform xform = CGAffineTransformMakeRotation(M_PI);
    pointV.transform = xform;
    [self.view addSubview:pointV];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pointV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    // align pointV from the top
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60.5-[pointV]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pointV)]];
    
    // width constraint
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pointV(==768)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pointV)]];
    
    // height constraint
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pointV(==1136)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(pointV)]];
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
