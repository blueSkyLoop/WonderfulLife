//
//  MHMiAboutUsController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMiAboutUsController.h"

@interface MHMiAboutUsController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation MHMiAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"v%@",versionStr];
    
}

@end
