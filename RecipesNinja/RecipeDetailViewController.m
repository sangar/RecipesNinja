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
#import "GSComposeInputView.h"

@interface RecipeDetailViewController () <AttributesTableViewHeaderFooterViewDelegate>

@property(nonatomic, strong) NSArray *fieldsFirstSection;
@property(nonatomic, strong) NSArray *fieldsSecondSection;

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _fieldsFirstSection = @[@"photo"];
    _fieldsSecondSection = @[NSLocalizedString(@"Name", nil), NSLocalizedString(@"Description", nil), NSLocalizedString(@"Instructions", nil)];
    
    
    self.title = [_recipe name];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    [self.tableView registerClass:[AttributesTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:AttributesIdentifier];
    
    [self.tableView registerClass:[RecipePhotoTableViewCell class] forCellReuseIdentifier:ImageViewIdentifier];
    [self.tableView registerClass:[TextViewTableViewCell class] forCellReuseIdentifier:TextViewIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return ImageViewIdentifier;
            }
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
            
            BOOL resize = YES;
            
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
                    resize = [[attrString string] length] == 0 ? NO : YES;
                    
                    cellTextView.attributedText = attrString;
                    break;
            }
            
            if (resize) {
                [cellTextView sizeToFit];
            }
            
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }
    NSLog(@"commitEditingStyle");
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didSelectRowAtIndexPath");
    
    if (tableView.isEditing) {
        
        NSLog(@"TableView is editing");
        
        switch (indexPath.section) {
            case 1:
                
                switch (indexPath.row) {
                    case 0:
                        [GSComposeInputView showText:[_recipe name] withCompletionBlock:^(NSString *text) {
                            NSLog(@"Got text from compose view: %@", text);
                        }];
                        break;
                    case 1:
                        [GSComposeInputView showText:[_recipe recipeDescription] withCompletionBlock:^(NSString *text) {
                            NSLog(@"Got text from compose view: %@", text);
                        }];
                        break;
                    case 2:
                        [GSComposeInputView showText:[_recipe instructions] withCompletionBlock:^(NSString *text) {
                            NSLog(@"Got text from compose view: %@", text);
                        }];
                        break;
                }
                
                break;
        }
    }
}

#pragma mark -
#pragma mark - AttributesTableViewHeaderFooterViewDelegate delegate methods

- (void)didPressFavoriteButtonInHeaderFooterView:(AttributesTableViewHeaderFooterView *)headerFooterView {
    if ([self.delegate respondsToSelector:@selector(didPressFavoriteButtonWithRecipe:)]) {
        [self.delegate didPressFavoriteButtonWithRecipe:_recipe];
    }
    [self.tableView reloadData];
}


@end
