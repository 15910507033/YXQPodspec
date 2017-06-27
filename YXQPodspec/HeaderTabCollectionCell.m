//
//  HeaderTabCollectionCell.m
//  YouGouApp
//
//  Created by iyan on 2017/6/27.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "HeaderTabCollectionCell.h"

@interface HeaderTabCollectionCell()
@property (nonatomic,weak) UIView *subView;
@end

@implementation HeaderTabCollectionCell

- (void)setSubVc:(UIViewController *)subVc{
    _subVc = subVc;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:subVc.view];
    subVc.view.frame = self.bounds;
}

@end
