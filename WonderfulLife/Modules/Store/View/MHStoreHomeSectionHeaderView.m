//
//  MHStoreHomeSectionHeaderView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreHomeSectionHeaderView.h"
#import "MHMacros.h"

@interface MHStoreHomeSectionHeaderView ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *hideViews;

@end

@implementation MHStoreHomeSectionHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    if (iOS8) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        self.backgroundView = view;
    }
}

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setHideMore:(BOOL)hideMore{
    _hideMore = hideMore;
    [self.hideViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = hideMore;
    }];
}

#pragma mark - 按钮点击

- (IBAction)buttonDidClick {
    if ([self.delegate respondsToSelector:@selector(checkMoreRecommandWithTag:)]) {
        [self.delegate checkMoreRecommandWithTag:self.tag];
    }
}
#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end


@interface MHStoreHomeSectionFooterView ()

@end

@implementation MHStoreHomeSectionFooterView

#pragma mark - override
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = MColorBackgroud;
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end






