//
//  SFViewController.m
//  MapFromCPP
//
//  Created by 孙培峰 on 4/2/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "SFViewController.h"

@interface SFViewController ()

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
    
    NSError *error = [[NSError alloc]init];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"china1" ofType:@"txt"];
    NSArray *plainText = [[NSString stringWithContentsOfFile:filePath usedEncoding:nil error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] ;
    if (plainText == nil)
    {
        NSLog(@"Error reading text : %@",[error localizedFailureReason]);
    }
    else
    {
        NSLog(@"1");
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
