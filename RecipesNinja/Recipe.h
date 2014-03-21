#import "_Recipe.h"

@interface Recipe : _Recipe {}

// Initializer
+ (Recipe *)recipeFromAttributes:(NSDictionary *)attributes;

// Network methods
+ (NSURLSessionDataTask *)allWithBlock:(void (^)(NSArray *recipes, NSError *error))block;
- (NSURLSessionDataTask *)saveWithBlock:(void (^)(BOOL saved, NSError *error))block;
- (NSURLSessionDataTask *)deleteWithBlock:(void (^)(BOOL deleted, NSError *error))block;

// Get methods
- (NSDictionary *)parameters;

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

@end
