//
//  MHGuidePageViewController.m
//  JFCommunityCenter
//
//  Created by 飞飞-飞你妹 on 16/9/30.
//  Copyright © 2016年 com.cn. All rights reserved.
//

#import "MHGuidePageViewController.h"
#import "Masonry.h"
#import "MHMacros.h"
#import "AppDelegate.h"
static const NSUInteger kPageCount = 4;


@interface MHGuidePageViewController ()<UIScrollViewDelegate>
{
    UIButton *passBtn;
}
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIPageControl *pageControl;

@end

@implementation MHGuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, MScreenH)];
    self.scrollView.pagingEnabled=YES;
    
    self.scrollView.delegate=self;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width*kPageCount, self.scrollView.frame.size.height);
    [self.view addSubview:self.scrollView];
    
    CGFloat pageHeight = 10 ;
    CGFloat scale_Y =MScreenH - 90 - pageHeight; //pageControl 的Y值
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(MScreenW/2-15, scale_Y, 30, pageHeight)];
    self.pageControl.numberOfPages=kPageCount;
    self.pageControl.currentPage=0;
    self.pageControl.currentPageIndicatorTintColor = MColorToRGB(0xFF4949);
    self.pageControl.pageIndicatorTintColor = MColorToRGB(0xE5E9F2);
    [self.view addSubview:self.pageControl];
    
    for (int i = 1; i <= kPageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*MScreenW, 0, MScreenW, MScreenH)];

        NSString *pathStr = [[NSString stringWithFormat:@"guidepage_%d", i] stringByAppendingString:@"@2x"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:pathStr ofType:@"png"];
        imageView.image = [UIImage imageWithContentsOfFile:path];
        [self.scrollView addSubview:imageView];
        
        //设置在最后一张图片上显示进入体验按钮
        if (i == kPageCount) {
            imageView.userInteractionEnabled = YES;
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(MScreenW*0.15, MScreenH*0.82, MScreenW*0.7, 56)];
            [btn setTitle:@"立即进入" forState:UIControlStateNormal];
            [btn setTitleColor:MColorToRGB(0xFF4949) forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            
            CGFloat scanl ;
            if (isIPhone5()) {
                scanl = 0.133;
            }else if (isIPhone6){
                scanl = 0.11 ;
            }else if (isIPhone6Plus){
                scanl = 0.10 ;
            }
            btn.layer.cornerRadius = btn.frame.size.width*scanl  ;
            btn.layer.borderWidth = 1 ;
            btn.layer.borderColor = MColorToRGB(0xFF4949).CGColor;
            btn.layer.masksToBounds = YES ;
            [btn addTarget:self action:@selector(btn_Click:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
        }
    }
}


#pragma mark - ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat lastOffset_x = (kPageCount - 1.5)*self.scrollView.frame.size.width;
    
    scrollView.contentOffset.x > lastOffset_x ? [self.pageControl setHidden:YES] : [self.pageControl setHidden:NO];
    
    
    int index=fabs(self.scrollView.contentOffset.x)/self.scrollView.frame.size.width;
    self.pageControl.currentPage=index;
}


-(void)buttonpress:(UITapGestureRecognizer *)tap
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    CGPoint scrollPoint = CGPointMake(pageWidth, 0);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}


-(void)btn_Click:(UIButton *)btn
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MHGuide_page"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate enterMianUI];
}



@end
