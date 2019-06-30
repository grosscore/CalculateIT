//
//  ViewController.m
//  CalculateIT!
//
//  Created by Gross on 3/6/19.
//  Copyright © 2019 Oleksii Gnilov. All rights reserved.
//

#import "ViewController.h"
#import "HistoryTableViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *extendedStackView;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (nonatomic) double displayValue;

@end

@implementation ViewController

#pragma mark - Properties

BOOL isTyping = NO;

- (Model *) model {
    if (!model) model = [[Model alloc] init];
    return model;
}

- (double)displayValue {
    return [_displayLabel.text doubleValue];
}

- (void)setDisplayValue: (double)displayValue {
    NSNumber *resultNumber = [NSNumber numberWithDouble:displayValue];
    self.displayLabel.text = [resultNumber stringValue];
    [self limitDisplayText];
}

#pragma mark - View's lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideExtendedStackViewIfNeeded];
    [self addSwipeGestureRecognizer];
}

- (void)viewWillLayoutSubviews {
    [self hideExtendedStackViewIfNeeded];
}

#pragma mark - Functionality

- (IBAction)enterDigit: (UIButton *)sender {
    NSString *currentDisplayValue = _displayLabel.text;
    if (isTyping) {
        NSString *newDisplayValue = [currentDisplayValue stringByAppendingString: sender.titleLabel.text];
        self.displayLabel.text = newDisplayValue;
        [self limitDisplayText];
    } else {
        NSString *zeroValue = @"0";
        if ([sender.titleLabel.text isEqualToString: zeroValue] && [_displayLabel.text isEqualToString: zeroValue]) {
            isTyping = NO;
        } else {
            self.displayLabel.text = sender.titleLabel.text;
            isTyping = YES;
        }
    }
    
}

- (IBAction)fraction: (UIButton *)sender {
    if (![self.displayLabel.text containsString:@"."]) {
        self.displayLabel.text = [self.displayLabel.text stringByAppendingString:@"."];
        isTyping = YES;
    }
}

- (IBAction)toggleSign: (UIButton *)sender {
    self.displayValue = self.displayValue * -1;
}

- (IBAction)performCalculation:(UIButton *)sender {
    if (isTyping) {
        [self.model setOperand: self.displayValue];
        isTyping = NO;
    }
    
    [self.model performCalculation: sender.currentTitle];
    self.displayValue = model.result;
}

#pragma - Swipe gesture

- (void)addSwipeGestureRecognizer {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector(swipe:)];
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)swipe: (UISwipeGestureRecognizer *)sender {
    NSString *displayText = self.displayLabel.text;
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (displayText.length > 1) {
            displayText = [displayText substringToIndex: [displayText length] - 1];
            self.displayLabel.text = displayText;
        } else {
            self.displayLabel.text = @"0";
            isTyping = NO;
        }
        
    }
}

#pragma mark - Helping Methods

- (IBAction)clearCalculator: (UIButton *)sender {
    [self.model clear];
    [self.model setOperand: 0.0];
    self.displayValue = 0;
    isTyping = NO;
}

- (void)limitDisplayText {
    if (self.displayLabel.text.length > 16) {
        self.displayLabel.text = [self.displayLabel.text substringToIndex: 16];
    }
}

- (void)hideExtendedStackViewIfNeeded {
    self.extendedStackView.hidden = UIDeviceOrientationIsPortrait(UIDevice.currentDevice.orientation);
}

@end
