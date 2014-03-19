//
//  AttributesTableViewHeaderFooterView.h
//  RecipesNinja
//
//  Created by Gard Sandholt on 17/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@protocol AttributesTableViewHeaderFooterViewDelegate;


@interface AttributesTableViewHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) Recipe *recipe;
@property (nonatomic, assign) id delegate;

@end


@protocol AttributesTableViewHeaderFooterViewDelegate <NSObject>

- (void)didPressFavoriteButtonInHeaderFooterView:(AttributesTableViewHeaderFooterView *)headerFooterView;

@end