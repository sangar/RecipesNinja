#import "Recipe.h"
#import "CoreDataHelper.h"

@interface Recipe ()

// Private interface goes here.

@end


@implementation Recipe

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
