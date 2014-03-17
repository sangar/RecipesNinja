#import "_Recipe.h"

@interface Recipe : _Recipe {}

+ (Recipe *)recipeFromAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)allRecipesWithBlock:(void (^)(NSArray *recipes, NSError *error))block;

- (BOOL)setAsFavorite:(BOOL)favorite;
- (BOOL)isFavorite;

- (BOOL)save;

@end
