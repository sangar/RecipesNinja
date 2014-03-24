//
//  RecipeDetailViewController.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 15/3/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "AttributesTableViewHeaderFooterView.h"
#import "TextViewTableViewCell.h"
#import "RecipePhotoTableViewCell.h"
#import "GSComposeView.h"
#import "CoreDataHelper.h"
#import "UIAlertView+AFNetworking.h"

@interface RecipeDetailViewController () <AttributesTableViewHeaderFooterViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, strong) NSArray *fieldsFirstSection;
@property(nonatomic, strong) NSArray *fieldsSecondSection;

@property(nonatomic, strong) UIImagePickerController *imagePickerController;

@end


static NSString * const ImageViewIdentifier = @"ImageViewIdentifier";
static NSString * const TextViewIdentifier = @"TextViewIdentifier";
static NSString * const AttributesIdentifier = @"AttributesIdentifier";

@implementation RecipeDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.viewControllerType = RecipeDetailViewControllerTypeNew;
    }
    return self;
}

- (void)saveRecipe {
    NSURLSessionDataTask *task = [_recipe saveWithBlock:^(BOOL saved, NSError *error) {
        if (!error) {
            [_recipe save];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

- (void)cancelNewRecipe {
    [[CoreDataHelper managedObjectContext] rollback];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (_viewControllerType) {
        case RecipeDetailViewControllerTypeNew:
            [self setEditing:YES];
            
            self.recipe = [Recipe newRecipe];
            
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNewRecipe)];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveRecipe)];
            
            self.title = NSLocalizedString(@"New recipe", nil);
            
            break;
        case RecipeDetailViewControllerTypeEditing:
            
            self.navigationItem.rightBarButtonItem = self.editButtonItem;
            
            self.title = [_recipe name];
            
            break;
    }
    
    _fieldsFirstSection = @[@"photo"];
    _fieldsSecondSection = @[NSLocalizedString(@"Name", nil), NSLocalizedString(@"Description", nil), NSLocalizedString(@"Instructions", nil)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    [self.tableView registerClass:[AttributesTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:AttributesIdentifier];
    
    [self.tableView registerClass:[RecipePhotoTableViewCell class] forCellReuseIdentifier:ImageViewIdentifier];
    [self.tableView registerClass:[TextViewTableViewCell class] forCellReuseIdentifier:TextViewIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (!editing) {
        if ([_recipe hasChanges]) {
            [_recipe updateWithBlock:^(BOOL saved, NSError *error) {
                if (!error) {
                    [_recipe save];
                }
            }];
        }
    }
}

#pragma mark -
#pragma mark - Table view delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50.f;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        AttributesTableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:AttributesIdentifier];
        
        headerView.delegate = self;
        headerView.recipe = _recipe;
        
        return headerView;
    }
    
    return [super tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return 200.f;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    return [_recipe textFieldHeightForName];
                case 1:
                    return [_recipe textFieldHeightForDescription];
                case 2:
                    ;
                    CGFloat height = [_recipe textFieldHeightForInstructions];
                    
                    return height > 105.f ? height : 105.f;
            }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
    
    if (tableView.isEditing) {
        
        NSLog(@"TableView is editing");
        
        switch (indexPath.section) {
            case 0:
                
                _imagePickerController = [[UIImagePickerController alloc] init];
                _imagePickerController.delegate = self;
                
                [self.navigationController presentViewController:_imagePickerController animated:YES completion:nil];
                
                break;
            case 1:
                
                switch (indexPath.row) {
                    case 0:
                    {
                        [GSComposeView showText:[_recipe name] withCompletionBlock:^(NSString *text) {
                            NSLog(@"Got text from compose view: %@", text);
                            [_recipe setName:text];
//                                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            [self.tableView reloadData];
                        }];
                    }
                        break;
                    case 1:
                    {
                        [GSComposeView showText:[_recipe recipeDescription] withCompletionBlock:^(NSString *text) {
                            NSLog(@"Got text from compose view: %@", text);
                            [_recipe setRecipeDescription:text];
//                                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            [self.tableView reloadData];
                        }];
                    }
                        break;
                    case 2:
                    {
                        [GSComposeView showText:[_recipe instructions] withCompletionBlock:^(NSString *text) {
                            NSLog(@"Got text from compose view: %@", text);
                            [_recipe setInstructions:text];
//                                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            [self.tableView reloadData];
                        }];
                    }
                        break;
                }
                
                break;
        }
    }
}


#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [_fieldsFirstSection count];
        case 1:
            return [_fieldsSecondSection count];
    }
    
    return 0;
}

- (NSString *)identifierForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return ImageViewIdentifier;
    }
    return TextViewIdentifier;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self identifierForIndexPath:indexPath] forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            ((RecipePhotoTableViewCell *)cell).recipe = _recipe;
            break;
        case 1:
            ((TextViewTableViewCell *)cell).infoLabel.text = [_fieldsSecondSection objectAtIndex:indexPath.row];
            UITextView *cellTextView = ((TextViewTableViewCell *)cell).textView;
            
//            BOOL resize = YES;
            
            switch (indexPath.row) {
                case 0:
                    cellTextView.attributedText = [_recipe attributedStringForName];
                    break;
                case 1:
                    cellTextView.attributedText = [_recipe attributedStringForDescription];
                    break;
                case 2:
                    ;
                    NSAttributedString *attrString = [_recipe attributedStringForInstructions];
//                    resize = [[attrString string] length] == 0 ? NO : YES;
                    
                    cellTextView.attributedText = attrString;
                    break;
            }
            
//            if (resize) {
                [cellTextView sizeToFit];
//            }
            
            break;
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    switch (indexPath.section) {
        case 1:
            return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark -
#pragma mark - UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickerImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _recipe.photo = UIImageJPEGRepresentation(pickerImage, 0.0);
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark - AttributesTableViewHeaderFooterViewDelegate delegate methods

- (void)didPressFavoriteButtonInHeaderFooterView:(AttributesTableViewHeaderFooterView *)headerFooterView {
    
    if (_viewControllerType == RecipeDetailViewControllerTypeNew) {
        _recipe.favoriteValue = !_recipe.favoriteValue;
        [self.tableView reloadData];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didPressFavoriteButtonWithRecipe:)]) {
        [self.delegate didPressFavoriteButtonWithRecipe:_recipe];
    }
    [self.tableView reloadData];
}


@end
