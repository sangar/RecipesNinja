//
//  RecipesTableViewCell.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 13/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "RecipesTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface RecipesTableViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *descriptionTextField;

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
        
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(130.f, 10.f, 180.f, 50.f)];
        _nameTextField.backgroundColor = [UIColor clearColor];
        _nameTextField.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:26.f];
        _nameTextField.adjustsFontSizeToFitWidth = YES;
        _nameTextField.userInteractionEnabled = NO;
        
        _descriptionTextField = [[UITextField alloc] initWithFrame:CGRectMake(130.f, 60.f, 180.f, 60.f)];
        _descriptionTextField.backgroundColor = [UIColor clearColor];
        _descriptionTextField.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22.f];
        _descriptionTextField.adjustsFontSizeToFitWidth = YES;
        _descriptionTextField.userInteractionEnabled = NO;
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_nameTextField];
        [self.contentView addSubview:_descriptionTextField];
    }
    return self;
}

- (void)setRecipe:(Recipe *)recipe {
    _recipe = recipe;
    
    [self.imageView setImageWithURL:[NSURL URLWithString:[recipe valueForKey:@"photoURL"]]];
    self.nameTextField.text = [recipe valueForKey:@"name"];
    self.descriptionTextField.text = [recipe valueForKey:@"recipeDescription"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        // Configure the view for the selected state
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.transform = CGAffineTransformScale(self.transform, 1.f*.7f, 1.f*.7f);
                         }
                         completion:^(BOOL finished) {
                             self.transform = CGAffineTransformScale(self.transform, 1.f/.7f, 1.f/.7f);
                         }];
    }
}

@end
