//
//  RecipesTableViewController.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 13/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "RecipesTableViewController.h"
#import "RecipesTableViewCell.h"
#import "Recipe.h"
#import "RecipeDetailViewController.h"
#import "UIAlertView+AFNetworking.h"
#import "GSProgressHUD.h"

@interface RecipesTableViewController () <NSFetchedResultsControllerDelegate, UINavigationControllerDelegate, RecipesTableViewCellDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (UIView *)viewWithImageName:(NSString *)imageName;
- (void)favoriteRecipeAction:(Recipe *)recipe;

@end


static NSString *reuseIdentifier = @"ReuseIdentifier";

@implementation RecipesTableViewController

- (void)reloadData {
    [GSProgressHUD show];
    
    _fetchedResultsController.fetchRequest.resultType = NSManagedObjectResultType;
    [_fetchedResultsController performFetch:nil];
    
    NSURLSessionTask *task = [Recipe allWithBlock:^(NSArray *recipes, NSError *error) {
        [GSProgressHUD dismiss];
        
        if (!error) {
            _fetchedResultsController.fetchRequest.resultType = NSManagedObjectResultType;
            [_fetchedResultsController performFetch:nil];
        }
    }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Recipes", nil);
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Recipe entityName]];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rid" ascending:YES selector:@selector(compare:)]];
    fetchRequest.returnsObjectsAsFaults = NO;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[(id)[[UIApplication sharedApplication] delegate] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:nil];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadData)];
    
    
    [self.tableView registerClass:[RecipesTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - self methods

- (void)favoriteRecipeAction:(Recipe *)recipe {
    
    recipe.favoriteValue = ![recipe favoriteValue];
    [GSProgressHUD popImage:[UIImage imageNamed:@"star"] withStatus:recipe.favoriteValue ? NSLocalizedString(@"Favorite", nil) : NSLocalizedString(@"NOT", nil)];
    
    NSURLSessionDataTask *task = [recipe updateWithBlock:^(BOOL updated, NSError *error) {
        if (!error) {
            [recipe save];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.defaultColor = [UIColor colorWithWhite:.95f alpha:1.f];
    
    // Configure the cell...
    Recipe *recipe = (Recipe *) [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.recipe = recipe;
    
    UIView *checkView = [self viewWithImageName:@"star"];
    UIColor *color = [UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0];
    if ([recipe favoriteValue]) {
        color = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    }

    [cell setSwipeGestureWithView:checkView color:color mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        [self favoriteRecipeAction:recipe];
    }];
    
    return cell;
}


#pragma mark -
#pragma mark - Table view delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Recipe *recipe = (Recipe *) [_fetchedResultsController objectAtIndexPath:indexPath];
    
    RecipeDetailViewController *rdvc = [[RecipeDetailViewController alloc] initWithStyle:UITableViewStylePlain];
    rdvc.recipe = recipe;
    
    [self.navigationController pushViewController:rdvc animated:YES];
    
}


#pragma mark -
#pragma mark - RecipesTableViewCellDelegate methods

- (void)didPressFavoriteButtonInCell:(RecipesTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Recipe *recipe = (Recipe *) [_fetchedResultsController objectAtIndexPath:indexPath];
    
    [self favoriteRecipeAction:recipe];
}


#pragma mark -
#pragma mark - UIViewController delegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        
    }
    
    return nil;
}


#pragma mark -
#pragma mark - NSFetchedResultsController delegate methods

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

@end
