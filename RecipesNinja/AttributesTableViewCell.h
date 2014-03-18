//
//  AttributesTableViewCell.h
//  RecipesNinja
//
//  Created by Gard Sandholt on 17/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@protocol AttributesTableViewCellDelegate;


@interface AttributesTableViewCell : UITableViewCell

@property (nonatomic, strong) Recipe *recipe;
@property (nonatomic, assign) id delegate;

@end


@protocol AttributesTableViewCellDelegate <NSObject>

- (void)didPressFavoriteButtonInCell:(AttributesTableViewCell *)cell;

@end