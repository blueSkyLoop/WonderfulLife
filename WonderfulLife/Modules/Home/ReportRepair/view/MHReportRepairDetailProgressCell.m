//
//  MHReportRepairDetailProgressCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairDetailProgressCell.h"
#import "LCommonModel.h"
#import "MHMacros.h"
#import "MHReportRepairDetailModel.h"
#import "YYText.h"
#import "ReactiveObjC.h"
#import "Masonry.h"

#import "MHReportRepairCallPhoneView.h"

//static CGFloat const leftGap = 10;
//static CGFloat const lineWidth = .5;
//static CGFloat const radius = 6;
//static CGFloat const firstRadius = 2;

@implementation MHReportRepairLineView
/*
- (void)drawRect:(CGRect)rect{
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGPoint point1 = CGPointMake(firstRadius + firstRadius, 0);
    CGPoint point2 = CGPointMake(width - radius , 0);
    CGPoint point3 = CGPointMake(width,radius);
    CGPoint point4 = CGPointMake(width, height - radius);
    CGPoint point5 = CGPointMake(width - radius, height);
    CGPoint point6 = CGPointMake(leftGap + radius, height);
    CGPoint point7 = CGPointMake(leftGap, height - radius);
    CGPoint point8 = CGPointMake(leftGap, 10);
    CGPoint point9 = CGPointMake(firstRadius, firstRadius);
    
    CGPoint center1 = CGPointMake(width - radius, radius);
    
    CGPoint center2 = CGPointMake(width - radius, height - radius);
    
    CGPoint center3 = CGPointMake(leftGap + radius, height - radius);
    
    CGPoint center4 = CGPointMake(firstRadius + firstRadius, firstRadius);
    
    [MRGBColor(211, 220, 230) setStroke];
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    
    path1.lineWidth = lineWidth;
    // 线条处理
    path1.lineCapStyle = kCGLineCapRound; //线条拐角
    [path1 moveToPoint:point1];
    [path1 addLineToPoint:point2];
    // 根据坐标点连线
    [path1 stroke];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    path2.lineWidth = lineWidth;
    // 线条处理
    path2.lineCapStyle = kCGLineCapRound; //线条拐角
    [path2 moveToPoint:point3];
    [path2 addLineToPoint:point4];
    // 根据坐标点连线
    [path2 stroke];
    
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    
    [MRGBColor(211, 220, 230) setStroke];
    path3.lineWidth = lineWidth;
    // 线条处理
    path3.lineCapStyle = kCGLineCapRound; //线条拐角
    [path3 moveToPoint:point5];
    [path3 addLineToPoint:point6];
    // 根据坐标点连线
    [path3 stroke];
    
    UIBezierPath *path4 = [UIBezierPath bezierPath];
    path4.lineWidth = lineWidth;
    // 线条处理
    path4.lineCapStyle = kCGLineCapRound; //线条拐角
    [path4 moveToPoint:point7];
    [path4 addLineToPoint:point8];
    // 根据坐标点连线
    [path4 stroke];
    
    UIBezierPath *path5 = [UIBezierPath bezierPath];
    path5.lineWidth = lineWidth;
    // 线条处理
    path5.lineCapStyle = kCGLineCapRound; //线条拐角
    [path5 moveToPoint:point8];
    [path5 addLineToPoint:point9];
    // 根据坐标点连线
    [path5 stroke];
    
    
//    //画弧
    UIBezierPath *arc1 = [UIBezierPath bezierPath];
    arc1.lineWidth = lineWidth;
    // 线条处理
    arc1.lineCapStyle = kCGLineCapRound; //线条拐角
    [arc1 addArcWithCenter:center1 radius:radius startAngle:M_PI * 1.5 endAngle:0 clockwise:YES];
    // 根据坐标点连线
    [arc1 stroke];
    
    UIBezierPath *arc2 = [UIBezierPath bezierPath];
    arc2.lineWidth = lineWidth;
    // 线条处理
    arc2.lineCapStyle = kCGLineCapRound; //线条拐角
    [arc2 addArcWithCenter:center2 radius:radius startAngle:0 endAngle:0.5 * M_PI clockwise:YES];
    // 根据坐标点连线
    [arc2 stroke];
    
    UIBezierPath *arc3 = [UIBezierPath bezierPath];
    arc3.lineWidth = lineWidth;
    // 线条处理
    arc3.lineCapStyle = kCGLineCapRound; //线条拐角
    [arc3 addArcWithCenter:center3 radius:radius startAngle:0.5 * M_PI endAngle:M_PI clockwise:YES];
    // 根据坐标点连线
    [arc3 stroke];
    
    UIBezierPath *arc4 = [UIBezierPath bezierPath];
    arc4.lineWidth = lineWidth;
    // 线条处理
    arc4.lineCapStyle = kCGLineCapRound; //线条拐角
    [arc4 addArcWithCenter:center4 radius:firstRadius startAngle: M_PI endAngle:M_PI * 1.5 clockwise:YES];
    // 根据坐标点连线
    [arc4 stroke];
}
 */

@end

@interface MHReportRepairDetailProgressCell()

@property (nonatomic,strong)MHReportRepairLogModel *amodel;

@end


@implementation MHReportRepairDetailProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [LCommonModel resetFontSizeWithView:self];
    
    
    self.telLabel.textAlignment = NSTextAlignmentLeft;
    self.bgView.contentMode = UIViewContentModeScaleToFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
     self.bgView.image = [UIImage imageNamed:@"ReportRepair_paopao"];
}

- (void)mh_configCellWithInfor:(MHReportRepairLogModel *)model{
    
    self.bgView.contentMode = UIViewContentModeScaleToFill;
    self.amodel = model;
    
    self.titleLabel.text = model.operation_app;
    self.timeLabel.text = model.create_datetime_str;

    if(model.contact_phone && model.contact_phone.length){
        NSString *notifyStr = [@"联系电话：" stringByAppendingString:model.contact_phone];
        NSMutableAttributedString *notify_contents = [[NSMutableAttributedString alloc] initWithString: notifyStr];
        NSRange range = [notifyStr rangeOfString:model.contact_phone];
        notify_contents.yy_font = [UIFont systemFontOfSize:14*MScale];
        
        @weakify(self);
        [notify_contents yy_setTextHighlightRange:range color:MRGBColor(32, 160, 255) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            MHReportRepairCallPhoneView *callPhoneView = [MHReportRepairCallPhoneView loadViewFromXib];
            [callPhoneView.callButton setTitle:self.amodel.contact_phone forState:UIControlStateNormal];
            [[UIApplication sharedApplication].keyWindow addSubview:callPhoneView];
            [callPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
            callPhoneView.callPhoneBlock = ^{
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.amodel.contact_phone];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            };
            
        }];
        [notify_contents yy_setTextHighlightRange:NSMakeRange(0, [@"联系电话：" length]) color:MRGBColor(132, 146, 166) backgroundColor:nil userInfo:nil];
        self.telLabel.attributedText = notify_contents;
        self.gapLayoutTel.constant = 9;
    }else{
        self.telLabel.attributedText = nil;
        self.gapLayoutTel.constant = 0;
        
    }
    
    
    if(model.remarks && model.remarks.length){
        self.gapLayoutRemark.constant = 8;
        self.remarkLabel.text = model.remarks;
    }else{
        self.remarkLabel.text = nil;
        self.gapLayoutRemark.constant = 0;
    }
    
    
    NSString *imageName = model.isFirst?@"ReportRepair_progress_current":@"ReportRepair_progress_other";
    self.progressIconView.image = [UIImage imageNamed:imageName];
    self.iconWidthLayout.constant = model.isFirst?16:10;
    self.iconHeightLayout.constant = model.isFirst?16:10;
}


@end
