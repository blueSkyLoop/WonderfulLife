//
//  MHVoAttendanceRecordDetailCell.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAttendanceRecordDetailCell.h"
#import "MHUserInfoManager.h"
#import "MHMacros.h"
#import "UIView+NIM.h"
#import "UIImageView+WebCache.h"

@interface MHVoAttendanceRecordDetailCell ()
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *constraints;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation MHVoAttendanceRecordDetailCell

#pragma mark - override
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        constraint.constant = constraint.constant *MScale;
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setRow:(NSInteger)row{
    _row = row;
    if (row == 0) {
        self.titleLabel.text = @"活动类型：";
    }else if (row == 1){
        self.titleLabel.text = @"活动队伍：";
    }else if (row == 2){
        self.titleLabel.text = @"开始时间：";
    }else if (row == 3){
        self.titleLabel.text = @"结束时间：";
    }else if (row == 4){
        self.titleLabel.text = @"活动地址：";
    }else if (row == 5){
        self.titleLabel.text = @"活动名额：";
    }
}

- (void)setModel:(MHVoAttendanceRecordDetailModel *)model{
    _model = model;
    if (_row == 0) {
        self.contentLabel.text = model.title;
    }else if (_row == 1){
        self.contentLabel.text = model.team_name;
    }else if (_row == 2){
        self.contentLabel.text = model.date_begin;
    }else if (_row == 3){
        self.contentLabel.text = model.date_end;
    }else if (_row == 4){
        self.contentLabel.text = model.addr;
        [self.contentLabel sizeToFit];
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];
        model.acAdHeight = self.contentLabel.nim_bottom + 8;
        
    }else if (_row == 5){
        self.contentLabel.text = model.qty;
    }
}

#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy

@end



@interface MHVoAttendanceRecordDetailPhotoCell ()<PYPhotosViewDelegate>

@property (nonatomic,strong) NSMutableArray *thumbnailImageUrls;
@property (nonatomic,strong) NSMutableArray *originalImageUrls;
@property (nonatomic,strong) UIView *line;
@end

@implementation MHVoAttendanceRecordDetailPhotoCell

#pragma mark - override
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PYPhotosView *photosView = [PYPhotosView photosView];
        photosView.autoLayoutWithWeChatSytle = NO;
        photosView.photoMargin = 19*MScale;
        photosView.photoWidth = 96*MScale;
        photosView.photoHeight = photosView.photoWidth;
        photosView.frame = CGRectMake(24*MScale, 0, 327*MScale, 96*MScale);
        photosView.imagesMaxCountWhenWillCompose = 6;
        self.photosView = photosView;
        
        
        [self.contentView addSubview:photosView];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(24*MScale, 96*MScale + 32-0.5, 327*MScale, 0.5)];
        _line.backgroundColor = MColorSeparator;
        [self.contentView addSubview:_line];
        
        self.originalImageUrls = [NSMutableArray array];
        self.thumbnailImageUrls = [NSMutableArray array];
    }
    return self;
}

- (void)setType:(MHVoAttendanceRecordDetailCellType)type{
    _type = type;
    if (type == MHVoAttendanceRecordDetailCellTypeDetail) {
        self.photosView.photosState = PYPhotosViewStateDidCompose;
        
    }else{
        self.photosView.photosState = PYPhotosViewStateWillCompose;
        
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _line.nim_bottom = self.contentView.nim_height;
}

- (void)setModel:(MHVoAttendanceRecordDetailModel *)model{
    _model = model;
    if (self.thumbnailImageUrls.count == 0) {
        [model.imgs enumerateObjectsUsingBlock:^(MHOOSImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.thumbnailImageUrls addObject:obj.s_url];
            [self.originalImageUrls addObject:obj.url];
        }];
        _photosView.thumbnailUrls = _thumbnailImageUrls;
        _photosView.originalUrls = _originalImageUrls;
        for (NSInteger i = 0; i < model.imgs.count; i++) {
            UIImageView *view = _photosView.subviews[i];
            view.layer.cornerRadius = 2;
            view.layer.masksToBounds = YES;
        }
    }
}
#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private


#pragma mark - lazy



@end



@interface MHVoAttendanceRecordDetailRemarksCell ()
@property (nonatomic,weak) UIView *line;
@property (nonatomic,strong) UIImageView *arrowImageView;

@end

@implementation MHVoAttendanceRecordDetailRemarksCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *remarksLabel = [[UILabel alloc] init];
        remarksLabel.textColor = MColorTitle;
        remarksLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:remarksLabel];
        remarksLabel.frame = CGRectMake(24*MScale, 0, 327*MScale, 0);
        _remarksLabel = remarksLabel;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(24*MScale, 96*MScale + 32-0.5, 327*MScale, 0.5)];
        line.backgroundColor = MColorSeparator;
        [self.contentView addSubview:line];
        _line = line;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _line.nim_top = self.contentView.nim_height - 0.5;
    if (_type == MHVoAttendanceRecordDetailCellTypeDetail) {
        _remarksLabel.nim_top = 0;
    }else if (_type == MHVoAttendanceRecordDetailCellTypeRegister){
        _remarksLabel.nim_centerY = self.contentView.nim_height/2;
    }
}

- (void)setType:(MHVoAttendanceRecordDetailCellType)type{
    _type = type;
    if (type == MHVoAttendanceRecordDetailCellTypeDetail) {
        _remarksLabel.numberOfLines = 0;
        
        [_arrowImageView removeFromSuperview];
    }else if (type == MHVoAttendanceRecordDetailCellTypeRegister){
        _remarksLabel.numberOfLines = 1;
        _remarksLabel.nim_size = CGSizeMake(305*MScale, 25);
        
        [self.contentView addSubview:self.arrowImageView];
    }
}

- (void)setModel:(MHVoAttendanceRecordDetailModel *)model{
    _model = model;
    NSString *content ;
    
    if (self.contentType == MHVoAttendanceRecordDetailContentTypeActivityIntroduce) {
        content = model.action_intro;
    }else if (self.contentType == MHVoAttendanceRecordDetailContentTypeAttendanceRemarks){
        content = model.remark;
    }else if (self.contentType == MHVoAttendanceRecordDetailContentTypeAttendanceAudit){
        content = model.audit_remark;
    }
    
    self.remarksLabel.text = content;
    _remarksLabel.nim_width = 327*MScale;
    [_remarksLabel sizeToFit];
    
    if (self.contentType == MHVoAttendanceRecordDetailContentTypeActivityIntroduce) {
        model.acInHeight = _remarksLabel.nim_bottom +24;
        
    }else if (self.contentType == MHVoAttendanceRecordDetailContentTypeAttendanceRemarks){
        model.AtReHeight = _remarksLabel.nim_bottom +24;
    }else if (self.contentType == MHVoAttendanceRecordDetailContentTypeAttendanceAudit){
        model.auReHeight = _remarksLabel.nim_bottom +24;
    }
}

#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private


#pragma mark - lazy
- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
        [_arrowImageView sizeToFit];
        _arrowImageView.nim_origin = CGPointMake(345*MScale, 30);
    }
    return _arrowImageView;
}
@end


@interface MHVoAttendanceRecordDetailMemberCell ()
@property (nonatomic,strong) UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *captainLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation MHVoAttendanceRecordDetailMemberCell{
    CGFloat nameCenterY;
}

#pragma mark - override
- (void)awakeFromNib {
    [super awakeFromNib];
    _captainLab.textColor = MColorBlue;
    _captainLab.layer.masksToBounds = YES;
    _captainLab.layer.cornerRadius = 3;
    _captainLab.layer.borderColor = MColorBlue.CGColor;
    _captainLab.layer.borderWidth = 1;
    
    self.iconView.layer.cornerRadius = 20;
    self.iconView.layer.masksToBounds = YES;
    nameCenterY = self.nameLabel.center.y;
}

- (void)setType:(MHVoAttendanceRecordDetailMemberCellType)type{
    _type = type;
    if (type == MHVoAttendanceRecordDetailMemberCellTypeScore) {
        self.label.text = @"分";
    }
}

- (void)setModel:(MHVoAttendanceRecordDetailCrewModel *)model{
    _model = model;
    if ([model.tag isEqualToString:@"队长"]) {
        [self captainType:0];
    }else if ([model.tag isEqualToString:@"总队长"]){
        [self captainType:1];
    }else{
        self.captainLab.hidden = YES;
        self.nameLabel.nim_centerY = 40;
    }
    
    if (_type == MHVoAttendanceRecordDetailMemberCellTypeTime) {
        self.timeLabel.text = _model.duration.length ? _model.duration : @"0";
    }else{
        self.timeLabel.text = _model.score;
        
    }
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headphoto_s_url] placeholderImage:MAvatar];
    
    self.nameLabel.text = model.volunteer_name;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.timeLabel sizeToFit];
    self.timeLabel.nim_right = self.contentView.nim_right - (_type == MHVoAttendanceRecordDetailMemberCellTypeScore ? 56 : 64)*MScale;
    self.nameLabel.nim_width = self.timeLabel.nim_left - 16 - self.nameLabel.nim_left;
}

#pragma mark - 按钮点击

#pragma mark - delegate

#pragma mark - private
- (void)captainType:(NSInteger )type{
    self.nameLabel.nim_top = 14;
    self.captainLab.hidden = false;
    if (type == 0) {
        _captainLab.textColor = MColorBlue;
        _captainLab.layer.borderColor = MColorBlue.CGColor;
        _captainLab.text = @"队长";
    }else{
        _captainLab.textColor = MColorGeneralLeader;
        _captainLab.layer.borderColor = MColorGeneralLeader.CGColor;
        _captainLab.text = @"总队长";
    }
}
#pragma mark - lazy
- (UIView *)line{
    if (_line == nil) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(24*MScale, 79.5 , 327*MScale, 0.5)];
        _line.backgroundColor = MColorSeparator;
        [self.contentView addSubview:_line];
    }
    return _line;
}
@end
