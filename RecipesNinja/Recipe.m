#import "Recipe.h"
#import "HyperAPIClient.h"
#import "CoreDataHelper.h"
#import "NumberHelper.h"

@interface Recipe ()

// Private interface goes here.

@end


@implementation Recipe




+ (Recipe *)recipeFromAttributes:(NSDictionary *)attributes {
    
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    
    
    NSNumber *rid = [NumberHelper numberFromPossibleNull:[attributes valueForKey:@"id"]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[Recipe entityName]];
    request.entity = [NSEntityDescription entityForName:[Recipe entityName] inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"rid = %@", rid];
    
    NSError *error = nil;
    Recipe *recipe = [[context executeFetchRequest:request error:&error] lastObject];
    
    // Create new
    if (!error && !recipe) {
        
        recipe = [Recipe insertInManagedObjectContext:context];
        
        recipe.rid = rid;

        recipe.name = [attributes valueForKey:@"name"];
        recipe.recipeDescription = [attributes valueForKey:@"description"];
        recipe.instructions = [[attributes valueForKey:@"instructions"] isKindOfClass:[NSNull class]] ? @"" : [attributes valueForKey:@"instructions"];
        recipe.favorite = [NumberHelper numberFromPossibleNull:[attributes valueForKey:@"favorite"]];
        recipe.difficulty = [NumberHelper numberFromPossibleNull:[attributes valueForKey:@"difficulty"]];
        recipe.photoURL = [attributes valueForKeyPath:@"photo.url"];
        
        [recipe save];
    }
    
// Update if updated_at is different
//    else if () {
//    }
    
    return recipe;
}

#pragma mark -

+ (NSURLSessionDataTask *)allRecipesWithBlock:(void (^)(NSArray *recipes, NSError *error))block {
    return [[HyperAPIClient sharedClient] GET:@"recipes" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *recipesFromResponse = JSON;
        NSMutableArray *mutableRecipes = [NSMutableArray arrayWithCapacity:[recipesFromResponse count]];
        for (NSDictionary *attributes in recipesFromResponse) {
            Recipe *recipe = [Recipe recipeFromAttributes:attributes];
            [mutableRecipes addObject:recipe];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableRecipes], nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}


#pragma mark -

- (BOOL)setAsFavorite:(BOOL)favorite {
    [self setFavoriteValue:favorite];
    return [self save];
}

- (BOOL)isFavorite {
    return [self favorite];
}

- (BOOL)save {
    return [CoreDataHelper saveContext];
}

@end
