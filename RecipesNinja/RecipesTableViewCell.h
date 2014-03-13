//
//  RecipesTableViewCell.h
//  RecipesNinja
//
//  Created by Gard Sandholt on 13/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface RecipesTableViewCell : UITableViewCell

@property (nonatomic, strong) Recipe *recipe;

@end
