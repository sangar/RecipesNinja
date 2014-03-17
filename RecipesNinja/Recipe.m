#import "Recipe.h"
#import "HyperAPIClient.h"
#import "CoreDataHelper.h"
#import "NumberHelper.h"
#import "DateHelper.h"
#import "StringHelper.h"
#import "UIImageView+AFNetworking.h"


@interface Recipe ()

// Private interface goes here.

@end


@implementation Recipe


#pragma mark - Initializers

+ (Recipe *)recipeFromAttributes:(NSDictionary *)attributes {
    
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    
    NSNumber *rid = [NumberHelper numberFromPossibleNull:[attributes valueForKey:@"id"]];
    NSDate *updatedAt = [DateHelper ISO8601StringToDate:[attributes valueForKey:@"updated_at"]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[Recipe entityName]];
    request.entity = [NSEntityDescription entityForName:[Recipe entityName] inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"rid = %@", rid];
    
    NSError *error = nil;
    Recipe *recipe = [[context executeFetchRequest:request error:&error] lastObject];
    
    // Create new
    if (!error && !recipe) {
        recipe = [Recipe insertInManagedObjectContext:context];
        [recipe setAttributes:attributes];
    } else if (![updatedAt isEqualToDate:recipe.updatedAt]) {
        [recipe setAttributes:attributes];
    }
    
    return recipe;
}



#pragma mark - Network methods

+ (NSURLSessionDataTask *)allWithBlock:(void (^)(NSArray *recipes, NSError *error))block {
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

- (NSURLSessionDataTask *)saveWithBlock:(void (^)(BOOL saved, NSError *error))block {
    if (self.rid != nil) {
        return [self updateWithBlock:block];
    } else {
        return [[HyperAPIClient sharedClient] POST:@"recipes" parameters:[self parameters] success:^(NSURLSessionDataTask *task, id responseObject) {
            
            // TODO: send multipart with image
            
            NSLog(@"Saved response: %@", responseObject);
            
            if (block) {
                block(YES, nil);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (block) {
                block(NO, error);
            }
        }];
    }
}

- (NSURLSessionDataTask *)updateWithBlock:(void (^)(BOOL updated, NSError *error))block {
    
    NSString *URLPath = [NSString stringWithFormat:@"recipes/%d", self.ridValue];
    NSDictionary *params = [self parameters];
    
    return [[HyperAPIClient sharedClient] PUT:URLPath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // TODO: send multipart with image
        
        if (block) {
            block(YES, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(NO, error);
        }
    }];
}

- (NSURLSessionDataTask *)deleteWithBlock:(void (^)(BOOL deleted, NSError *error))block {
    NSString *URLPath = [NSString stringWithFormat:@"recipes/%d", self.ridValue];
    
    return [[HyperAPIClient sharedClient] DELETE:URLPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"Delete response: %@", responseObject);
        
        if (block) {
            block(YES, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(NO, error);
        }
    }];
}


#pragma mark - Get values

- (NSDictionary *)parameters {
    return @{@"recipe": @{
                     @"id" : self.rid,
                     @"name": self.name,
                     @"description": self.recipeDescription,
                     @"instructions": self.instructions,
                     @"favorite": self.favorite,
                     @"difficulty": self.difficulty
                     }};
}

#pragma mark - Set values

- (void)setPhotoInImageView:(UIImageView *)imageView {
    if (!self.photo) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self valueForKey:@"photoURL"]]];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        [imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.photo = UIImageJPEGRepresentation(image, 0.0f);
            [self save];
        } failure:nil];
    } else {
        imageView.image = [UIImage imageWithData:self.photo];
    }
}

- (void)setAttributes:(NSDictionary *)attributes {
    self.rid = [NumberHelper numberFromPossibleNull:[attributes valueForKey:@"id"]];
    
    self.name = [attributes valueForKey:@"name"];
    self.recipeDescription = [attributes valueForKey:@"description"];
    self.instructions = [StringHelper stringFromPotetialNull:[attributes valueForKey:@"instructions"]];
    self.favorite = [NumberHelper numberFromPossibleNull:[attributes valueForKey:@"favorite"]];
    self.difficulty = [NumberHelper numberFromPossibleNull:[attributes valueForKey:@"difficulty"]];
    self.photoURL = [attributes valueForKeyPath:@"photo.url"];
    
    self.createdAt = [DateHelper ISO8601StringToDate:[attributes valueForKey:@"created_at"]];
    self.updatedAt = [DateHelper ISO8601StringToDate:[attributes valueForKey:@"updated_at"]];
    
    [self save];
}

- (BOOL)setAsFavorite:(BOOL)favorite {
    [self setFavoriteValue:favorite];
    return [self save];
}

- (BOOL)isFavorite {
    return [self favoriteValue];
}

- (BOOL)save {
    return [CoreDataHelper saveContext];
}

@end
