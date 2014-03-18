//
//  RecipesTableViewCell.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 13/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "RecipesTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "GSProgressHUD.h"
#import "UIAlertView+AFNetworking.h"

@interface RecipesTableViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextView *descriptionTextField;
@property(nonatomic, strong) UIButton *favRecipeButton;

@end



@implementation RecipesTableViewCell

@synthesize imageView = _imageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, 5.f, 120.f, 120.f)];
        _imageView.layer.cornerRadius = 60.f;
        _imageView.layer.masksToBounds = YES;
        
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(115.f, 10.f, 200.f, 25.f)];
        _nameTextField.backgroundColor = [UIColor clearColor];
        _nameTextField.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22.f];
//        _nameTextField.adjustsFontSizeToFitWidth = YES;
        _nameTextField.userInteractionEnabled = NO;
        
        _descriptionTextField = [[UITextView alloc] initWithFrame:CGRectMake(130.f, 30.f, 180.f, 70.f)];
        _descriptionTextField.backgroundColor = [UIColor clearColor];
        _descriptionTextField.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18.f];
//        _descriptionTextField.adjustsFontSizeToFitWidth = YES;
        _descriptionTextField.userInteractionEnabled = NO;
        
//        _favImageView = [[UIImageView alloc] initWithFrame:CGRectMake(285.f, 105.f, 25.f, 25.f)];
//        _favImageView.image = [[UIImage imageNamed:@"star"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        _favImageView.tintColor = [UIColor yellowColor];
        
        _favRecipeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _favRecipeButton.frame = CGRectMake(285.f, 105.f, 25.f, 25.f);
        [_favRecipeButton setImage:[UIImage imageNamed:@"star_unsel"] forState:UIControlStateNormal];
        [_favRecipeButton addTarget:self action:@selector(favRecipeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_nameTextField];
        [self.contentView addSubview:_descriptionTextField];
        [self.contentView addSubview:_favRecipeButton];
    }
    return self;
}

- (void)favRecipeButtonPressed:(id)sender {
    
    // TODO: make delegate method and use same code as tableview
    
    _recipe.favoriteValue = ![_recipe favoriteValue];
    [GSProgressHUD popImage:[UIImage imageNamed:@"star"] withStatus:_recipe.favoriteValue ? NSLocalizedString(@"Favorite", nil) : NSLocalizedString(@"NOT", nil)];
    
    NSURLSessionDataTask *task = [_recipe updateWithBlock:^(BOOL updated, NSError *error) {
        if (!error) {
            [_recipe save];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

- (void)setRecipe:(Recipe *)recipe {
    _recipe = recipe;
    
    [recipe setPhotoInImageView:self.imageView];
    self.nameTextField.text = [recipe name];
    self.descriptionTextField.text = [recipe recipeDescription];
    if ([recipe isFavorite]) {
        [_favRecipeButton setImage:[UIImage imageNamed:@"star_sel"] forState:UIControlStateNormal];
    } else {
        [_favRecipeButton setImage:[UIImage imageNamed:@"star_unsel"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        // Configure the view for the selected state
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transform = CGAffineTransformScale(self.transform, 1.f*.9f, 1.f*.9f);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 self.transform = CGAffineTransformScale(self.transform, 1.f/.9f, 1.f/.9f);
                             }
                         }];
    }
}

@end
