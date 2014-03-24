#import "_Recipe.h"

@interface Recipe : _Recipe {}

// Initializer
+ (Recipe *)newRecipe;
+ (Recipe *)recipeFromAttributes:(NSDictionary *)attributes;

// Network methods
+ (NSURLSessionDataTask *)allWithBlock:(void (^)(NSArray *recipes, NSError *error))block;

- (NSURLSessionDataTask *)saveWithBlock:(void (^)(BOOL saved, NSError *error))block;
- (NSURLSessionDataTask *)updateWithBlock:(void (^)(BOOL updated, NSError *error))block;
- (NSURLSessionDataTask *)deleteWithBlock:(void (^)(BOOL deleted, NSError *error))block;

// Get methods
- (NSDictionary *)parameters;

+ (int32_t)nextRecipeID;

- (NSArray *)difficultyValues;
- (NSString *)difficultyToString;

+ (UIFont *)fontForName;
+ (UIFont *)fontForDescription;
+ (UIFont *)fontForInstructions;

- (NSAttributedString *)attributedStringForName;
- (NSAttributedString *)attributedStringForDescription;
- (NSAttributedString *)attributedStringForInstructions;

- (CGFloat)textFieldHeightForName;
- (CGFloat)textFieldHeightForDescription;
- (CGFloat)textFieldHeightForInstructions;

- (BOOL)isFavorite;

// Set methods
- (void)setAttributes:(NSDictionary *)attributes;
- (void)setPhotoInImageView:(UIImageView *)imageView;
- (BOOL)setAsFavorite:(BOOL)favorite;

// CoreData methods
- (BOOL)save;
- (BOOL)deleteObject;

@end
