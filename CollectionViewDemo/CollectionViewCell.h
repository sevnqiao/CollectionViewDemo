//
//  CollectionViewCell.h
//  CollectionViewDemo
//
//  Created by xiong on 2017/7/27.
//  Copyright © 2017年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
- (void)cellWithTitle:(NSString *)title;
@end
