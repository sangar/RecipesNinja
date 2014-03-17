//
//  CoreDataHelper.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 16/3/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "CoreDataHelper.h"
#import "AppDelegate.h"

@implementation CoreDataHelper

+ (NSManagedObjectContext *)managedObjectContext {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.managedObjectContext;
}

+ (BOOL)saveContext {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return [appDelegate saveContext];
}

@end
