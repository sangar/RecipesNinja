#import "_Recipe.h"

@interface Recipe : _Recipe {}

+ (Recipe *)recipeFromAttributes:(NSDictionary *)attributes;

+ (NSURLSessionDataTask *)allRecipesWithBlock:(void (^)(NSArray *recipes, NSError *error))block;
- (NSURLSessionDataTask *)saveWithBlock:(void (^)(BOOL saved, NSError *error))block;
- (NSURLSessionDataTask *)updateWithBlock:(void (^)(BOOL updated, NSError *error))block;
- (NSURLSessionDataTask *)deleteWithBlock:(void (^)(BOOL deleted, NSError *error))block;

- (NSDictionary *)parameters;

- (void)setAttributes:(NSDictionary *)attributes;

- (BOOL)setAsFavorite:(BOOL)favorite;
- (BOOL)isFavorite;

- (BOOL)save;

@end
