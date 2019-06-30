//
//  Model.m
//  CalculateIT!
//
//  Created by Gross on 9/6/19.
//  Copyright © 2019 Oleksii Gnilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Math.h"
#import "Model.h"
#import "HistoryModel.h"

@interface Model() {
    HistoryModel *historyModel;
}

@property double accumulator;
@property double firstOperand;
@property (nonatomic, copy, nullable) double (^binaryFunction)(double, double);

@end

@implementation Model

BOOL isPending = NO;

- (HistoryModel *)historyModel {
    if (!historyModel) historyModel = [[HistoryModel alloc] init];
    return historyModel;
}

- (NSDictionary *)operations {
    double (^addition)(double, double) = ^(double op1, double op2) { return op1 + op2; };
    double (^subtraction)(double, double) = ^(double op1, double op2) { return op1 - op2; };
    double (^multiplication)(double, double) = ^(double op1, double op2) { return op1 * op2; };
    double (^division)(double, double) = ^(double op1, double op2) { return op1 / op2; };
    
    double(^logarithm)(double) = ^(double op) { return log(op); };
    double(^percentage)(double) = ^(double op) { return op / 100; };
    double(^squareRoot)(double) = ^(double op) { return sqrt(op); };
    double(^square)(double) = ^(double op) { return op * op; };
    
    double(^sin)(double) = ^(double op) {
        double radians = op * M_PI / 180;
        return sinh(radians);
    };
    
    double(^cos)(double) = ^(double op) {
        double radians = op * M_PI / 180;
        return cosh(radians);
    };

    NSDictionary *ops = @{
                          @"+": addition,
                          @"-": subtraction,
                          @"×": multiplication,
                          @"÷": division,
                          @"log": logarithm,
                          @"%": percentage,
                          @"√": squareRoot,
                          @"x²": square,
                          @"sin": sin,
                          @"cos": cos
                          
                          };
    return ops;
}

- (void)setOperand: (double)operand {
    self.accumulator = operand;
}

- (void)performCalculation: (NSString *)symbol {
    
    self.historyModel.operand = self.accumulator;          // setting an operand for history string
    
    if ([symbol isEqualToString:@"log"] || [symbol isEqualToString:@"%"] || [symbol isEqualToString:@"√"] || [symbol isEqualToString:@"x²"] || [symbol isEqualToString: @"cos"] || [symbol isEqualToString:@"sin"]) {
        
        double (^unaryOperation)(double) = [self.operations valueForKey: symbol];
        self.accumulator = unaryOperation(_accumulator);
        
        [self.historyModel combineCalculationString:symbol :NO];
        
    } else if ([symbol isEqualToString: @"+"] || [symbol isEqualToString: @"-"] || [symbol isEqualToString: @"×"] || [symbol isEqualToString: @"÷"]) {
        [self performBinaryOperation];
        self.binaryFunction = [self.operations valueForKey: symbol];
        self.firstOperand = _accumulator;
        
        [self.historyModel combineCalculationString :symbol :YES];
        
    } else if ([symbol isEqualToString:@"𝜋"]) {
        self.accumulator = M_PI;
        
    } else if ([symbol isEqualToString: @"="]) {
        [self performBinaryOperation];
        [self clear];
        
        [self.historyModel combineCalculationString :symbol :YES];
        
    }
}

- (void)performBinaryOperation {
    if (self.binaryFunction != nil && !isnan(self.firstOperand)) {
        self.accumulator = _binaryFunction(_firstOperand, _accumulator);
    }
}

- (double)result {
    return self.accumulator;
}

- (void)clear {
    isPending = NO;
    self.binaryFunction = nil;
    self.firstOperand = NAN;
}

@end
