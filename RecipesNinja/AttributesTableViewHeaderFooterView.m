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
        divider.backgroundColor = [UIColor colorWithRed:.9f green:.9f blue:.9f alpha:1.f];
        
        _difficultyTextView = [[UITextField alloc] initWithFrame:CGRectMake(320.f/2.f, 0.f, 160.f, 50.f)];
        _difficultyTextView.backgroundColor = [UIColor clearColor];
        _difficultyTextView.tintColor = [UIColor clearColor];
        _difficultyTextView.adjustsFontSizeToFitWidth = YES;
        _difficultyTextView.textAlignment = NSTextAlignmentCenter;
//        _difficultyTextView.inputView = self.difficultyPicker;
        _difficultyTextView.delegate = self;
        
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle	= UIBarStyleBlack;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = nil;
        [keyboardDoneButtonView sizeToFit];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toolbarDoneButtonPressed:)];
        UIBarButtonItem *flexibleSpace    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [keyboardDoneButtonView setItems:@[flexibleSpace,doneButton]];
        self.difficultyTextView.inputAccessoryView = keyboardDoneButtonView;
        
        [self.contentView addSubview:_favRecipeButton];
        [self.contentView addSubview:divider];
        [self.contentView addSubview:_difficultyTextView];
    }
    
    return self;
}

- (void)toolbarDoneButtonPressed:(id)sender {
    [self.difficultyTextView resignFirstResponder];
}

- (UIPickerView *)difficultyPicker {
    if (!_difficultyPicker) {
        _difficultyPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _difficultyPicker.dataSource = self;
        _difficultyPicker.delegate = self;
        _difficultyPicker.showsSelectionIndicator = YES;
//        _difficultyPicker.backgroundColor = [UIColor clearColor];
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    UIPickerView *pickerView = self.difficultyPicker;
    
    [pickerView selectRow:(_recipe.difficultyValue-1) inComponent:0 animated:NO];
    
    textField.inputView=pickerView;
    
    return YES;
}

#pragma mark - UIPickerView data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[_recipe difficultyValues] count];
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
