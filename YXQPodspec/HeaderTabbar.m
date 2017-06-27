//
//  HeaderTabbar.m
//  YouGouApp
//
//  Created by iyan on 2017/6/27.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "HeaderTabbar.h"
#import "HeaderTabCollectionCell.h"
#import "AppCommonMacro.h"
#import "UIColor+Hex.h"

static CGFloat const topBarItemMargin = 35; //标题之间的间距

@interface HeaderTabbar ()
<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,assign) CGFloat    tabbarWidth;     //顶部标签条的宽度
@property (nonatomic,assign) NSInteger  selectedIndex;
@property (nonatomic,assign) NSInteger  preSelectedIndex;
@property (nonatomic,strong) NSMutableArray *titles;
@property (nonatomic,strong) UIView         *keyline;
@property (nonatomic,weak) UIScrollView     *tabbar;  //头部标题容器
@property (nonatomic,weak) UICollectionView *contentView;   //内容区
@end

@implementation HeaderTabbar

#pragma mark - 重写构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _selectedIndex = 0;
        _preSelectedIndex = 0;
        _tabbarWidth = topBarItemMargin;
        self.backgroundColor = [UIColor whiteColor];
        [self setUpSubview];
    }
    return self;
}

//UI处理:添加控件
- (void)setUpSubview {
    UIScrollView * tabbar = [[UIScrollView alloc]init];
    [self addSubview:tabbar];
    self.tabbar = tabbar;
    tabbar.showsHorizontalScrollIndicator = NO;
    tabbar.showsVerticalScrollIndicator = NO;
    _tabbar.backgroundColor = [UIColor whiteColor];
    tabbar.bounces = NO;
    
    self.keyline = [[UIView alloc] init];
    self.keyline.backgroundColor = [UIColor hexColor:@"#ececec"];
    [self addSubview:self.keyline];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置layout 属性
    layout.itemSize = (CGSize){self.bounds.size.width,(self.bounds.size.height - TOPBAR_H)};
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    UICollectionView * contentView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self addSubview:contentView];
    
    self.contentView = contentView;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.pagingEnabled = YES;
    contentView.bounces = NO;
    
    contentView.dataSource = self;
    contentView.delegate = self;
    
    //注册cell
    [contentView registerClass:[HeaderTabCollectionCell class] forCellWithReuseIdentifier:@"HeaderTabCollectionCell"];
}

//UI处理:布局控件
- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    BOOL needFilling = NO;
    CGFloat btnX = topBarItemMargin;
    self.tabbar.frame = CGRectMake(0, 0, rect.size.width, TOPBAR_H);
    self.keyline.frame = CGRectMake(0, TOPBAR_H-PX(1), rect.size.width, PX(1));
    if(_tabbarWidth < rect.size.width) {
        _tabbarWidth = rect.size.width;
        btnX = 0;
        needFilling = YES;
    }
    self.tabbar.contentSize = CGSizeMake(_tabbarWidth, 0);
    self.contentView.frame = CGRectMake(0, CGRectGetMaxY(self.tabbar.frame), rect.size.width,(self.bounds.size.height - TOPBAR_H));
    CGFloat btnH = TOPBAR_H;
    for (int i = 0 ; i < self.titles.count; i++) {
        UIButton * btn = self.tabbar.subviews[i];
        if(needFilling) {
            btn.frame = CGRectMake(btnX, 0, rect.size.width/self.subViewControllers.count, btnH);
            btnX += rect.size.width/self.subViewControllers.count;
        }else {
            btn.frame = CGRectMake(btnX, 0, btn.frame.size.width, btnH);
            btnX += btn.frame.size.width + topBarItemMargin;
        }
        [btn addBottomLineWithFontSize:_titleSelectedFontSize Color:_titleSelectedColor];
    }
    [self itemSelectedIndex:0];
}

#pragma mark - Private方法
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        //设置按钮选中
        [self itemSelectedIndex:self.selectedIndex];
    }
}

//外界传个控制器,添加一个栏目
- (void)addSubItemWithViewController:(UIViewController *)viewController{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tabbar addSubview:btn];
    [self.titles addObject:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:_titleSelectedFontSize];
    
    [btn setTitle:viewController.title forState:UIControlStateNormal];
    [btn sizeToFit];
    _tabbarWidth += btn.frame.size.width + topBarItemMargin;
    btn.titleLabel.font = [UIFont systemFontOfSize:_titleNormalFontSize];
    [btn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
    [btn setTitleColor:_titleSelectedColor forState:UIControlStateSelected];
    
    [btn addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.subViewControllers addObject:viewController];
}

- (void)itemSelected:(UIButton *)btn{
    NSInteger index = [self.titles indexOfObject:btn];
    [self itemSelectedIndex:index];
    self.selectedIndex = index;
    self.contentView.contentOffset = CGPointMake(index * self.bounds.size.width, 0);
}





- (void)itemSelectedIndex:(NSInteger)index{
    UIButton * preSelectedBtn = self.titles[_preSelectedIndex];
    preSelectedBtn.selected = NO;
    _selectedIndex = index;
    _preSelectedIndex = _selectedIndex;
    UIButton * selectedBtn = self.titles[index];
    selectedBtn.selected = YES;
    [UIView animateWithDuration:0.25 animations:^{
        preSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:_titleNormalFontSize];
        selectedBtn.titleLabel.font = [UIFont systemFontOfSize:_titleSelectedFontSize];
        [preSelectedBtn hideBottomLine];
        [selectedBtn showBottomLine];
        UIButton * btn = self.titles[self.selectedIndex];
        // 计算偏移量
        CGFloat offsetX = btn.center.x - SCREEN_W * 0.5;
        if (offsetX < 0) offsetX = 0;
        // 获取最大滚动范围
        CGFloat maxOffsetX = self.tabbar.contentSize.width - SCREEN_W;
        if (offsetX > maxOffsetX) offsetX = maxOffsetX;
        // 滚动标题滚动条
        [self.tabbar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }];
    //加载数据
    if([self.delegate respondsToSelector:@selector(loadDataWithIndex:)]) {
        [self.delegate loadDataWithIndex:index];
    }
}



#pragma mark - 懒加载
- (NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableArray *)subViewControllers{
    if (!_subViewControllers) {
        _subViewControllers = [NSMutableArray array];
    }
    return _subViewControllers;
}

#pragma mark - 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.subViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HeaderTabCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeaderTabCollectionCell" forIndexPath:indexPath];
    cell.subVc = self.subViewControllers[indexPath.row] ;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.selectedIndex != (scrollView.contentOffset.x + SCREEN_W * 0.5) / SCREEN_W){
        self.selectedIndex = (scrollView.contentOffset.x + SCREEN_W * 0.5) / SCREEN_W;
    }
}

@end




@implementation UIButton (HeaderTabbar)
- (void)addBottomLineWithFontSize:(CGFloat)fontSize Color:(UIColor *)lineColor {
    CGFloat lineW = self.titleLabel.text.length*fontSize;
    if(lineW > self.frame.size.width)
        lineW = self.frame.size.width;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-lineW)/2, self.frame.size.height-2, lineW, 2)];
    bottomLine.tag = 10;
    bottomLine.backgroundColor = lineColor;
    [self addSubview:bottomLine];
    bottomLine.hidden = YES;
    
}
- (void)hideBottomLine {
    UIView *line = [self viewWithTag:10];
    line.hidden = YES;
}
- (void)showBottomLine {
    UIView *line = [self viewWithTag:10];
    line.hidden = NO;
}
@end
