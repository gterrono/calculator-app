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
- (void)disableInvalidButtons;
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
    if(_display.text.length > 1) {
        _display.text = [_display.text substringToIndex:_display.text.length - 1];
        [self disableInvalidButtons];
    } else {
        _display.text = @"";
        [self enableButtons:[NSArray arrayWithObjects:_point, _minus, nil]];
        [self disableButtons: [NSArray arrayWithObjects: _equals, _plus, _dividedBy, _times, nil]];
    }
}

- (IBAction)clearDisplay:(id)sender {
    _display.text = @"";
    [self enableButtons:[NSArray arrayWithObjects:_point, _minus, nil]];
    [self disableButtons: [NSArray arrayWithObjects: _equals, _plus, _dividedBy, _times, nil]];
}

- (IBAction)displayText:(id)sender {
    UIButton* button = (UIButton*) sender;
    _display.text = [_display.text stringByAppendingString: button.currentTitle];
    [self disableInvalidButtons];
}

- (void)disableInvalidButtons {
    [self enableButtons:[NSArray arrayWithObjects:_point, _equals, _minus, _plus, _dividedBy, _times, nil]];
    NSString *text = _display.text;
    switch ([text characterAtIndex:text.length - 1]) {
        case '.':
            [self disableButtons: [NSArray arrayWithObjects: _equals, _minus, _plus, _dividedBy, _times, nil]];
            break;
        case '-':
        case '+':
        case '*':
        case '/':
            [self disableButtons: [NSArray arrayWithObjects: _equals, _plus, _dividedBy, _times, nil]];
    }
    
    //Uses a regex to determine whether or not to disable the . button	
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\.\\d*$" options:NSRegularExpressionCaseInsensitive error:&error];
    int numMatches = [regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)];
    NSLog(@"%i", numMatches);
    if(numMatches > 0)
        [self disableButtons: [NSArray arrayWithObjects: _point, nil]];
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
