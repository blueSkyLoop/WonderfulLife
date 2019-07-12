//
//  MHVoSerIntegralDetailsHeaderView.m
//  WonderfulLife
//
//  Created by Lucas on 17/7/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoSerIntegralDetailsHeaderView.h"
#import "MHMacros.h"
#import "MHVoSerIntegralDetailsModel.h"
#import "UIView+Shadow.h"
#import "NSObject+isNull.h"

@interface MHVoSerIntegralDetailsHeaderView()
@property (weak, nonatomic) IBOutlet UIView *integralView;


@property (weak, nonatomic) IBOutlet UIView *line1;

@property (weak, nonatomic) IBOutlet UIView *line2;

@property (weak, nonatomic) IBOutlet UIView *line3;

@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *incomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *costBtn;


@property (weak, nonatomic) IBOutlet UILabel *integralLB;
@property (weak, nonatomic) IBOutlet UILabel *incomeLB;
@property (weak, nonatomic) IBOutlet UILabel *costLB;


@end
@implementation MHVoSerIntegralDetailsHeaderView

+ (instancetype)voSerIntegralDetailsHeaderView{
    return  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

#pragma mark - Setter

- (void)setModel:(MHVoSerIntegralDetailsModel *)model{
    _model = model ;
    
    self.integralLB.text = [model.remaining_score stringValue] ;
    
    if (![NSObject isNull:[model.total_income stringValue]]) {
        self.incomeLB.text = [NSString stringWithFormat:@"总共新增 %@",[model.total_income stringValue]] ;
        [self setAttributedString:self.incomeLB];
    }
    
    if (![NSObject isNull:[model.total_cost stringValue]]) {
        self.costLB.text = [NSString stringWithFormat:@"总共兑换 %@",[model.total_cost stringValue]] ;
        [self setAttributedString:self.costLB];
    }
}

#pragma mark - Private
- (void)setAttributedString:(UILabel *)label{
    //富文本对象
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    
    //富文本样式
    [aAttributedString addAttribute:NSFontAttributeName             //文字字体
                              value:[UIFont systemFontOfSize:15.0]
                              range:NSMakeRange(0, 4)];
    label.attributedText = aAttributedString;
}


- (void)awakeFromNib{
    [super awakeFromNib];
//    self.integralView.layer.masksToBounds = YES;
    
    [self.integralView mh_setupContainerLayerWithContainerView];
    //    [self.allBtn setTitleColor:MColorMainGradientStart forState:UIControlStateNormal];
}


- (IBAction)btnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            self.line1.hidden = NO;
            self.line2.hidden = YES;
            self.line3.hidden = YES;
            [self.allBtn setTitleColor:MColorMainGradientStart forState:UIControlStateNormal];
            [self.incomeBtn setTitleColor:MColorTitle forState:UIControlStateNormal];
            [self.costBtn setTitleColor:MColorTitle forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            self.line1.hidden = YES;
            self.line2.hidden = NO;
            self.line3.hidden = YES;
            [self.allBtn setTitleColor:MColorTitle forState:UIControlStateNormal];
            [self.incomeBtn setTitleColor:MColorMainGradientStart forState:UIControlStateNormal];
            [self.costBtn setTitleColor:MColorTitle forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            self.line1.hidden = YES;
            self.line2.hidden = YES;
            self.line3.hidden = NO;
            [self.allBtn setTitleColor:MColorTitle forState:UIControlStateNormal];
            [self.incomeBtn setTitleColor:MColorTitle forState:UIControlStateNormal];
            [self.costBtn setTitleColor:MColorMainGradientStart forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectHeaderViewBtn:)]) {
        [self.delegate didSelectHeaderViewBtn:sender];
    }
}



@end
