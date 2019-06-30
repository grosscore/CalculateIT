//
//  Model.h
//  CalculateIT!
//
//  Created by Gross on 9/6/19.
//  Copyright © 2019 Oleksii Gnilov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryModel.h"

@interface Model : NSObject

@property (nonatomic, readonly) double result;
- (void)performCalculation:(NSString *)symbol;
- (void)setOperand:(double)operand;
- (void)clear;

@end
