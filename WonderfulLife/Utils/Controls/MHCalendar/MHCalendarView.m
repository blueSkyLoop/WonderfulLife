//
//  MHCalendarView.m
//  WonderfulLife
//
//  Created by zz on 10/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHCalendarView.h"
#import "MHYMCalendarCell.h"
#import "MHCollectionReusableView.h"

#import "MHCalendarCollectionViewFlowLayout.h"

#import "MHMacros.h"

#import "NSCalendar+MHCategory.h"

@interface MHCalendarView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *sectionRows;
@property (strong, nonatomic) NSMutableDictionary *gradientViewInfos;
@property (strong, nonatomic) NSDate *selectDate;
@property (strong, nonatomic) NSDate *resetToDate;
@property (assign, nonatomic) NSInteger rangeDays;
@property (assign, nonatomic) NSInteger months;
@property (assign, nonatomic) NSInteger itemWidth;
@end

@implementation MHCalendarView

- (void)clear {
    self.selectDate = nil;
    self.resetToDate = nil;
    [self.collectionView reloadData];
}

- (void)reloadResetData {

    if ([self.dataSource respondsToSelector:@selector(defaultResetToDate)]) {
        self.selectDate = [self.dataSource defaultResetToDate];
        [self resetSelectDateAnimated:YES];
        
        // delegate
        if ([self.delegate respondsToSelector:@selector(selectNSStringFromDate:)]) {
            NSDateFormatter *selectFormatter = [[NSDateFormatter alloc] init];
            selectFormatter.dateFormat = self.formatString;
            NSString *cacheDate = [selectFormatter stringFromDate:self.selectDate];
            [self.delegate selectNSStringFromDate:cacheDate];
        }
        else if ([self.delegate respondsToSelector:@selector(selectNSDateFromDate:)]) {
            [self.delegate selectNSDateFromDate:self.selectDate];
        }
    }
    
    self.itemWidth = 30;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.months;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sectionRows[section] integerValue];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MHYMCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kMHYMCalendarCell" forIndexPath:indexPath];
    cell.isCurrentDate = NO;
    // 依照 section index 计算日期
    NSDate *fromDate = [self.dataSource minimumDateForCalendar];
    NSDate *sectionDate = [NSCalendar date:fromDate addMonth:indexPath.section];
    // 包含前一个月天数
    NSInteger containPreDays = [NSCalendar weekFromMonthFirstDate:sectionDate];
    
    {
        NSInteger shiftIndex = indexPath.row;
        if (shiftIndex >= containPreDays) {
            shiftIndex -= containPreDays;
            cell.titileLabel.text = [NSString stringWithFormat:@"%td", shiftIndex + 1];
            
            NSDate *yyMMDDDate = [self dateYYMMConvertToYYMMDD:sectionDate withDay:shiftIndex + 1];
            if ([yyMMDDDate compare:fromDate] == NSOrderedAscending) {
                cell.titileLabel.textColor = [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:0.3];
            }
            else {
                cell.titileLabel.textColor = MColorToRGB(0X324057);
            }
            
            NSDateFormatter *currentDateFormat = [[NSDateFormatter alloc] init];
            currentDateFormat.dateFormat = self.formatString;
            NSString *currentDateString = [currentDateFormat stringFromDate:self.selectDate];
            
            if ([yyMMDDDate compare:[currentDateFormat dateFromString:currentDateString]] == NSOrderedSame) {
                cell.isCurrentDate = YES;
            }
        }
        else {
            // 前一个月份
            cell.titileLabel.text = @"";
            cell.titileLabel.textColor = MColorToRGB(0X324057);
        }
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSDate *fromDate = [self.dataSource minimumDateForCalendar];
        
        // 计算开始日期加上 x 数字后的日期
        NSDate *sectionDate = [NSCalendar date:fromDate addMonth:indexPath.section];
        
        // 转日期格式 yyyy年MM月
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy年MM月";
        NSString *dateString = [dateFormatter stringFromDate:sectionDate];
        MHCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MHCollectionReusableView" forIndexPath:indexPath];
        headerView.dateLabel.text = dateString;
        return headerView;
    }
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionFooterView" forIndexPath:indexPath];
        return footerview;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 依照 section index 计算日期
    NSDate *fromDate = [self.dataSource minimumDateForCalendar];
    NSDate *sectionDate = [NSCalendar date:fromDate addMonth:indexPath.section];
    
    // 包含前一个月天数
    NSInteger containPreDays = [NSCalendar weekFromMonthFirstDate:sectionDate];
    
    NSInteger shiftIndex = indexPath.row;
    // 项目 一、二 ... 日以外的点击
    if (shiftIndex >= containPreDays) {
        shiftIndex -= containPreDays;
        
        // 判断是否点超过当天日期
        if (indexPath.section == self.sectionRows.count - 1) {
            NSDate *toDate = [self.dataSource maximumDateForCalendar];
            NSInteger day = [NSCalendar dayFromDate:toDate];
            
            // 超过最大日期的日数
            if (shiftIndex + 1 > day) {
                return;
            }
        }
        
        NSDate *yyMMDDDate = [self dateYYMMConvertToYYMMDD:sectionDate withDay:shiftIndex + 1];
        NSDate *yyMMDDFromDate = [self dateFormatter:fromDate];
        if ([yyMMDDDate compare:yyMMDDFromDate] == NSOrderedAscending) {
            return;
        }
    
        self.selectDate = yyMMDDDate;
        
        // delegate
        if ([self.delegate respondsToSelector:@selector(selectNSStringFromDate:)]) {
            NSDateFormatter *selectFormatter = [[NSDateFormatter alloc] init];
            selectFormatter.dateFormat = self.formatString;
            NSString *cacheDate = [selectFormatter stringFromDate:self.selectDate];
            [self.delegate selectNSStringFromDate:cacheDate];
        }
        else if ([self.delegate respondsToSelector:@selector(selectNSDateFromDate:)]) {
            [self.delegate selectNSDateFromDate:self.selectDate];
        }
        
        [self.collectionView reloadData];
    }
    

}

- (void)setupCollectionViews {
    CGFloat calendarViewWidth = CGRectGetWidth(self.frame);
    CGFloat calendarViewHeight = CGRectGetHeight(self.frame);
    CGRect collectionViewFrame = CGRectMake(0, 0, calendarViewWidth, calendarViewHeight);
    
    CGFloat items = 7;              // 一、二 ... 日
    CGFloat itemWidth = self.itemWidth;         // 项目宽
    CGFloat interitem = items + 1;  // 项目间距数量
    CGFloat collectionViewWidth = CGRectGetWidth(collectionViewFrame);
    CGFloat space = (collectionViewWidth - (items * itemWidth)) / interitem;
    CGFloat headerWidth = calendarViewWidth;
    
    MHCalendarCollectionViewFlowLayout *flowLayout = [[MHCalendarCollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 12;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.headerReferenceSize = CGSizeMake(headerWidth, 72);
    flowLayout.footerReferenceSize = CGSizeMake(headerWidth, 16);

    flowLayout.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionRows = self.sectionRows;
    flowLayout.itemWidth = self.itemWidth;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MHYMCalendarCell class] forCellWithReuseIdentifier:@"kMHYMCalendarCell"];
    [self.collectionView registerClass:[MHCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MHCollectionReusableView"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionFooterView"];
    
    [self addSubview:self.collectionView];
}

- (void)resetSelectDateAnimated:(BOOL)flag {
    //移动到当天月份
    NSDate *fromDate = [self.dataSource minimumDateForCalendar];
    NSInteger currentDate = [NSCalendar monthsFromDate:fromDate toDate:self.selectDate];
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:currentDate - 2];
    UICollectionViewLayoutAttributes* attr = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    UIEdgeInsets insets = self.collectionView.scrollIndicatorInsets;
    
    CGRect rect = attr.frame;
    rect.size = self.collectionView.frame.size;
    rect.size.height -= insets.top + insets.bottom;
    CGFloat offset = (rect.origin.y + rect.size.height) - self.collectionView.contentSize.height;
    if ( offset > 0.0 ) rect = CGRectOffset(rect, 0, -offset);
    
    [self.collectionView scrollRectToVisible:rect animated:flag];
    
}



- (void)setupInitValues {
    if ([self.dataSource respondsToSelector:@selector(defaultSelectDate)]) {
        self.selectDate = [self.dataSource defaultSelectDate];
    }
    
    if ([self.dataSource respondsToSelector:@selector(defaultResetToDate)]) {
        self.resetToDate = [self.dataSource defaultResetToDate];
    }
    
    self.itemWidth = MScreenW / 7.f;
    
    self.gradientViewInfos = [[NSMutableDictionary alloc] init];
    
    // 计算有几个月份
    NSDate *fromDate = [self.dataSource minimumDateForCalendar];
    NSDate *toDate = [self.dataSource maximumDateForCalendar];
    self.months = [NSCalendar monthsFromDate:fromDate toDate:toDate];
    
    // 计算月份天数
    self.sectionRows = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < self.months; index++) {
        // 依照 section index 计算日期
        NSDate *fromDate = [self.dataSource minimumDateForCalendar];
        NSDate *sectionDate = [NSCalendar date:fromDate addMonth:index];
        
        // 当月天数
        NSInteger days = [NSCalendar daysFromDate:sectionDate];
        
        // 包含前一个月天数
        NSInteger containPreDays = [NSCalendar weekFromMonthFirstDate:sectionDate];
        
        // 包含前一个月天数
        NSInteger weekItems = 0;
        
        [self.sectionRows addObject:@(weekItems + containPreDays + days)];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview) {
        [self setupInitValues];
        [self setupCollectionViews];
    }
}

- (NSDate *)dateYYMMConvertToYYMMDD:(NSDate *)date withDay:(NSInteger)day {
    // 转日期格式 yyyy年MM月 to yyyy年MM月DD日
    NSDateFormatter *yyMMDateFormatter = [[NSDateFormatter alloc] init];
    yyMMDateFormatter.dateFormat = @"yyyy年MM月";
    NSString *yyMMString = [yyMMDateFormatter stringFromDate:date];
    NSString *yyMMDDString = [NSString stringWithFormat:@"%@%02ld日", yyMMString, day];
    
    NSDateFormatter *yyMMDDDateFormatter = [[NSDateFormatter alloc] init];
    yyMMDDDateFormatter.dateFormat = @"yyyy年MM月dd日";
    return [yyMMDDDateFormatter dateFromString:yyMMDDString];
}

- (NSDate *)dateFormatter:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString *dateString = [dateFormatter stringFromDate:date];
    return [dateFormatter dateFromString:dateString];
}

- (NSString *)formatString {
    if (_formatString.length == 0) {
        _formatString = @"yyyy-MM-dd";
    }
    return _formatString;
}
@end
