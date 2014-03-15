//
//  RecipeDetailViewController.h
//  RecipesNinja
//
//  Created by Gard Sandholt on 15/3/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface RecipeDetailViewController : UITableViewController

@property (nonatomic, strong) Recipe *recipe;

@end
