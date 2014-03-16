//
//  RecipesTableViewCell.h
//  RecipesNinja
//
//  Created by Gard Sandholt on 13/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"
#import "Recipe.h"

@interface RecipesTableViewCell : MCSwipeTableViewCell

@property (nonatomic, strong) Recipe *recipe;

@end
