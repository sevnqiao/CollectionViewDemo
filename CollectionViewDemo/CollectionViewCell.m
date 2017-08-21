//
//  CollectionViewCell.m
//  CollectionViewDemo
//
//  Created by xiong on 2017/7/27.
//  Copyright © 2017年 xiong. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (copy, nonatomic) void(^handleBlock)(NSIndexPath *indexPath);

@end

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.label.layer.borderWidth = 1;
    self.label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.clipsToBounds = NO;

}

- (void)cellWithTitle:(NSString *)title
{
    self.label.text = title;

}


@end
