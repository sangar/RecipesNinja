//
//  RecipeDetailViewController.h
//  RecipesNinja
//
//  Created by Gard Sandholt on 15/3/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"


typedef NS_ENUM(NSInteger, RecipeDetailViewControllerType) {
    RecipeDetailViewControllerTypeNew = 0,
    RecipeDetailViewControllerTypeEditing
};

@protocol RecipeDetailViewControllerDelegate;


@interface RecipeDetailViewController : UITableViewController

@property (nonatomic, strong) Recipe *recipe;
@property (nonatomic, assign) id<RecipeDetailViewControllerDelegate> delegate;

@property (nonatomic, assign) RecipeDetailViewControllerType viewControllerType;

@end



@protocol RecipeDetailViewControllerDelegate <NSObject>

- (void)didPressFavoriteButtonWithRecipe:(Recipe *)recipe;

@end