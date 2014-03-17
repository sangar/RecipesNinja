//
//  DateHelper.h
//  RecipesNinja
//
//  Created by Gard Sandholt on 17/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (NSDate *)ISO8601StringToDate:(NSString *)dateString;

@end
