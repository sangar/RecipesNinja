//
//  CoreDataHelper.h
//  RecipesNinja
//
//  Created by Gard Sandholt on 16/3/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataHelper : NSObject

+ (NSManagedObjectContext *)managedObjectContext;
+ (BOOL)saveContext;

@end
