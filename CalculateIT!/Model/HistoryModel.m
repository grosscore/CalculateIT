//
//  HistoryModel.m
//  CalculateIT!
//
//  Created by Oleksii Hnilov on 6/27/19.
//  Copyright © 2019 Oleksii Gnilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryModel.h"
#import "Model.h"

@interface HistoryModel() {
    Model *model;
    NSMutableArray *calculationHistory;
}

@end

@implementation HistoryModel

NSString *calculationString = @"";

- (Model *) model {
    if (!model) model = [[Model alloc] init];
    return model;
}

- (NSMutableArray *)calculationHistory {
    if (!calculationHistory) calculationHistory = [[NSMutableArray alloc] init];
    return calculationHistory;
}

- (void)combineCalculationString :(NSString *)symbol :(BOOL)isBinaryCalculation {
    
    NSNumber *operand = [NSNumber numberWithDouble: self.operand];
    
    if (isBinaryCalculation) {
        NSString *resultString = [NSString stringWithFormat: @"%@ %@ ", operand, symbol];
        calculationString = [calculationString stringByAppendingString:resultString];
        
        if ([symbol isEqualToString:@"="]) {
            NSNumber *resultNumber = [NSNumber numberWithDouble: model.result];
            NSString *resultString = [NSString stringWithFormat: @"%@", resultNumber];
            calculationString = [calculationString stringByAppendingString: resultString];
            [self.calculationHistory addObject: calculationString];
            [self saveHistory];
            calculationString = @"";
        }
        
    } else {
        NSNumber *resultNumber = [NSNumber numberWithDouble: model.result];
        NSString *resultString = [NSString stringWithFormat: @"%@ %@ = %@", operand, symbol, resultNumber];
        calculationString = [calculationString stringByAppendingString:resultString];
        [self.calculationHistory addObject: calculationString];
        [self saveHistory];
        calculationString = @"";
    }
}

- (void)saveHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: calculationHistory forKey: @"calculationHistory"];
    [defaults synchronize];
}

- (NSArray *)fetchHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *history = [defaults arrayForKey:@"calculationHistory"];
    return history;
}



@end
