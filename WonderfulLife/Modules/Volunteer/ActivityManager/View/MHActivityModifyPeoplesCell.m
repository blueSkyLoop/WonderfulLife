//
//  MHActivityModifyPeoplesCell.m
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHActivityModifyPeoplesCell.h"
#import "MHHUDManager.h"
#import "ReactiveObjC.h"

@interface MHActivityModifyPeoplesCell ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *subButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (assign, nonatomic) NSInteger limitNumber;
@property (strong, nonatomic) RACSignal *timerSignal;
@property (assign, nonatomic) BOOL  timerFire;

@end

@implementation MHActivityModifyPeoplesCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellId = @"MHActivityModifyPeoplesCell";
    MHActivityModifyPeoplesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MHActivityModifyPeoplesCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)setModel:(NSDictionary *)model {
    _model = model;
    
    NSString *number = model[@"content"];
    self.selectedNumber = [number integerValue];
    self.limitNumber = [model[@"limitCount"] integerValue];
    if (self.selectedNumber == 0) {
        self.numberLabel.font = [UIFont boldSystemFontOfSize:18];
        self.numberLabel.text = @"不限";
        self.subButton.hidden = YES;
    }else {
        self.numberLabel.font = [UIFont boldSystemFontOfSize:20];
        self.numberLabel.text = number;
        self.subButton.hidden = NO;
    }
}


- (IBAction)subEvent:(id)sender {
    self.numberLabel.text = [self numberOfCalculations:NO];
}
- (IBAction)addEvent:(id)sender {
    self.numberLabel.text = [self numberOfCalculations:YES];
}

- (NSString*)numberOfCalculations:(BOOL)isAdd {
    
    if (isAdd) {
        if (self.limitNumber != 0&&self.selectedNumber == 0) {
            self.selectedNumber = self.limitNumber;
        }else {
            self.selectedNumber++;
        }
    }else {
        self.selectedNumber--;
    }
    
    if (self.limitNumber > self.selectedNumber) {
        self.selectedNumber = 0;
    }
    
    if (self.selectedNumber <= 0) {
        self.selectedNumber = 0;
        self.subButton.hidden = YES;
    }else {
        self.subButton.hidden = NO;
    }
    
    if (self.clickBlock) {
        self.clickBlock(self.selectedNumber);
    }
    
    ///当数值为0的时候，显示不限
    if (self.selectedNumber == 0) {
        self.numberLabel.font = [UIFont boldSystemFontOfSize:18];
        return @"不限";
    }
    self.numberLabel.font = [UIFont boldSystemFontOfSize:20];

    return [NSString stringWithFormat:@"%ld",self.selectedNumber];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILongPressGestureRecognizer *sub_longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(subBtnLong:)];
    sub_longPress.minimumPressDuration = 0.8; //定义按的时间
    [self.subButton addGestureRecognizer:sub_longPress];
    
    UILongPressGestureRecognizer *add_longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(add_BtnLong:)];
    add_longPress.minimumPressDuration = 0.8; //定义按的时间
    [self.addButton addGestureRecognizer:add_longPress];

}

-(void)subBtnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    @weakify(self);
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.timerFire = NO;
        self.timerSignal = [[RACSignal interval:0.1 onScheduler:[RACScheduler mainThreadScheduler]]takeUntilBlock:^BOOL(NSDate * _Nullable x) {
            @strongify(self);
            return self.timerFire;
        }];
        [self.timerSignal subscribeNext:^(id  _Nullable x) {
            self.selectedNumber--;
            if (self.limitNumber > self.selectedNumber) {
                self.selectedNumber = 0;
            }
            
            if (self.selectedNumber <= 0) {
                self.selectedNumber = 0;
                self.subButton.hidden = YES;
            }else {
                self.subButton.hidden = NO;
            }
            
            if (self.selectedNumber == 0) {
                self.numberLabel.font = [UIFont boldSystemFontOfSize:18];
                self.numberLabel.text = @"不限";
                return;
            }
            self.numberLabel.font = [UIFont boldSystemFontOfSize:20];
            self.numberLabel.text = [NSString stringWithFormat:@"%ld",self.selectedNumber];
        }];
    }else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        self.timerFire = YES;
        if (self.clickBlock) {
            self.clickBlock(self.selectedNumber);
        }
        
    }

}

-(void)add_BtnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    @weakify(self);
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.timerFire = NO;
        self.timerSignal = [[RACSignal interval:0.1 onScheduler:[RACScheduler mainThreadScheduler]]takeUntilBlock:^BOOL(NSDate * _Nullable x) {
            @strongify(self);
            return self.timerFire;
        }];
        [self.timerSignal subscribeNext:^(id  _Nullable x) {
            if (self.limitNumber != 0&&self.selectedNumber == 0) {
                self.selectedNumber = self.limitNumber;
            }else {
                self.selectedNumber++;
            }
            if (self.limitNumber > self.selectedNumber) {
                self.selectedNumber = 0;
            }
            
            if (self.selectedNumber <= 0) {
                self.selectedNumber = 0;
                self.subButton.hidden = YES;
            }else {
                self.subButton.hidden = NO;
            }
            
            if (self.selectedNumber == 0) {
                self.numberLabel.font = [UIFont boldSystemFontOfSize:18];
                self.numberLabel.text = @"不限";
                return;
            }
            self.numberLabel.font = [UIFont boldSystemFontOfSize:20];
            self.numberLabel.text = [NSString stringWithFormat:@"%ld",self.selectedNumber];
        }];
    }else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        self.timerFire = YES;
        if (self.clickBlock) {
            self.clickBlock(self.selectedNumber);
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
