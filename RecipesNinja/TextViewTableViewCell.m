//
//  TextViewTableViewCell.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 17/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "TextViewTableViewCell.h"

@implementation TextViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 5.f, 320.f, 21.f)];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = [UIFont systemFontOfSize:12.f];
        
        self.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:22.f];
        
        [self.contentView addSubview:_infoLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
