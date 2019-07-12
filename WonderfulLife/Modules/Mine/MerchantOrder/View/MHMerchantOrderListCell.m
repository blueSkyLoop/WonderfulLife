//
//  MHMerchantOrderPaidCell.m
//  WonderfulLife
//
//  Created by zz on 24/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderListCell.h"
#import "Masonry.h"
#import "MHMacros.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Color.h"

#import "MHMerchantOrderModel.h"

#import "MHHUDManager.h"

static NSString *const kTableViewPanStateIdentifier = @"state";

@interface MHMerchantOrderListCell ()<MHMerchantOrderCellContentDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *ticketStatus;
@property (weak, nonatomic) IBOutlet UIView *goodsContentView;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UIButton *goodsQRCode;
@property (weak, nonatomic) IBOutlet UIButton *goodsDetails;
@property (weak, nonatomic) IBOutlet UIView *goodsBaseView;
@property (weak, nonatomic) IBOutlet UIButton *paidButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailButtonRightConstraints;

@property (weak, nonatomic) MHMerchantOrderModel *orderModel;

@property (weak, nonatomic) UITableView *containerTableView;
@property (strong,nonatomic) UIPanGestureRecognizer *tableViewPanGestureReconginzer;
//@property (strong,nonatomic) UITapGestureRecognizer *tableViewTapGestureReconginzer;
@end

@implementation MHMerchantOrderListCell

- (void)dealloc {
    [self removeOldTableVewPanObserver];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [self.paidButton setBackgroundImage:[UIImage mh_imageGradientSetMainColorWithBounds:CGRectMake(0, 0, 90, 30)] forState:UIControlStateNormal];
    self.paidButton.layer.cornerRadius = 15.f;
    self.paidButton.layer.masksToBounds = YES;
    self.paidButton.hidden = YES;
    
    self.goodsQRCode.layer.cornerRadius = 15.f;
    self.goodsDetails.layer.cornerRadius = 15.f;
    self.goodsQRCode.layer.masksToBounds = YES;
    self.goodsDetails.layer.masksToBounds = YES;
    self.goodsQRCode.layer.borderWidth = 1.f;
    self.goodsDetails.layer.borderWidth = 1.f;
    self.goodsQRCode.layer.borderColor = MColorRed.CGColor;
    self.goodsDetails.layer.borderColor = MColorFootnote.CGColor;
    
    MHMerchantOrderCellContentView *goodsView = [[MHMerchantOrderCellContentView alloc]init];
    goodsView.contentDelegate = self;
    [self.goodsContentView addSubview:goodsView];
    [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.goodsContentView);
    }];
    self.goodsView = goodsView;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchGoodsEvent:)];
    [self.goodsBaseView addGestureRecognizer:gesture];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.goodsView hideDeleteButtonAnimated:NO];
}

- (void)didMoveToSuperview {
    self.containerTableView = nil;
    UIView *view = self.superview;
    
    do {
        if ([view isKindOfClass:[UITableView class]]) {
            self.containerTableView = (UITableView *)view;
            break;
        }
    } while ((view = view.superview));
}

- (void)touchGoodsEvent:(UITapGestureRecognizer *)sender {
    [self mh_merchantListDidSelected:NO];
 }

- (void)mh_merchantListDidSelected:(BOOL)isPush {
    
    BOOL isDeleteButtonAnimated = NO;
    for (MHMerchantOrderListCell *cell in [self.containerTableView visibleCells]) {
        if (cell != self && [cell isKindOfClass:[MHMerchantOrderListCell class]]) {
            if (cell.goodsView.cellStateRight) {
                isDeleteButtonAnimated = YES;
                [cell.goodsView hideDeleteButtonAnimated:YES];
            }
        }
    }
    
    if (self.goodsView.cellStateRight) {
        isDeleteButtonAnimated = YES;
        [self.goodsView hideDeleteButtonAnimated:YES];
        if (!isPush) { return; }
    }

    if (isDeleteButtonAnimated) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(mh_merchantListOrderCell:didSelectRow:)]) {
                [self.delegate mh_merchantListOrderCell:self didSelectRow:_orderModel];
            }
        });
    }else {
        if ([self.delegate respondsToSelector:@selector(mh_merchantListOrderCell:didSelectRow:)]) {
            [self.delegate mh_merchantListOrderCell:self didSelectRow:_orderModel];
        }
    }
}

#pragma mark - MHMerchantOrderCellContentDelegate
- (void)cellContentViewShouldHideDeleteOnSwipe:(MHMerchantOrderCellContentView*)view {
    for (MHMerchantOrderListCell *cell in [self.containerTableView visibleCells]) {
        if (cell != self && [cell isKindOfClass:[MHMerchantOrderListCell class]]) {
            [cell.goodsView hideDeleteButtonAnimated:YES];
        }
    }
}

- (void)cellContentViewDidSelectedView:(MHMerchantOrderCellContentView*)view {
    [self mh_merchantListDidSelected:NO];
}

- (void)cellContentViewDidDeleteButtonView:(MHMerchantOrderCellContentView*)view {
    
    /**
     订单列表cell删除按钮指定的情况变灰，并弹窗提示不可删除
     情况如下：【1待使用】，【2带评价】，【4退款中】，【6退款失败，待使用】时，订单左滑不可【删除订单】，删除按钮为灰色不可点，点击是提示“订单进行中，不可删除”
     */
    if ([@[@1,@2,@4,@6] containsObject:_orderModel.order_status_type]) {
        [MHHUDManager showText:@"订单进行中，不可删除"];
        return;
    }
    
    
    /**
     『退款列表』
     
     订单列表cell删除按钮指定的情况变灰，并弹窗提示不可删除
     情况如下：【0待审核】，【2已拒绝】时，订单左滑不可【删除订单】，删除按钮为灰色不可点，点击是提示“订单进行中，不可删除”
     */
    if (_orderModel.refund_status) {
        if ([@[@0,@2] containsObject:_orderModel.refund_status]) {
            [MHHUDManager showText:@"订单进行中，不可删除"];
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(mh_merchantListOrderCell:didSelectDeleteButton:)]) {
        [self.delegate mh_merchantListOrderCell:self didSelectDeleteButton:_orderModel];
    }
}


- (IBAction)detailButtonEvent:(id)sender {
    [self mh_merchantListDidSelected:YES];
}
- (IBAction)paidButtonEvent:(id)sender {
    [self mh_merchantListDidSelected:YES];
}

- (IBAction)QRButtonEvent:(id)sender {
    
    BOOL isDeleteButtonAnimated = NO;
    for (MHMerchantOrderListCell *cell in [self.containerTableView visibleCells]) {
        if ([cell isKindOfClass:[MHMerchantOrderListCell class]]) {
            isDeleteButtonAnimated = YES;
            [cell.goodsView hideDeleteButtonAnimated:YES];
        }
    }

    if (isDeleteButtonAnimated) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(mh_merchantListOrderCell:didSelectToQRCode:)]) {
                [self.delegate mh_merchantListOrderCell:self didSelectToQRCode:_orderModel];
            }
        });
    }else {
        if ([self.delegate respondsToSelector:@selector(mh_merchantListOrderCell:didSelectToQRCode:)]) {
            [self.delegate mh_merchantListOrderCell:self didSelectToQRCode:_orderModel];
        }
    }

}

- (void)mh_configCellWithInfor:(id)model {
    
    _orderModel = model;
    if (_orderModel.merchant_name) {
        self.shopName.text = _orderModel.merchant_name;
    }else {
        self.shopName.text = _orderModel.name;
    }
    
    if (_orderModel.order_status) {
        self.ticketStatus.text = _orderModel.order_status;
    }else {
        self.ticketStatus.text = [self refundStatus:_orderModel.refund_status];
    }
    self.goodsPrice.text = [NSString stringWithFormat:@"合计：¥%@",_orderModel.order_price];
    self.goodsView.goodsOrderTitle.text = _orderModel.coupon_name;
    NSString *order_no = [NSString stringWithFormat:@"订单编号：%@",_orderModel.order_no];
    self.goodsView.goodsOrderNumber.text = order_no;
    if (!_orderModel.user_nickname) {
        NSString *expiry_time = [NSString stringWithFormat:@"有效日期：%@",_orderModel.expiry_time];
        if (!_orderModel.expiry_time) {
            expiry_time = [NSString stringWithFormat:@"有效日期：%@至%@",_orderModel.expiry_time_begin,_orderModel.expiry_time_end];
        }
        self.goodsView.goodsOrderExpiryDate.text = expiry_time;
    }else {
        NSString *user_nickname = [NSString stringWithFormat:@"申请用户：%@",_orderModel.user_nickname];
        self.goodsView.goodsOrderExpiryDate.text = user_nickname;
    }
    
    //此处重置删除的颜色
    self.goodsView.buttonView.backgroundColor = MColorRed;
    /**
     订单列表cell删除按钮指定的情况变灰，并弹窗提示不可删除
     情况如下：【1待使用】，【2待评价】，【4退款中】，【6退款失败，待使用】时，订单左滑不可【删除订单】，删除按钮为灰色不可点，点击是提示“订单进行中，不可删除”
     */
    if ([@[@1,@2,@4,@6] containsObject:_orderModel.order_status_type]) {
        self.goodsView.buttonView.backgroundColor = MColorDisableBtn;
    }
    
    /**
     『退款列表』
     
     订单列表cell删除按钮指定的情况变灰，并弹窗提示不可删除
     情况如下：【0待审核】，【2已拒绝】时，订单左滑不可【删除订单】，删除按钮为灰色不可点，点击是提示“订单进行中，不可删除”
     */
    if (_orderModel.refund_status) {
        if ([@[@0,@2] containsObject:_orderModel.refund_status]) {
            self.goodsView.buttonView.backgroundColor = MColorDisableBtn;
        }
    }
    
    NSURL *url = [NSURL URLWithString:_orderModel.img_cover];
    [self.goodsView.goodsImageView sd_setImageWithURL:url];
    
    self.detailButtonRightConstraints.constant = 124.f;
    
    //判断是否是待支付状态，显示对应按钮, 2018.01.12 新增判断是否扫码收款的隐藏二维码按钮
    if ([_orderModel.order_status_type isEqualToNumber:@0]) {
        self.paidButton.hidden = NO;
        self.goodsQRCode.hidden = YES;
        self.goodsDetails.hidden = YES;
        if (self.isMerchantList) {
            self.detailButtonRightConstraints.constant = 16;
            self.paidButton.hidden = YES;
            self.goodsDetails.hidden = NO;
        }
    }else if (![_orderModel.goods_type isEqualToNumber:@0]) {
        self.detailButtonRightConstraints.constant = 16;
        self.goodsQRCode.hidden = YES;
        self.paidButton.hidden = YES;
        self.goodsDetails.hidden = NO;
    }else {
        self.paidButton.hidden = YES;
        self.goodsQRCode.hidden = NO;
        self.goodsDetails.hidden = NO;
    }
    
}

- (NSString *)refundStatus:(NSNumber *)status {
    if ([status isEqualToNumber:@0]) {
        return @"待审核";
    }else if([status isEqualToNumber:@1]){
        return @"已退款";
    }
    return @"已拒绝";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)removeOldTableVewPanObserver {
    
    [_tableViewPanGestureReconginzer removeObserver:self forKeyPath:kTableViewPanStateIdentifier];
}



#pragma mark - Setter
- (void)setContainerTableView:(UITableView *)containerTableView {
    [self removeOldTableVewPanObserver];
    
    _tableViewPanGestureReconginzer = containerTableView.panGestureRecognizer;
    
    _containerTableView = containerTableView;
    
    if (containerTableView) {
        _containerTableView.directionalLockEnabled = YES;
        [self.goodsView.deleteTap requireGestureRecognizerToFail:_containerTableView.panGestureRecognizer];
        [self.goodsView.contentViewTap requireGestureRecognizerToFail:_containerTableView.panGestureRecognizer];
        [_tableViewPanGestureReconginzer addObserver:self forKeyPath:kTableViewPanStateIdentifier options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:kTableViewPanStateIdentifier] && object == _tableViewPanGestureReconginzer){
        if(_tableViewPanGestureReconginzer.state == UIGestureRecognizerStateBegan){
//            CGPoint locationInTableView = [_tableViewPanGestureReconginzer locationInView:_containerTableView];
//            BOOL inCurrentCell = CGRectContainsPoint(self.frame, locationInTableView);
            if(self.goodsView.isCellStateRight){
                [self.goodsView hideDeleteButtonAnimated:YES];
            }
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.containerTableView.panGestureRecognizer || otherGestureRecognizer == self.containerTableView.panGestureRecognizer)
    {
        // Return YES so the pan gesture of the containing table view is not cancelled by the long press recognizer
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![touch.view isKindOfClass:[UIControl class]];
}
@end
