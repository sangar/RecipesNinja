//
//  NumberHelper.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 17/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "NumberHelper.h"

@implementation NumberHelper

+ (NSNumber *)numberFromPossibleNull:(id)possibleNull {
    
    if ([possibleNull isKindOfClass:[NSNull class]]) {
        return [NSNumber numberWithInteger:0];
    }
    
    return [NSNumber numberWithInteger:[possibleNull integerValue]];
}

@end
