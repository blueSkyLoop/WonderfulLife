//
//  MHMineShare.m
//  WonderfulLife_dev
//
//  Created by 梁斌文 on 2017/10/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineShare.h"

@implementation MHMineShare

+ (MHMineShare *)mineShare {
    MHMineShare * model = [MHMineShare new];
    
    // 苹果商店url 
    model.url = @"http://mhh.jufuns.cn/web/client/h5/download/h5";

    model.title = @"加入美好志愿，用爱心筑梦，让更多人生活更美好！";
    
    model.summary = @"爱心、奉献、互助、共享！";
    
    /** 拿本地icon*/
    model.logoImage = [UIImage imageNamed:@"美好慧logo"];
    
    // 图片链接 url
//    model.img_url  = @"https://106.14.66.246/web/images/app_logo/app_logo.png";
    
    return model; 
}


+ (MHMineShare *)mineShareSina {
    MHMineShare * model = [MHMineShare mineShare];
    
   model.title = [NSString stringWithFormat:@"%@%@%@",model.title,model.summary,model.url];
    
    return model ;
}

+ (MHMineShare *)mineShareWechatTimeLine {
     MHMineShare * model = [MHMineShare mineShare];
     model.title = [NSString stringWithFormat:@"%@%@",model.title,model.summary];
    return model ;
}

@end
