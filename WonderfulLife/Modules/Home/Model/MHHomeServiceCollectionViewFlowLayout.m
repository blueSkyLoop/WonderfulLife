//
//  MHHomeServiceCollectionViewFlowLayout.m
//  WonderfulLife
//
//  Created by Lucas on 17/8/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeServiceCollectionViewFlowLayout.h"
#import "MHMacros.h"
@implementation MHHomeServiceCollectionViewFlowLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(MScreenW/4, 114);
        
        // 1.设置列间距
        self.minimumInteritemSpacing = 0;
        
        // 2.设置行间距
        self.minimumLineSpacing = -1;
        
        // 4.设置Item的估计大小,用于动态设置item的大小，结合自动布局（self-sizing-cell）  设置之后会出问题
//        self.estimatedItemSize = CGSizeMake(MScreenW, 114);
        
        // 6.设置头视图尺寸大小
        self.headerReferenceSize = CGSizeMake(MScreenW, 56);
        // 7.设置尾视图尺寸大小
        self.footerReferenceSize = CGSizeMake(50, 50);
        // 8.设置分区(组)的EdgeInset（四边距）
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.scrollDirection = UICollectionViewScrollDirectionVertical ;
    }
    return self;
}


-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for(int i = 1; i < [attributes count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        //我们想设置的最大间距，可根据需要改
        NSInteger maximumSpacing = 0;
        //前一个cell的最右边
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return attributes;
}
@end
