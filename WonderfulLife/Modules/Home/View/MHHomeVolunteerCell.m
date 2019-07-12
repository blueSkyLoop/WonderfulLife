//
//  MHHomeVolunteerCell.m
//  WonderfulLife
//
//  Created by hanl on 2017/7/17.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomeVolunteerCell.h"
#import "MHMacros.h"
#import "MHHomeArticle.h"
#import "UIImageView+WebCache.h"

@interface MHHomeVolunteerCell ()
@property (weak, nonatomic) IBOutlet UIButton *mh_moreButton;
@end

@implementation MHHomeVolunteerCell

- (void)awakeFromNib {
    [super awakeFromNib];

    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.mh_imageView addGestureRecognizer:tapImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.mh_content addGestureRecognizer:tap];
}

- (void)mh_collectionViewCellWithModel:(MHHomeArticle*)model {
    [self.mh_imageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"homeVolunteerPlaceholder"]];
    self.mh_content.text = model.subject;

}

- (IBAction)clickMoreButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(mh_collectionViewCellDidSelectedComactivitiesHeaderMore)]) {
        [self.delegate mh_collectionViewCellDidSelectedComactivitiesHeaderMore];
    }
}

- (void)tapAction:(UIGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(mh_collectionViewCellDidSelectedComactivitiesHeaderImage)]) {
        [self.delegate mh_collectionViewCellDidSelectedComactivitiesHeaderImage];
    }
}
@end
