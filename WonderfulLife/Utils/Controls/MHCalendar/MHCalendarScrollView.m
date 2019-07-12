//
//  MHCalendarScrollView.m
//  calendarDemo
//
//  Created by zz on 04/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHCalendarScrollView.h"
#import "MHCalendarCell.h"
#import "MHCalendarMonth.h"

#import "MHMacros.h"
#import "NSDate+MHCalendar.h"

@interface MHCalendarScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionViewT;
@property (nonatomic, strong) UICollectionView *collectionViewM;
@property (nonatomic, strong) UICollectionView *collectionViewB;

@property (nonatomic, strong) NSDate *currentMonthDate;
@property (nonatomic, strong) NSMutableArray *monthArray;

@property (nonatomic, assign) NSInteger selectedYear;
@property (nonatomic, assign) NSInteger selectedMonth;
@property (nonatomic, assign) NSInteger selectedDay;
@end

@implementation MHCalendarScrollView

static NSString *const kMHCalendarCellIdentifier = @"kMHCalendarCellIdentifier";

#pragma mark - Initialiaztion

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.delegate = self;
        
        self.contentSize = CGSizeMake(self.bounds.size.width, 3 * self.bounds.size.height);
        [self setContentOffset:CGPointMake(0.0, self.bounds.size.height) animated:NO];
        
        _currentMonthDate = [NSDate date];
        [self setupCollectionViews];
        
    }
    
    return self;
    
}

- (void)setupCollectionViews {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.bounds.size.width / 7.0, self.bounds.size.width / 7.0 * 0.85);
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    _collectionViewT = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, selfWidth, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewT.dataSource = self;
    _collectionViewT.delegate = self;
    _collectionViewT.backgroundColor = [UIColor whiteColor];
    [_collectionViewT registerClass:[MHCalendarCell class] forCellWithReuseIdentifier:kMHCalendarCellIdentifier];
    [self addSubview:_collectionViewT];
    
    _collectionViewM = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, selfHeight, selfWidth, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewM.dataSource = self;
    _collectionViewM.delegate = self;
    _collectionViewM.backgroundColor = [UIColor whiteColor];
    [_collectionViewM registerClass:[MHCalendarCell class] forCellWithReuseIdentifier:kMHCalendarCellIdentifier];
    [self addSubview:_collectionViewM];
    
    _collectionViewB = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 2*selfHeight, selfWidth, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewB.dataSource = self;
    _collectionViewB.delegate = self;
    _collectionViewB.backgroundColor = [UIColor whiteColor];
    [_collectionViewB registerClass:[MHCalendarCell class] forCellWithReuseIdentifier:kMHCalendarCellIdentifier];
    [self addSubview:_collectionViewB];
    
}


- (NSNumber *)previousMonthDaysForPreviousDate:(NSDate *)date {
    return [[NSNumber alloc] initWithInteger:[[date previousMonthDate] totalDaysInMonth]];
}

- (void)notifyToChangeCalendarHeader {
    MHCalendarMonth *currentMonthInfo = self.monthArray[1];
    NSString *dayMonth = [NSString stringWithFormat:@"%ld年%ld月",currentMonthInfo.year,currentMonthInfo.month];
    !self.willDisplayDateHandler?:self.willDisplayDateHandler(dayMonth);
}

- (void)refreshTodayToCurrentMonth {
    
    // 如果现在就在当前月份，则不执行操作
    MHCalendarMonth *currentMonthInfo = self.monthArray[1];
    if ((currentMonthInfo.month == [[NSDate date] dateMonth]) && (currentMonthInfo.year == [[NSDate date] dateYear]) && !_resetDate) {
        self.selectedYear  = currentMonthInfo.year;
        self.selectedMonth = currentMonthInfo.month;
        self.selectedDay   = [[NSDate date] dateDay];
        _currentMonthDate  = [NSDate date];
        [_collectionViewM reloadData];
        
        !self.willDisplayDateHandler?:self.willDisplayDateHandler([_currentMonthDate yearAndMonthFromDate]);
        !self.didSelectDayHandler?:self.didSelectDayHandler(_currentMonthDate);
        return;
    }
    
    _currentMonthDate = [NSDate date];
    
    if (_resetDate) {
        _currentMonthDate = _resetDate;
    }
    
    NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
    NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
    
    [self.monthArray removeAllObjects];
    [self.monthArray addObject:[[MHCalendarMonth alloc] initWithDate:previousMonthDate]];
    [self.monthArray addObject:[[MHCalendarMonth alloc] initWithDate:_currentMonthDate]];
    [self.monthArray addObject:[[MHCalendarMonth alloc] initWithDate:nextMonthDate]];
    [self.monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]];
    
    MHCalendarMonth *reloadMonthInfo = self.monthArray[1];
    self.selectedYear = reloadMonthInfo.year;
    self.selectedMonth = reloadMonthInfo.month;
    self.selectedDay = [[NSDate date] dateDay];
    
    if (_resetDate) {
        self.selectedDay = [_resetDate dateDay];
    }
    
    !self.willDisplayDateHandler?:self.willDisplayDateHandler([_currentMonthDate yearAndMonthFromDate]);
    !self.didSelectDayHandler?:self.didSelectDayHandler(_currentMonthDate);
    // 刷新数据
    [_collectionViewM reloadData];
    [_collectionViewT reloadData];
    [_collectionViewB reloadData];
    
}

- (void)refreshToCurrentMonth {
    
    // 如果现在就在当前月份，则不执行操作
    MHCalendarMonth *currentMonthInfo = self.monthArray[1];
    if ((currentMonthInfo.month == [[NSDate date] dateMonth]) && (currentMonthInfo.year == [[NSDate date] dateYear]) && !_inputDate) {
        self.selectedYear = currentMonthInfo.year;
        self.selectedMonth = currentMonthInfo.month;
        self.selectedDay = [[NSDate date] dateDay];
        [_collectionViewM reloadData];

        !self.willDisplayDateHandler?:self.willDisplayDateHandler([_currentMonthDate yearAndMonthFromDate]);
        !self.didSelectDayHandler?:self.didSelectDayHandler(_currentMonthDate);
        return;
    }

    _currentMonthDate = [NSDate date];
    
    if (_inputDate) {
        _currentMonthDate = _inputDate;
    }
    
    NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
    NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
    
    [self.monthArray removeAllObjects];
    [self.monthArray addObject:[[MHCalendarMonth alloc] initWithDate:previousMonthDate]];
    [self.monthArray addObject:[[MHCalendarMonth alloc] initWithDate:_currentMonthDate]];
    [self.monthArray addObject:[[MHCalendarMonth alloc] initWithDate:nextMonthDate]];
    [self.monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]];
    
    MHCalendarMonth *reloadMonthInfo = self.monthArray[1];
    self.selectedYear = reloadMonthInfo.year;
    self.selectedMonth = reloadMonthInfo.month;
    self.selectedDay = [[NSDate date] dateDay];
    
    if (_inputDate) {
        self.selectedDay = [_inputDate dateDay];
    }
    
    !self.willDisplayDateHandler?:self.willDisplayDateHandler([_currentMonthDate yearAndMonthFromDate]);
    !self.didSelectDayHandler?:self.didSelectDayHandler(_currentMonthDate);
    // 刷新数据
    [_collectionViewM reloadData];
    [_collectionViewT reloadData];
    [_collectionViewB reloadData];
    
}

#pragma mark - UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42; // 7 * 6
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MHCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMHCalendarCellIdentifier forIndexPath:indexPath];
    
    if (collectionView == _collectionViewT) {
        
        MHCalendarMonth *monthInfo = self.monthArray[0];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            cell.titileLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday + 1];
            cell.titileLabel.textColor = self.dateTextColor;

            if ((monthInfo.month == self.selectedMonth) && (monthInfo.year == self.selectedYear) && ((indexPath.row - firstWeekday + 1) == self.selectedDay)) {
                [cell configureAppearance];
                cell.titileLabel.textColor = [UIColor whiteColor];
            }else {
                cell.shapeLayer.opaque = 0;
            }
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            cell.titileLabel.text = @"";
            cell.titileLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.shapeLayer.opaque = 0;
            
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.titileLabel.text = @"";
            cell.titileLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.shapeLayer.opaque = 0;
        }
        
        cell.userInteractionEnabled = NO;
        
    }
    else if (collectionView == _collectionViewM) {
        
        MHCalendarMonth *monthInfo = self.monthArray[1];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            cell.titileLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday + 1];
            cell.titileLabel.textColor = self.dateTextColor;
            cell.userInteractionEnabled = YES;
            
            if ((monthInfo.month == self.selectedMonth) && (monthInfo.year == self.selectedYear) && ((indexPath.row - firstWeekday + 1) == self.selectedDay)) {
                [cell configureAppearance];
                cell.titileLabel.textColor = [UIColor whiteColor];
            }else {
                cell.shapeLayer.opaque = 0;
            }
            
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            cell.titileLabel.text = @"";
            cell.titileLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.shapeLayer.opaque = 0;
            cell.userInteractionEnabled = NO;
            
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.titileLabel.text = @"";
            
            cell.titileLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.shapeLayer.opaque = 0;
            cell.userInteractionEnabled = NO;
        }
        
    }
    else if (collectionView == _collectionViewB) {
        
        MHCalendarMonth *monthInfo = self.monthArray[2];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            
            cell.titileLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday + 1];
            cell.titileLabel.textColor = self.dateTextColor;
            
            if ((monthInfo.month == self.selectedMonth) && (monthInfo.year == self.selectedYear) && ((indexPath.row - firstWeekday + 1) == self.selectedDay)) {
                [cell configureAppearance];
                cell.titileLabel.textColor = [UIColor whiteColor];
            }else {
                cell.shapeLayer.opaque = 0;
            }
            
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            cell.titileLabel.text = @"";
            cell.titileLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.shapeLayer.opaque = 0;
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.titileLabel.text = @"";
            cell.titileLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            cell.shapeLayer.opaque = 0;
        }
        
        cell.userInteractionEnabled = NO;
        
    }
    
    return cell;
    
}

#pragma mark - UICollectionViewDeleagate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.didSelectDayHandler != nil) {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:_currentMonthDate];
        NSDate *currentDate = [calendar dateFromComponents:components];
        
        MHCalendarCell *cell = (MHCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        self.selectedYear  = [currentDate dateYear];
        self.selectedMonth = [currentDate dateMonth];
        self.selectedDay   = [cell.titileLabel.text integerValue];
        
        NSString *didSelectedDay = [NSString stringWithFormat:@"%ld-%02ld-%02ld 00:00",self.selectedYear,self.selectedMonth,self.selectedDay];
        // 执行回调
        !self.didSelectDayHandler?:self.didSelectDayHandler([NSDate dateFromString:didSelectedDay]);
        [self.didSelectedSubject sendNext:nil];
        // 刷新数据
        [_collectionViewM reloadData];
        [_collectionViewT reloadData];
        [_collectionViewB reloadData];
    }
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self) {
        return;
    }
    
    // 向右滑动
    if (scrollView.contentOffset.y < 0.5 * self.bounds.size.height) {
        
        _currentMonthDate = [_currentMonthDate previousMonthDate];
        NSDate *previousDate = [_currentMonthDate previousMonthDate];
        
        // 数组中最左边的月份现在作为中间的月份，中间的作为右边的月份，新的左边的需要重新获取
        MHCalendarMonth *currentMothInfo = self.monthArray[0];
        MHCalendarMonth *nextMonthInfo = self.monthArray[1];
        
        
        MHCalendarMonth *olderNextMonthInfo = self.monthArray[2];
        
        // 复用 MHCalendarMonth 对象
        olderNextMonthInfo.totalDays = [previousDate totalDaysInMonth];
        olderNextMonthInfo.firstWeekday = [previousDate firstWeekDayInMonth];
        olderNextMonthInfo.year = [previousDate dateYear];
        olderNextMonthInfo.month = [previousDate dateMonth];
        MHCalendarMonth *previousMonthInfo = olderNextMonthInfo;
        
        NSNumber *prePreviousMonthDays = [self previousMonthDaysForPreviousDate:[_currentMonthDate previousMonthDate]];
        
        [self.monthArray removeAllObjects];
        [self.monthArray addObject:previousMonthInfo];
        [self.monthArray addObject:currentMothInfo];
        [self.monthArray addObject:nextMonthInfo];
        [self.monthArray addObject:prePreviousMonthDays];
        
    }
    // 向左滑动
    else if (scrollView.contentOffset.y > 1.5 * self.bounds.size.height) {
        
        _currentMonthDate = [_currentMonthDate nextMonthDate];
        NSDate *nextDate = [_currentMonthDate nextMonthDate];
        
        // 数组中最右边的月份现在作为中间的月份，中间的作为左边的月份，新的右边的需要重新获取
        MHCalendarMonth *previousMonthInfo = self.monthArray[1];
        MHCalendarMonth *currentMothInfo = self.monthArray[2];
        
        
        MHCalendarMonth *olderPreviousMonthInfo = self.monthArray[0];
        
        NSNumber *prePreviousMonthDays = [[NSNumber alloc] initWithInteger:olderPreviousMonthInfo.totalDays]; // 先保存 olderPreviousMonthInfo 的月天数
        
        // 复用 MHCalendarMonth 对象
        olderPreviousMonthInfo.totalDays = [nextDate totalDaysInMonth];
        olderPreviousMonthInfo.firstWeekday = [nextDate firstWeekDayInMonth];
        olderPreviousMonthInfo.year = [nextDate dateYear];
        olderPreviousMonthInfo.month = [nextDate dateMonth];
        MHCalendarMonth *nextMonthInfo = olderPreviousMonthInfo;
        
        
        [self.monthArray removeAllObjects];
        [self.monthArray addObject:previousMonthInfo];
        [self.monthArray addObject:currentMothInfo];
        [self.monthArray addObject:nextMonthInfo];
        [self.monthArray addObject:prePreviousMonthDays];
        
    }
    
    [_collectionViewM reloadData]; // 中间的 collectionView 先刷新数据
    [scrollView setContentOffset:CGPointMake(0.0, self.bounds.size.height) animated:NO]; // 然后变换位置
    [_collectionViewT reloadData]; // 最后两边的 collectionView 也刷新数据
    [_collectionViewB reloadData];
    
    // 发通知，更改当前月份标题
    [self notifyToChangeCalendarHeader];
    
}



#pragma mark - Setter

- (void)setCalendarBasicColor:(UIColor *)calendarBasicColor {
    _calendarBasicColor = calendarBasicColor;
    [_collectionViewT reloadData];
    [_collectionViewM reloadData];
    [_collectionViewB reloadData];
}


#pragma mark - Getter

- (NSMutableArray *)monthArray {
    
    if (_monthArray == nil) {
        
        _monthArray = [NSMutableArray arrayWithCapacity:4];
        
        NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
        NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
        
        [_monthArray addObject:[[MHCalendarMonth alloc] initWithDate:previousMonthDate]];
        [_monthArray addObject:[[MHCalendarMonth alloc] initWithDate:_currentMonthDate]];
        [_monthArray addObject:[[MHCalendarMonth alloc] initWithDate:nextMonthDate]];
        [_monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]]; // 存储左边的月份的前一个月份的天数，用来填充左边月份的首部
        
        // 发通知，更改当前月份标题
        [self notifyToChangeCalendarHeader];
    }
    
    return _monthArray;
}

- (RACSubject *)didSelectedSubject {
    if (!_didSelectedSubject) {
        _didSelectedSubject = [RACSubject subject];
    }
    return _didSelectedSubject;
}
@end
