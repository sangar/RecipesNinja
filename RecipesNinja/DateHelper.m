//
//  DateHelper.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 17/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "DateHelper.h"
#import "TTTDateTransformers.h"

@implementation DateHelper

+ (NSDate *)ISO8601StringToDate:(NSString *)dateString {
    return [[NSValueTransformer valueTransformerForName:TTTISO8601DateTransformerName] reverseTransformedValue:dateString];
}

@end
