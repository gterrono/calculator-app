//
//  GRTViewController.m
//  Calculator
//
//  Created by Gregory Terrono on 10/1/12.
//  Copyright (c) 2012 Gregory Terrono. All rights reserved.
//

#import "GRTViewController.h"

@interface GRTViewController ()
- (IBAction)backspace:(id)sender;
- (IBAction)clearDisplay:(id)sender;
- (IBAction)displayText:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *display;

@end

@implementation GRTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backspace:(id)sender {
    
}

- (IBAction)clearDisplay:(id)sender {
    [_display setText: @""];
}

- (IBAction)displayText:(id)sender {
    UIButton* button = (UIButton*) sender;
    [_display setText: [_display.text stringByAppendingString: button.currentTitle]];
}
@end
