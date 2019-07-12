//
//  MHBuildingView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/29.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBuildingView.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
#import "MHThemeButton.h"

@interface MHBuildingView ()
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet MHThemeButton *knowButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imv;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTop;
@end
@implementation MHBuildingView{
    CGFloat scale;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)initControls
{
    scale = MScreenW/375;
    
    self.detailLabel.font = MFont(17*scale);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:self.detailLabel.attributedText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:11*scale];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrString length])];
    self.detailLabel.attributedText = attrString;
    
    self.knowButton.noShadow = YES;
    self.knowButton.layer.cornerRadius = 28*scale;
    self.containerView.layer.cornerRadius = 26*scale;
}

+ (instancetype)buildingView{
    MHBuildingView *v = [[NSBundle mainBundle] loadNibNamed:@"MHBuildingView" owner:nil options:nil].lastObject;
    [v initControls];
    return v;
}

+ (instancetype)buildingViewWithIcon:(NSString *)icon
                               title:(NSString *)title
                             content:(NSString *)content {
    MHBuildingView *v = [[NSBundle mainBundle] loadNibNamed:@"MHBuildingView" owner:nil options:nil].lastObject;
    v.imv.image = [UIImage imageNamed:icon];
    v.titleLab.text = title;
    v.detailLabel.text = content;
    [v initControls];
    
    if (!title) {
        v.detailTop.constant = -10;
    }
    return v;
}

- (IBAction)remove {
    [self removeFromSuperview];
}


@end
