//
//  RefreshTableView.h
//  YouGouApp
//
//  Created by iyan on 2017/6/27.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefreshTableViewDelegate <NSObject>
@optional
- (void)refreshHeaderLoading;
- (void)refreshFooterLoading;
@end

@interface RefreshTableView : UITableView
@property (nonatomic, weak) id<RefreshTableViewDelegate> refreshDelegate;
- (void)setTableHeaderRefresh;
- (void)setTableFooterRefresh;
@end
