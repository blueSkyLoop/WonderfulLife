//
//  MHMerchantOrderCellContentView.m
//  WonderfulLife
//
//  Created by zz on 24/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderCellContentView.h"
#import "Masonry.h"
#import "MHMacros.h"
#import "UIView+NIM.h"

@interface MHMerchantOrderCellContentView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UILabel *deleteLabel;

@property(nonatomic,assign)CGFloat lastOffset;
@property(nonatomic,strong)UIScrollView *scrollView;
@end


@implementation MHMerchantOrderCellContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layoutAllSubviews];
        [self addGestureRecognizerEvents];
    }
    return self;
}

- (void)layoutAllSubviews {

    _buttonView = [[UIView alloc]initWithFrame:self.bounds];
    _buttonView.backgroundColor = MColorRed;
    _buttonView.clipsToBounds = YES;
    [_buttonView addSubview:self.deleteLabel];
    [self.deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.buttonView);
        make.width.mas_equalTo(74);
    }];
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.goodsOrderTitle];
    [self.contentView addSubview:self.goodsOrderNumber];
    [self.contentView addSubview:self.goodsOrderExpiryDate];
    [self addSubview:self.buttonView];

    self.contentView.frame = CGRectMake(0, 0, MScreenW, 100);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.size.mas_equalTo(80);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.goodsOrderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsImageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(10);
        make.height.mas_greaterThanOrEqualTo(22);
    }];
    
    [self.goodsOrderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsOrderTitle);
        make.top.mas_equalTo(self.goodsOrderTitle.mas_bottom).mas_offset(4);
        make.right.mas_equalTo(-16);
        make.height.mas_greaterThanOrEqualTo(18);
    }];
    
    [self.goodsOrderExpiryDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsOrderTitle);
        make.top.mas_equalTo(self.goodsOrderNumber.mas_bottom).mas_offset(4);
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(-16);
    }];
    
    self.buttonView.frame = CGRectMake(MScreenW, 0, 0, 100);
}

- (void)addGestureRecognizerEvents {
    self.deleteTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDeleteEvents)];
    [self.buttonView addGestureRecognizer:self.deleteTap];

    self.contentViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewTap)];
    self.contentViewTap.cancelsTouchesInView = NO;
    [self.contentView addGestureRecognizer:self.contentViewTap];
}

#pragma mark - GestureEvents
- (void)tapDeleteEvents {
    if ([self.contentDelegate respondsToSelector:@selector(cellContentViewDidDeleteButtonView:)]) {
        [self.contentDelegate cellContentViewDidDeleteButtonView:self];
    }
}

- (void)scrollViewTap {
    if (!self.isCellStateRight) {
        if ([self.contentDelegate respondsToSelector:@selector(cellContentViewDidSelectedView:)]) {
            [self.contentDelegate cellContentViewDidSelectedView:self];
        }
    }else {
        [self hideDeleteButtonAnimated:YES];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(MScreenW + 74, 100);
    if (!self.scrollView.isTracking && !self.scrollView.isDecelerating) {
        self.scrollView.contentOffset = [self contentOffsetForCellStateRight:NO];
    }
    [self updateCellState];
}

- (CGPoint)contentOffsetForCellStateRight:(BOOL)state {
    CGPoint scrollPt = CGPointZero;
    if (state) {
        scrollPt.x = 74;
    }else{
        scrollPt.x = 0;
    }
    return scrollPt;
}

- (void)hideDeleteButtonAnimated:(BOOL)animated {
    if (self.isCellStateRight) {
        [self.scrollView setContentOffset:[self contentOffsetForCellStateRight:NO] animated:animated];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.x >= 0.5f) {
        self.cellStateRight = YES;
    }else if(velocity.x <= -0.5f){
        self.cellStateRight = NO;
    }else {
        CGFloat rightThreshold = 32;
        if (targetContentOffset->x > rightThreshold){
            self.cellStateRight = YES;
        }else{
            self.cellStateRight = NO;
        }
    }
    
//    if (self.cellStateRight) {
//        if ([self.contentDelegate respondsToSelector:@selector(cellContentViewShouldHideDeleteOnSwipe:)]) {
//            [self.contentDelegate cellContentViewShouldHideDeleteOnSwipe:self];
//        }
//    }
    
    *targetContentOffset = [self contentOffsetForCellStateRight:_cellStateRight];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x < 0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    [self updateCellState];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateCellState];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self updateCellState];
}

- (void)updateCellState{

    for (NSNumber *numState in @[
                                 @(YES),
                                 @(NO),
                                 ])
    {
        BOOL cellState = numState.integerValue;
        
        if (CGPointEqualToPoint(self.scrollView.contentOffset, [self contentOffsetForCellStateRight:cellState]))
        {
            _cellStateRight = cellState;
            break;
        }
    }
    
    CGRect frame = [self.contentView.superview convertRect:self.contentView.frame toView:self];
    frame.size.width = CGRectGetWidth(frame);

    CGFloat offset = MIN(0, CGRectGetMaxX(frame) - CGRectGetMaxX(self.scrollView.frame));
    self.buttonView.frame = CGRectMake(MScreenW + offset, 0, fabs(offset), 100);
    self.buttonView.hidden = MIN(0, CGRectGetMaxX(frame) - CGRectGetMaxX(self.scrollView.frame)) == 0;

    if (!self.scrollView.isDragging && !self.scrollView.isDecelerating) {
//        self.contentViewTap.enabled = YES;
    }else{
//        self.contentViewTap.enabled = NO;
    }
    
}

#pragma mark - Getter

- (UIView*)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = MColorToRGB(0XF9FAFC);
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (UIImageView*)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc]init];
        _goodsImageView.image = [UIImage imageNamed:@"ho_pay_aliPay"];
    }
    return _goodsImageView;
}

- (UILabel *)goodsOrderTitle {
    if (!_goodsOrderTitle) {
        _goodsOrderTitle = [UILabel new];
        _goodsOrderTitle.font = [UIFont systemFontOfSize:16.f];
        _goodsOrderTitle.textColor = MColorTitle;
        _goodsOrderTitle.numberOfLines = 2;
    }
    return _goodsOrderTitle;
}

- (UILabel *)goodsOrderNumber {
    if (!_goodsOrderNumber) {
        _goodsOrderNumber = [UILabel new];
        _goodsOrderNumber.font = [UIFont systemFontOfSize:13.f];
        _goodsOrderNumber.textColor = MColorToRGB(0X99A9BF);
        _goodsOrderNumber.numberOfLines = 1;
        
    }
    return _goodsOrderNumber;
}

- (UILabel *)goodsOrderExpiryDate {
    if (!_goodsOrderExpiryDate) {
        _goodsOrderExpiryDate = [UILabel new];
        _goodsOrderExpiryDate.font = [UIFont systemFontOfSize:13.f];
        _goodsOrderExpiryDate.textColor = MColorToRGB(0X99A9BF);
        _goodsOrderExpiryDate.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _goodsOrderExpiryDate;
}

- (UILabel *)deleteLabel {
    if (!_deleteLabel) {
        _deleteLabel = [UILabel new];
        _deleteLabel.textColor = [UIColor whiteColor];
        _deleteLabel.text = @"删除";
        _deleteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _deleteLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = MColorToRGB(0XF9FAFC);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}


@end
