//
//  RefreshTableView.m
//  YouGouApp
//
//  Created by iyan on 2017/6/27.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "RefreshTableView.h"
#import "RefreshGifHeader.h"

@implementation RefreshTableView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableFooterView = view;
    }
    return self;
}

//添加头部刷新
- (void)setTableHeaderRefresh {
    if(self.mj_header == nil) {
        RefreshGifHeader *header = [RefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        self.mj_header = header;
    }
}

//头部刷新
- (void)reloadNewData {
    if([self.refreshDelegate respondsToSelector:@selector(refreshHeaderLoading)]) {
        [self.refreshDelegate refreshHeaderLoading];
    }
}

//添加底部刷新
- (void)setTableFooterRefresh {
    if(self.mj_footer == nil) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [footer setTitle:@"点击刷新 查看更多内容" forState:MJRefreshStateIdle];
        [footer setTitle:@"正在载入..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
        self.mj_footer = footer;
    }
}

//底部刷新
- (void)loadMoreData {
    if([self.refreshDelegate respondsToSelector:@selector(refreshFooterLoading)]) {
        [self.refreshDelegate refreshFooterLoading];
    }
}

@end
