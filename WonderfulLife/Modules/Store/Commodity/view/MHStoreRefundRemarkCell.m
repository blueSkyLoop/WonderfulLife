//
//  MHStoreRefundRemarkCell.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/30.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreRefundRemarkCell.h"
#import "LCommonModel.h"
#import "MHMacros.h"
#import "Masonry.h"
#import "MHHUDManager.h"
#import "ReactiveObjC.h"


@interface MHStoreRefundRemarkCell()

@property (nonatomic,strong)NSMutableDictionary *dict;

@end

@implementation MHStoreRefundRemarkCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [LCommonModel resetFontSizeWithView:self];
    
    self.bgView.layer.borderColor = [MRGBColor(211, 220, 230) CGColor];
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.cornerRadius = 3;
    self.bgView.layer.masksToBounds = YES;
    
    self.textView.font = [UIFont systemFontOfSize:MScale * 17];
    
    self.heigthLayout.constant = (147 + 100) * 320.0 / MScreenW;
    
    self.textView.keyboardType = UIKeyboardTypeDefault;
    
    [self bindTextView];
}

- (void)bindTextView{
    @weakify(self);
    [[self.textView rac_textSignal] subscribeNext:^(NSString *text) {
        @strongify(self);
        UITextRange *markedRange = [self.textView markedTextRange];
        if(markedRange) return ;
        NSString *atext = text;
        if(atext.length <= 150){
            //            self.textView.text = atext;
        }else{
            atext = [atext substringWithRange:NSMakeRange(0, 150)];
            self.textView.text = atext;
            [MHHUDManager showText:@"最多输入150字"];
        }
        self.numLabel.text = [NSString stringWithFormat:@"%ld/%ld",atext.length,150];
        [self.dict setValue:atext?:@"" forKey:@"reamrk"];
        
    }];
}


- (void)mh_configCellWithInfor:(NSMutableDictionary *)dict{
    self.dict = dict;
    NSString *aremark = self.dict[@"reamrk"];
    aremark = aremark.length?aremark:@"";
    self.textView.text = aremark;
}




@end
