//
//  TextViewTableViewCell.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 17/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "TextViewTableViewCell.h"
#import "Recipe.h"

@implementation TextViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 5.f, 300.f, 21.f)];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = [UIFont systemFontOfSize:12.f];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0.f, 21.f, 320.f, 84.f)];
        _textView.userInteractionEnabled = NO;
        _textView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_infoLabel];
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
//    self.contentView.layer.borderWidth = 0.f;
//    self.contentView.layer.borderColor = [UIColor colorWithRed:0.f green:0.478f blue:1.f alpha:0.f].CGColor;
    
//    self.contentView.backgroundColor = [UIColor clearColor];
//    
//    if (editing) {
//        [UIView animateKeyframesWithDuration:1.5
//                                       delay:0.0
//                                     options:UIViewKeyframeAnimationOptionAutoreverse|UIViewKeyframeAnimationOptionRepeat
//                                  animations:^{
////                                      self.contentView.layer.borderWidth = 5.f;
//                                      self.contentView.backgroundColor = [UIColor colorWithRed:0.f green:0.478f blue:1.f alpha:.25f];
//                                  } completion:nil];
//    }
}

@end
