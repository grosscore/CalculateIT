//
//  HistoryModel.h
//  CalculateIT!
//
//  Created by Oleksii Hnilov on 6/27/19.
//  Copyright © 2019 Oleksii Gnilov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HistoryModel : NSObject

@property (nonatomic) double operand;
- (void)combineCalculationString :(NSString *)symbol :(BOOL)isBinaryCalculation;
- (NSArray *)fetchHistory;

@end
