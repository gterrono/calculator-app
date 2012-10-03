//
//  GRTViewController.m
//  Calculator
//
//  Created by Gregory Terrono on 10/1/12.
//  Copyright (c) 2012 Gregory Terrono. All rights reserved.
//

#import "GRTViewController.h"

@interface GRTViewController ()
- (IBAction)evaluate:(id)sender;
- (IBAction)backspace:(id)sender;
- (IBAction)clearDisplay:(id)sender;
- (IBAction)displayText:(id)sender;
- (IBAction)addNumericalValue:(id)sender;
- (IBAction)addOperator:(id)sender;
- (void)disableInvalidButtons;
- (void)disableButtons:(NSArray *)buttons;
- (void)enableButtons:(NSArray *)buttons;
- (double)getDouble:(NSString *)s;
- (double)processExpression:(int)index soFar:(double)soFar;
@property (weak, nonatomic) IBOutlet UIButton *point;
@property (weak, nonatomic) IBOutlet UIButton *equals;
@property (weak, nonatomic) IBOutlet UIButton *minus;
@property (weak, nonatomic) IBOutlet UIButton *plus;
@property (weak, nonatomic) IBOutlet UIButton *dividedBy;
@property (weak, nonatomic) IBOutlet UIButton *times;
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (strong, nonatomic) NSMutableArray *repr;
@end

@implementation GRTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _repr = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (double)processExpression:(int)index soFar:(double)soFar {
    if(_repr.count == index)
        return soFar;
    
    double d1 = soFar, d2 = [self getDouble:_repr[index+1]];
    char op = [(NSString*)_repr[index] characterAtIndex:0];
    
    index += 2;
    
    switch (op) {
        case '+':
            return d1 + [self processExpression:index soFar:d2];
            
        case '-':
            return d1 - [self processExpression:index soFar:d2];
            
        case '*':
            return [self processExpression:index soFar:d1*d2];
            
        case '/':
            return [self processExpression:index soFar:d1/d2];
    }
    
    return -HUGE_VAL;
}

- (IBAction)evaluate:(id)sender {
    double result = [self processExpression:1 soFar:[self getDouble:_repr[0]]];
    NSString *text = [NSString stringWithFormat:@"%g", result];
    _display.text = text;
    [_repr removeAllObjects];
    [_repr addObject:text];
}

- (double)getDouble:(NSString *)s {
    double d = -HUGE_VAL;
    [[NSScanner scannerWithString:s] scanDouble:&d];
    return d;
}

- (IBAction)backspace:(id)sender {	
    if(_display.text.length > 1) {
        _display.text = [_display.text substringToIndex:_display.text.length - 1];
        
        NSString *prev = _repr[_repr.count - 1];
        if(prev.length > 1)
            _repr[_repr.count - 1] = [prev substringToIndex:prev.length - 1];
        else
            [_repr removeLastObject];
        [self disableInvalidButtons];
    } else {
        _display.text = @"";
        [_repr removeLastObject];
        [self disableButtons: [NSArray arrayWithObjects: _equals, _plus, _point, _minus, _dividedBy, _times, nil]];
    }
}

- (IBAction)clearDisplay:(id)sender {
    _display.text = @"";
    [_repr removeAllObjects];
    [self disableButtons: [NSArray arrayWithObjects: _equals, _plus, _point, _minus, _dividedBy, _times, nil]];
}

- (IBAction)displayText:(id)sender {
    UIButton* button = (UIButton*) sender;
    _display.text = [_display.text stringByAppendingString: button.currentTitle];
    [self disableInvalidButtons];
}

- (IBAction)addNumericalValue:(id)sender {
    UIButton *b = (UIButton *) sender;
    NSString *title = b.currentTitle;
    if(_repr.count == 0) {
        [_repr addObject:title];
        _display.text = title;
    }
    else {
        double d;
        NSString *prev = _repr[_repr.count - 1];
        if([[NSScanner scannerWithString:prev] scanDouble:&d])
            _repr[_repr.count - 1] = [prev stringByAppendingString:title];
        else
            [_repr addObject:title];
        _display.text = [_display.text stringByAppendingString: title];
    }
    for(id obj in _repr)
NSLog(@"%@", obj);
[self disableInvalidButtons];
}

- (IBAction)addOperator:(id)sender {
    NSString *title = ((UIButton *)sender).currentTitle;
    [_repr addObject:title];
    _display.text = [_display.text stringByAppendingString: title];
    [self disableInvalidButtons];
}

- (void)disableInvalidButtons {
    [self enableButtons:[NSArray arrayWithObjects:_point, _equals, _minus, _plus, _dividedBy, _times, nil]];
    NSString *text = _display.text;
    switch ([text characterAtIndex:text.length - 1]) {
        case '.':
        case '-':
        case '+':
        case '*':
        case '/':
            [self disableButtons: [NSArray arrayWithObjects: _equals, _plus, _point, _minus, _dividedBy, _times, nil]];
    }
    
    //Uses a regex to determine whether or not to disable the . button	
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\.\\d*$" options:NSRegularExpressionCaseInsensitive error:&error];
    int numMatches = [regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)];
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
