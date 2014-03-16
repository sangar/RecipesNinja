//
//  RecipeDetailViewController.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 15/3/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface RecipeDetailViewController ()

@property(nonatomic, strong) NSArray *fields;

@end


static NSString * const ReuseIdentifier = @"ReuseIdentifier";

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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _fields = @[@"name", @"desc"];
    
    self.title = [_recipe name];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ReuseIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Table view delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"HeaderReuser"];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 10.f, 180.f, 180.f)];
    headerImageView.layer.cornerRadius = 90.f;
    headerImageView.layer.masksToBounds = YES;
    [headerImageView setImageWithURL:[NSURL URLWithString:[_recipe photoURL]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    headerImageView.center = CGPointMake(160.f, headerImageView.center.y);
    
    [headerView addSubview:headerImageView];
    
    return headerView;
}


#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_fields count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22.f];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [_recipe name];
            break;
        case 1:
            cell.textLabel.text = [_recipe recipeDescription];
            break;
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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


@end
