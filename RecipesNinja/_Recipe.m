// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recipe.m instead.

#import "_Recipe.h"

const struct RecipeAttributes RecipeAttributes = {
	.difficulty = @"difficulty",
	.favorite = @"favorite",
	.instructions = @"instructions",
	.name = @"name",
	.photoURL = @"photoURL",
	.recipeDescription = @"recipeDescription",
	.rid = @"rid",
};

const struct RecipeRelationships RecipeRelationships = {
};

const struct RecipeFetchedProperties RecipeFetchedProperties = {
};

@implementation RecipeID
@end

@implementation _Recipe

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Recipe";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:moc_];
}

- (RecipeID*)objectID {
	return (RecipeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"difficultyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"difficulty"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"favoriteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favorite"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"ridValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rid"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic difficulty;



- (int32_t)difficultyValue {
	NSNumber *result = [self difficulty];
	return [result intValue];
}

- (void)setDifficultyValue:(int32_t)value_ {
	[self setDifficulty:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveDifficultyValue {
	NSNumber *result = [self primitiveDifficulty];
	return [result intValue];
}

- (void)setPrimitiveDifficultyValue:(int32_t)value_ {
	[self setPrimitiveDifficulty:[NSNumber numberWithInt:value_]];
}





@dynamic favorite;



- (BOOL)favoriteValue {
	NSNumber *result = [self favorite];
	return [result boolValue];
}

- (void)setFavoriteValue:(BOOL)value_ {
	[self setFavorite:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFavoriteValue {
	NSNumber *result = [self primitiveFavorite];
	return [result boolValue];
}

- (void)setPrimitiveFavoriteValue:(BOOL)value_ {
	[self setPrimitiveFavorite:[NSNumber numberWithBool:value_]];
}





@dynamic instructions;






@dynamic name;






@dynamic photoURL;






@dynamic recipeDescription;






@dynamic rid;



- (int32_t)ridValue {
	NSNumber *result = [self rid];
	return [result intValue];
}

- (void)setRidValue:(int32_t)value_ {
	[self setRid:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRidValue {
	NSNumber *result = [self primitiveRid];
	return [result intValue];
}

- (void)setPrimitiveRidValue:(int32_t)value_ {
	[self setPrimitiveRid:[NSNumber numberWithInt:value_]];
}










@end
