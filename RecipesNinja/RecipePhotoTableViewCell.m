//
//  RecipePhotoTableViewCell.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 19/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "RecipePhotoTableViewCell.h"

@interface RecipePhotoTableViewCell()

@property(nonatomic, strong) UIImageView *headerImageView;

@end

@implementation RecipePhotoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 10.f, 180.f, 180.f)];
        _headerImageView.layer.cornerRadius = 90.f;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.center = CGPointMake(160.f, _headerImageView.center.y);
        
        [self.contentView addSubview:_headerImageView];
    }
    return self;
}

- (void)setRecipe:(Recipe *)recipe {
    _recipe = recipe;
    
    [recipe setPhotoInImageView:_headerImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
