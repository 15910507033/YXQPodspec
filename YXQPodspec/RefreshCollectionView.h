//
//  RefreshCollectionView.h
//  YouGouApp
//
//  Created by iyan on 2017/7/12.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefreshCollectionViewDelegate <NSObject>
@optional
- (void)refreshHeaderLoading;
- (void)refreshFooterLoading;
@end

@interface RefreshCollectionView : UICollectionView

@property (nonatomic, weak) id<RefreshCollectionViewDelegate> refreshDelegate;
- (void)setCollectionHeaderRefresh;
- (void)setCollectionFooterRefresh;

@end
