//
//  MHVoAttendanceRegisterCommitView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAttendanceRegisterCommitView.h"
#import "MHVoseAttendanceRecordMonCell.h"

#import "UIView+NIM.h"
#import "MHMacros.h"
#import "YYText.h"

@interface MHVoAttendanceRegisterCommitView ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *normalConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *contractConstraints;


@end

extern NSString *MHVoseAttendanceRecordMonCellID;

@implementation MHVoAttendanceRegisterCommitView
#pragma mark - override
+ (instancetype)attendanceRegisterCommitView{
    return [[NSBundle mainBundle] loadNibNamed:@"MHVoAttendanceRegisterCommitView" owner:nil options:nil].firstObject;
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.rowHeight = 80;
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    [_tableView registerNib:[UINib nibWithNibName:@"MHVoseAttendanceRecordMonCell" bundle:nil] forCellReuseIdentifier:MHVoseAttendanceRecordMonCellID];
    
    
    
}

- (void)setType:(MHVoAttendanceRegisterCommitViewType)type{
    _type = type;
    if (type == MHVoAttendanceRegisterCommitViewTypeNormal) {
        self.timeLabel.hidden = YES;
        self.scoreLabel.text = @"时长";
        self.secondLabel.hidden = YES;
        [self.normalConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.priority = UILayoutPriorityDefaultHigh;
        }];
        [self.contractConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.priority = UILayoutPriorityDefaultLow;
        }];
    }else{
        self.timeLabel.hidden = YES;
    }
}

-(void)setUnAllocScore:(CGFloat)unAllocScore{
    _unAllocScore = unAllocScore;
    NSMutableAttributedString *attr;
    if (unAllocScore == (NSInteger)unAllocScore) {
        attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余未分配 %zd 分存入团队账号",(NSInteger)unAllocScore]];
    }else{
        attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余未分配 %.1f 分存入团队账号",unAllocScore]];
    }
    NSInteger count = [self nsinterLength:unAllocScore];
    count = count == 0 ? 1 : count;
    if (unAllocScore != (NSInteger)unAllocScore) {
        count += 2;
    }
    [attr yy_setTextHighlightRange:NSMakeRange(6, count) color:MColorToRGB(0xFC2F39) backgroundColor:[UIColor whiteColor] userInfo:nil];
    self.secondLabel.attributedText = attr;
}

#pragma mark - 按钮点击
- (IBAction)dismiss {
    [self removeFromSuperview];
    
}

- (IBAction)confirm {
    if ([self.delegate respondsToSelector:@selector(commitAttendance)]) {
        [self.delegate commitAttendance];
    }
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MHVoseAttendanceRecordMonCell *cell = [tableView dequeueReusableCellWithIdentifier:MHVoseAttendanceRecordMonCellID forIndexPath:indexPath];
    
    if (self.type == MHVoAttendanceRegisterCommitViewTypeContract) {
        
        cell.type = MHVoseAttendanceRecordMonCellTypeNewContract;
        
    }else if (self.isShow_UndistributedScore) {
        cell.type = MHVoseAttendanceRecordMonCellTypeNewContract;
    }
    else{
        cell.type = MHVoseAttendanceRecordMonCellTypeOne;
    }
    
    cell.model = self.dataList[indexPath.row];
    cell.timeCenterX = self.timeLabel.nim_centerX;
    cell.scoreCenterX = self.scoreLabel.nim_centerX;
    return cell;
}


#pragma mark - private

- (void)didMoveToWindow{
    self.containView.layer.cornerRadius = 4;
    self.containView.layer.masksToBounds = YES;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.97, 0.97, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.03, 1.03, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    animation.duration = 0.3;
    animation.fillMode = kCAFillModeForwards;
    [self.containView.layer addAnimation:animation forKey:nil];
    
    [self.tableView reloadData];
}

- (NSInteger)nsinterLength:(NSInteger)x {
    NSInteger sum=0,j=1;
    while( x >= 1 ) {
        x=x/10;
        sum++;
        j=j*10;
    }
    return sum;
}
#pragma mark - lazy

@end







