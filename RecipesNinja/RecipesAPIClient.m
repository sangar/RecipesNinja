//
//  RecipesAPIClient.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 13/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "RecipesAPIClient.h"

static NSString * const kRecipesAPIURLString = @"http://hyper-recipes.herokuapp.com";

@implementation RecipesAPIClient

+ (RecipesAPIClient *)sharedClient {
    static RecipesAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kRecipesAPIURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (NSNumber *)numberFromPossibleNull:(id)value {
    
    if ([value isKindOfClass:[NSNull class]]) {
        return [NSNumber numberWithInteger:0];
    }

    return [NSNumber numberWithInteger:[value integerValue]];
}

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity
                                 fromResponse:(NSHTTPURLResponse *)response
{
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];
    
    
//    NSLog(@"Entity name: %@", entity.name);
//    NSLog(@"Representation: %@", representation);
    
    if ([entity.name isEqualToString:@"Recipe"]) {
        
        NSNumber *rid = [representation valueForKey:@"id"];
        NSString *name = [representation valueForKey:@"name"];
        NSString *description = [representation valueForKey:@"description"];
        NSString *instructions = [representation valueForKey:@"instructions"];
        NSNumber *favorite = [self numberFromPossibleNull:[representation valueForKey:@"favorite"]];
        NSNumber *difficulty = [self numberFromPossibleNull:[representation valueForKey:@"difficulty"]];
        NSString *photoURL = [representation valueForKeyPath:@"photo.url"];
        
        [mutablePropertyValues setValue:rid forKey:@"rid"];
        [mutablePropertyValues setValue:name forKey:@"name"];
        [mutablePropertyValues setValue:description forKey:@"recipeDescription"];
        [mutablePropertyValues setValue:instructions forKey:@"instructions"];
        [mutablePropertyValues setValue:favorite forKey:@"favorite"];
        [mutablePropertyValues setValue:difficulty forKey:@"difficulty"];
        [mutablePropertyValues setValue:photoURL forKey:@"photoURL"];
    }
    
    return mutablePropertyValues;
}

- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
                                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    return [[[objectID entity] name] isEqualToString:@"Recipe"];
}

- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
                               forObjectWithID:(NSManagedObjectID *)objectID
                        inManagedObjectContext:(NSManagedObjectContext *)context
{
    return [[[objectID entity] name] isEqualToString:@"Recipe"];
}

@end