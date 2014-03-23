#import "Recipe.h"
#import "HyperAPIClient.h"
#import "CoreDataHelper.h"
#import "NumberHelper.h"
#import "DateHelper.h"
#import "StringHelper.h"
#import "UIImageView+AFNetworking.h"


@interface Recipe ()

// Private interface goes here.
- (NSURLSessionDataTask *)updateWithBlock:(void (^)(BOOL updated, NSError *error))block;

@end


@implementation Recipe


#pragma mark - Initializers

+ (Recipe *)newRecipe {
    
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    
    Recipe *recipe = [Recipe insertInManagedObjectContext:context];
    
    recipe.rid = nil;
    recipe.name = @"";
    recipe.recipeDescription = @"";
    recipe.instructions = @"";
    recipe.favorite = [NSNumber numberWithInteger:0];
    recipe.difficulty = [NSNumber numberWithInteger:1];
    recipe.photoURL = nil;
    
    return recipe;
}

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
        return [[HyperAPIClient sharedClient] POST:@"recipes" parameters:[self parameters] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:self.photo name:@"photo" fileName:@"photo.jpg" mimeType:@"photo/jpeg"];
        } success:^(NSURLSessionDataTask *task, id responseObject) {
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
                     @"id": self.rid,
                     @"name": self.name,
                     @"description": self.recipeDescription,
                     @"instructions": self.instructions,
                     @"favorite": self.favorite,
                     @"difficulty": self.difficulty
                     }};
}

- (NSArray *)difficultyValues {
    return @[
             NSLocalizedString(@"Easy", nil),
             NSLocalizedString(@"Intermediate", nil),
             NSLocalizedString(@"Hard", nil)
            ];
}

- (NSString *)difficultyToString {
    switch (self.difficultyValue) {
        case 1:
            return [[self difficultyValues] objectAtIndex:0];
        case 2:
            return [[self difficultyValues] objectAtIndex:1];
        case 3:
            return [[self difficultyValues] objectAtIndex:2];
    }
    return NSLocalizedString(@"Unknown", nil);
}

+ (UIFont *)fontForName {
    return [UIFont fontWithName:@"Helvetica-Light" size:22.f];
}

+ (UIFont *)fontForDescription {
    return [UIFont fontWithName:@"Helvetica-Light" size:22.f];
}

+ (UIFont *)fontForInstructions {
    return [UIFont fontWithName:@"Helvetica-Light" size:20.f];
}

- (NSAttributedString *)attributedStringFromString:(NSString *)string andFond:(UIFont *)font {
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font}];
}

- (NSAttributedString *)attributedStringForName {
    return [self attributedStringFromString:self.name andFond:[Recipe fontForName]];
}

- (NSAttributedString *)attributedStringForDescription {
    return [self attributedStringFromString:self.recipeDescription andFond:[Recipe fontForDescription]];
}

- (NSAttributedString *)attributedStringForInstructions {
    return [self attributedStringFromString:self.instructions andFond:[Recipe fontForInstructions]];
}

- (CGFloat)textViewHeghtForString:(NSString *)string andFont:(UIFont *)font {
    UITextView *calcTextView = [[UITextView alloc] init];
    NSAttributedString *attributedText = [self attributedStringFromString:string andFond:font];
    [calcTextView setAttributedText:attributedText];
    CGSize size = [calcTextView sizeThatFits:CGSizeMake(320.f, FLT_MAX)];
    return size.height;
}

static CGFloat const kInfoLabelHeight = 21.f;

- (CGFloat)textFieldHeightForName {
    return [self textViewHeghtForString:self.name andFont:[Recipe fontForName]] + kInfoLabelHeight;
}

- (CGFloat)textFieldHeightForDescription {
    return [self textViewHeghtForString:self.recipeDescription andFont:[Recipe fontForDescription]] + kInfoLabelHeight;
}

- (CGFloat)textFieldHeightForInstructions {
    return [self textViewHeghtForString:self.instructions andFont:[Recipe fontForInstructions]] + kInfoLabelHeight;
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
