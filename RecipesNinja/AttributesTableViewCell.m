//
//  AttributesTableViewCell.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 17/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "AttributesTableViewCell.h"

@implementation AttributesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
