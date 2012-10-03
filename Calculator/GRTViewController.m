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
- (IBAction)clear:(id)sender;
- (IBAction)addNumericalValue:(id)sender;
- (IBAction)addOperator:(id)sender;
- (void)disableInvalidButtons;
- (void)disableButtons:(NSArray *)buttons;
- (void)enableButtons:(NSArray *)buttons;
- (double)getDouble:(NSString *)s;
- (double)evaluateHelper:(int)index soFar:(double)soFar;
- (void)clearDisplay;
- (void)setText:(NSString *)text;
@property (weak, nonatomic) IBOutlet UIButton *point;
@property (weak, nonatomic) IBOutlet UIButton *equals;
@property (weak, nonatomic) IBOutlet UIButton *minus;
@property (weak, nonatomic) IBOutlet UIButton *plus;
@property (weak, nonatomic) IBOutlet UIButton *dividedBy;
@property (weak, nonatomic) IBOutlet UIButton *times;
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (strong, nonatomic) NSMutableArray *repr;
@property (strong, nonatomic) NSString *displayText;
@property (nonatomic) BOOL justPressedEquals;
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

//The handler for the = button
- (IBAction)evaluate:(id)sender {
    double result = [self evaluateHelper:1 soFar:[self getDouble:_repr[0]]];
    NSString *text;
    [_repr removeAllObjects];
    if(result == -HUGE_VAL)
        text = @"Error: Division by 0";
    else {
        text = [NSString stringWithFormat:@"%g", result];
        [_repr addObject:text];
    }
    [self setText:text];
    _justPressedEquals = YES;
    [self disableInvalidButtons];
}

//Recursive function that does most of the work for evaluating an expression
//Relies on the controlled ways in which = can be pressed
//As such, this function assumes _repr is in the proper format
- (double)evaluateHelper:(int)index soFar:(double)soFar {
    //Base case
    if(_repr.count == index)
        return soFar;
    
    double d1 = soFar, d2 = [self getDouble:_repr[index+1]];
    char op = [(NSString*)_repr[index] characterAtIndex:0];
    
    index += 2;
    
    //For addition and subtraction, calculate the rest, and then do it
    //For mutiplication and division, do it, and then calculate the rest
    switch (op) {
        case '+':
            return d1 + [self evaluateHelper:index soFar:d2];
            
        case '-':
            return d1 - [self evaluateHelper:index soFar:d2];
            
        case '*':
            return [self evaluateHelper:index soFar:d1*d2];
            
        case '/':
            if(d2 == 0)
                break;
            return [self evaluateHelper:index soFar:d1/d2];
    }
    
    //Signaling an error
    return -HUGE_VAL;
}

//Returns a double extracted from the string passed in
- (double)getDouble:(NSString *)s {
    double d = -HUGE_VAL;
    [[NSScanner scannerWithString:s] scanDouble:&d];
    return d;
}

//The handler for the backspace button
- (IBAction)backspace:(id)sender {
    if(_displayText.length > 1) {
        [self setText:[_displayText substringToIndex:_displayText.length - 1]];
        
        //Determining whether to remove the last digit of a number in repr
        //or to remove the whole element
        NSString *prev = _repr[_repr.count - 1];
        if(prev.length > 1)
            _repr[_repr.count - 1] = [prev substringToIndex:prev.length - 1];
        else
            [_repr removeLastObject];
        [self disableInvalidButtons];
    } else {
        [self clearDisplay];
    }
    _justPressedEquals = NO;
}

//The handler for the clear button
- (IBAction)clear:(id)sender {
    [self clearDisplay];
    _justPressedEquals = NO;
}


//Helper function that resets the display, the representation, and the buttons
- (void)clearDisplay {
    [self setText:@""];
    [_repr removeAllObjects];
    [self disableInvalidButtons];
}

//Handler for buttons 0-9 and .
- (IBAction)addNumericalValue:(id)sender {
    UIButton *b = (UIButton *) sender;
    NSString *title = b.currentTitle;
    if(_repr.count == 0 || _justPressedEquals) {
        [_repr removeAllObjects];
        [_repr addObject:title];
        [self setText:title];
        _justPressedEquals = NO;
    }
    else {
        double d;
        NSString *prev = [_repr lastObject];
        //If this button press is a continuation of a number,
        //append it to the other part of the number in _repr
        //Otherwise add a new element to _repr
        if([[NSScanner scannerWithString:prev] scanDouble:&d])
            _repr[_repr.count - 1] = [prev stringByAppendingString:title];
        else
            [_repr addObject:title];
        [self setText:[_displayText stringByAppendingString: title]];
    }
    [self disableInvalidButtons];
}

//Handler for +, -, *, and /
- (IBAction)addOperator:(id)sender {
    NSString *title = ((UIButton *)sender).currentTitle;
    [_repr addObject:title];
    [self setText:[_displayText stringByAppendingString: title]];
    [self disableInvalidButtons];
    _justPressedEquals = NO;
}

//Helper that disables the correct buttons depending on the current input
//so that the user cannot enter invalid input
- (void)disableInvalidButtons {
    if(_repr.count == 0) {
        [self disableButtons: [NSArray arrayWithObjects: _equals, _plus, _point, _minus, _dividedBy, _times, nil]];
        return;
    }
    NSString *text = [_repr lastObject];
    
    //Uses a regex to determine whether or not to disable the . button	
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\.\\d*$" options:NSRegularExpressionCaseInsensitive error:&error];
    int numMatches = [regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)];
    if(numMatches > 0 || _justPressedEquals)
        [self disableButtons: [NSArray arrayWithObject:_point]];
    else
        [self enableButtons:[NSArray arrayWithObject:_point]];
    
    //Handle cases for +, -, *, /, .
    switch ([text characterAtIndex:text.length - 1]) {
        case '.':
        case '-':
        case '+':
        case '*':
        case '/':
            [self disableButtons: [NSArray arrayWithObjects: _equals, _plus, _point, _minus, _dividedBy, _times, nil]];
            break;
        default:
            [self enableButtons:[NSArray arrayWithObjects:_equals, _minus, _plus, _dividedBy, _times, nil]];
    }
}

//Helper to disable an array of buttons
- (void)disableButtons:(NSArray *)buttons {
    for (int i=0; i<buttons.count; i++) {
        UIButton *b = (UIButton *)buttons[i];
        b.enabled =	 NO;
        [b setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

//Helper to enable a list of buttons
- (void)enableButtons:(NSArray *)buttons {
    for (int i=0; i<buttons.count; i++) {
        UIButton *b = (UIButton *)buttons[i];
        b.enabled = YES;
        [b setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }
}

//Helper to set the display text while avoiding overflow
- (void)setText:(NSString *)text {
    _displayText = text;
    if (text.length > 26)
        _display.text = [text substringFromIndex:text.length - 26];
    else
        _display.text = text;
}
@end
