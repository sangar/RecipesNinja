//
//  AttributesTableViewCell.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 17/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "AttributesTableViewCell.h"

@interface AttributesTableViewCell()

@property (nonatomic, strong) UIButton *favRecipeButton;
@property (nonatomic, strong) UILabel *difficultyLabel;

- (void)favRecipeButtonPressed:(id)sender;

@end

@implementation AttributesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _favRecipeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _favRecipeButton.frame = CGRectMake(62.5f, 7.5f, 35.f, 35.f);
        [_favRecipeButton setImage:[UIImage imageNamed:@"star_unsel"] forState:UIControlStateNormal];
        [_favRecipeButton addTarget:self action:@selector(favRecipeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _difficultyLabel = [[UILabel alloc] initWithFrame:CGRectMake(202.5f, 7.5f, 55.f, 35.f)];
        
        
        [self.contentView addSubview:_favRecipeButton];
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
    if ([self.delegate respondsToSelector:@selector(didPressFavoriteButtonInCell:)]) {
        [self.delegate didPressFavoriteButtonInCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
