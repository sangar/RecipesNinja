//
//  AttributesTableViewHeaderFooterView.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 17/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "AttributesTableViewHeaderFooterView.h"

@interface AttributesTableViewHeaderFooterView()

@property (nonatomic, strong) UIButton *favRecipeButton;
@property (nonatomic, strong) UILabel *difficultyLabel;

- (void)favRecipeButtonPressed:(id)sender;

@end

@implementation AttributesTableViewHeaderFooterView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _favRecipeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _favRecipeButton.frame = CGRectMake(62.5f, 7.5f, 35.f, 35.f);
        [_favRecipeButton setImage:[UIImage imageNamed:@"star_unsel"] forState:UIControlStateNormal];
        [_favRecipeButton addTarget:self action:@selector(favRecipeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(320.f/2.f, 0.f, .5f, 50.f)];
        divider.backgroundColor = [UIColor blackColor];
        
        _difficultyLabel = [[UILabel alloc] initWithFrame:CGRectMake(320.f/2.f, 0.f, 160.f, 50.f)];
        _difficultyLabel.backgroundColor = [UIColor clearColor];
        _difficultyLabel.adjustsFontSizeToFitWidth = YES;
        _difficultyLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_favRecipeButton];
        [self.contentView addSubview:divider];
        [self.contentView addSubview:_difficultyLabel];
    }
    
    return self;
}

- (void)setRecipe:(Recipe *)recipe {
    _recipe = recipe;
    
    if (recipe.isFavorite) {
        [_favRecipeButton setImage:[UIImage imageNamed:@"star_sel"] forState:UIControlStateNormal];
    } else {
        [_favRecipeButton setImage:[UIImage imageNamed:@"star_unsel"] forState:UIControlStateNormal];
    }
    
    _difficultyLabel.text = recipe.difficultyToString;
}

- (void)favRecipeButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didPressFavoriteButtonInHeaderFooterView:)]) {
        [self.delegate didPressFavoriteButtonInHeaderFooterView:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
