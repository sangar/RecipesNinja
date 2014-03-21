//
//  AttributesTableViewHeaderFooterView.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 17/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "AttributesTableViewHeaderFooterView.h"

@interface AttributesTableViewHeaderFooterView () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIButton *favRecipeButton;
@property (nonatomic, strong) UITextField *difficultyTextView;

@property (nonatomic, strong) UIPickerView *difficultyPicker;

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
        
        _difficultyTextView = [[UITextField alloc] initWithFrame:CGRectMake(320.f/2.f, 0.f, 160.f, 50.f)];
        _difficultyTextView.backgroundColor = [UIColor clearColor];
        _difficultyTextView.adjustsFontSizeToFitWidth = YES;
        _difficultyTextView.textAlignment = NSTextAlignmentCenter;
        _difficultyTextView.inputView = self.difficultyPicker;
        _difficultyTextView.delegate = self;
        
        [self.contentView addSubview:_favRecipeButton];
        [self.contentView addSubview:divider];
        [self.contentView addSubview:_difficultyTextView];
    }
    
    return self;
}

- (UIPickerView *)difficultyPicker {
    if (!_difficultyPicker) {
        _difficultyPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 120.f)];
        
    }
    return _difficultyPicker;
}

- (void)setRecipe:(Recipe *)recipe {
    _recipe = recipe;
    
    if (recipe.isFavorite) {
        [_favRecipeButton setImage:[UIImage imageNamed:@"star_sel"] forState:UIControlStateNormal];
    } else {
        [_favRecipeButton setImage:[UIImage imageNamed:@"star_unsel"] forState:UIControlStateNormal];
    }
    
    _difficultyTextView.text = recipe.difficultyToString;
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


#pragma mark - UITextField delegate methods

//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    return NO;
//}

#pragma mark - UIPickerView data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [[_recipe difficultyValues] count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 1;
}

#pragma mark - UIPickerView delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[_recipe difficultyValues] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _recipe.difficultyValue = ((int)row+1);
    _difficultyTextView.text = [[_recipe difficultyValues] objectAtIndex:row];
}

@end
