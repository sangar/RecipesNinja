//
//  StringHelper.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 17/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper

+ (NSString *)stringFromPotetialNull:(id)potentialNull {
    if ([potentialNull isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return potentialNull;
}

@end
