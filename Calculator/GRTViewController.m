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
- (void)disableInvalidButtons:(char)lastChar;
- (void)disableButtons:(NSArray *)buttons;
- (void)enableButtons:(NSArray *)buttons;
@property (weak, nonatomic) IBOutlet UIButton *point;
@property (weak, nonatomic) IBOutlet UIButton *equals;
@property (weak, nonatomic) IBOutlet UIButton *minus;
@property (weak, nonatomic) IBOutlet UIButton *plus;
@property (weak, nonatomic) IBOutlet UIButton *dividedBy;
@property (weak, nonatomic) IBOutlet UIButton *times;
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
    if(_display.text.length > 0)
        _display.text = [_display.text substringToIndex:_display.text.length - 1];
}

- (IBAction)clearDisplay:(id)sender {
    _display.text = @"";
}

- (IBAction)displayText:(id)sender {
    UIButton* button = (UIButton*) sender;
    _display.text = [_display.text stringByAppendingString: button.currentTitle];
    [self disableInvalidButtons:[_display.text characterAtIndex:_display.text.length - 1]];
}

- (void)disableInvalidButtons:(char)lastChar {
    [self enableButtons:[NSArray arrayWithObjects:_point, _equals, _minus, _plus, _dividedBy, _times, nil]];
    switch (lastChar) {
        case '-':
            [self disableButtons: [NSArray arrayWithObjects: _equals, _plus, _dividedBy, _times, nil]];
    }
}

- (void)disableButtons:(NSArray *)buttons {
    for (int i=0; i<buttons.count; i++) {
        UIButton *b = (UIButton *)buttons[i];
        b.enabled =	 NO;
        [b setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (void)enableButtons:(NSArray *)buttons {
    for (int i=0; i<buttons.count; i++) {
        UIButton *b = (UIButton *)buttons[i];
        b.enabled = YES;
        [b setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }
}
@end
