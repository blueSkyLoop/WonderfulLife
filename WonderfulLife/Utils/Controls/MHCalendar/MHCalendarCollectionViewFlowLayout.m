//
//  MHCalendarCollectionViewFlowLayout.m
//  WonderfulLife
//
//  Created by zz on 12/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHCalendarCollectionViewFlowLayout.h"

@interface MHCalendarCollectionViewFlowLayout ()
@property (assign, nonatomic) CGFloat height;
@end

@implementation MHCalendarCollectionViewFlowLayout
#pragma mark * caculate

- (void)caculateContentSizeHeight {
    NSInteger rowCount = 0;
    NSInteger lineSpacingCount = 0;
    for (NSNumber *rows in self.sectionRows) {
        rowCount += ceil(rows.floatValue / 7.0);
        lineSpacingCount += ceil(rows.floatValue / 7.0) - 1;
    }
    
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    self.height = (rowCount * self.itemWidth) + (numberOfSections * 50) + (self.minimumLineSpacing * lineSpacingCount);
}

#pragma mark - override

- (void)setSectionInset:(UIEdgeInsets)sectionInset {
    [super setSectionInset:sectionInset];
    self.minimumInteritemSpacing = sectionInset.left;
}

- (CGSize)collectionViewContentSize {
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);
    return CGSizeMake(collectionViewWidth, self.height);
}

- (void)prepareLayout {
    [super prepareLayout];
    [self caculateContentSizeHeight];
}

@end
