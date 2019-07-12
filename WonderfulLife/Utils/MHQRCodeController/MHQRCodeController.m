//
//  MHQRCodeController.m
//  WonderfulLife
//
//  Created by ikrulala on 2017/9/23.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//
#import "MHQRCodeController.h"
#import "MHMineInputFieldController.h"


#import "JFAuthorizationStatusManager.h"
#import "MHHUDManager.h"

#import <AVFoundation/AVFoundation.h>
#import "MHMacros.h"
#import "UIViewController+HLNavigation.h"



#import "MHQRCodeController+jumpType.h"
#import "MHStoreOrdersConsumptionViewInputController.h"
#import "UIViewController+PresentLoginController.h"
#import "MHMerchantOrderDetailController.h"


// 用于扫码收款
#import "MHMineMerchantPayModel.h"


#define QRCodeWidth  275.0   //正方形二维码的边长

@interface MHQRCodeController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *QRTipsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *scanLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeScanAreaBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;
@property (weak, nonatomic) IBOutlet UIView *scanView;

@property (nonatomic, strong) UIBarButtonItem  *backItem;

@property (nonatomic, strong) UIBarButtonItem  *rightBarItem;

// 会话
@property (nonatomic, strong) AVCaptureSession *session;
// 输入设备
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
// 输出设备
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
// 预览图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
// 会话图层
@property (nonatomic, strong) CALayer *drawLayer;
// 扫描完成回调block
@property (copy, nonatomic) void (^completionBlock) (id);

@property (strong,nonatomic,readwrite)MHQRCodeViewModel *viewModel;



@property (nonatomic, strong) MHMineMerchantPayModel  *payModel;


@end

@implementation MHQRCodeController


- (instancetype)initWithParma:(NSMutableDictionary *)parma CodeType:(MHQRCodeType)type {
    if ([super init]) {
        self.codeType = type;
        self.parma = parma ;
    }return self;
}

#pragma mark - Life Cycle
- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)setCodeType:(MHQRCodeType)codeType{
    if(_codeType != codeType){
        _codeType = codeType;
        self.viewModel.type = _codeType;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    if (![JFAuthorizationStatusManager authorizationStatusMediaTypeVideoIsOpen]) {
        NSString *title = @"请在iphone的【设置】-【隐私】-【相机】中，允许美好志愿访问你的摄像头。";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if(self.codeType != MHQRCodeType_OrderCo && self.codeType != MHQRCodeType_Collection){
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }];
        [alert addAction:determine];
        [self presentViewController:alert animated:YES completion:nil];
    }

    self.QRTipsLabel.layer.cornerRadius = 20;
    self.QRTipsLabel.layer.masksToBounds = YES;
    self.QRTipsLabel.layer.borderWidth = 1;
    self.QRTipsLabel.layer.borderColor = MColorToRGB(0X8492A6).CGColor;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self bindRACEvents];
    
    [self setSessionConfig];
    
    
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if(self.view.window && !self.viewModel.isRequesting){
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.orderDetailView){
                    self.orderDetailView.hidden = NO;
                }else{
                    [self startScan];
                }
                
            });
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    if(self.orderDetailView){
        self.orderDetailView.hidden = NO;
    }else{
        [self startScan];
    }
    if (self.codeType == MHQRCodeType_OrderCo || self.codeType == MHQRCodeType_Collection) {
        
        self.navigationItem.rightBarButtonItem  = [self rightBarItemWithTitle:@"手动输码"];
        [self hl_setNavigationItemColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = [self backItemWithImageName:@"navi_back"];
        self.title =  self.codeType == MHQRCodeType_OrderCo ? @"订单消费 " : @"扫码收款";
        
    }else{
        
        [self hl_setNavigationItemColor:[UIColor blackColor]];
        self.navigationItem.leftBarButtonItem = [self backItemWithImageName:@"navi_back_white"];
    }
    //标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:MColorTitle}];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hl_setNavigationItemColor:[UIColor whiteColor]];
    [self hl_setNavigationItemLineColor:[UIColor clearColor]];
    [self stopScan];
}

- (void)photoPickerController {
    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
    pc.delegate = self;
    pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pc animated:YES completion:^{
        [JFAuthorizationStatusManager authorizationType:JFAuthorizationTypeAlbum target:pc];
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bindRACEvents {
    
    @weakify(self);

    [self.viewModel.showHUDSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [MHHUDManager show];
        }else {
            [MHHUDManager dismiss];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![self.session isRunning]) {
                    [self.session startRunning];
                }
                [self startAnimation];
            });
        }
    }];
    [self.viewModel.compleSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [MHHUDManager dismiss];
        [self jumpToPageWithQrcodeType:self.viewModel.qrcodeType infor:x];
        
    }];
    
    [self.viewModel.orderCostCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self closeOrderCostView];
        MHMerchantOrderDetailController *vc = [MHMerchantOrderDetailController new];
        vc.controlType = MHMerchantOrderDetailControlTypeMerchant;
        vc.order_no = self.viewModel.order_no;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [[self.viewModel.orderCostCommand errors] subscribeNext:^(NSError * _Nullable x) {
        if(self.view.window){
            [MHHUDManager showErrorText:x.userInfo[@"errmsg"]];
        }
    }];
    
    
    
}

#pragma mark - 相机代理
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    CIContext *context = [[CIContext alloc] init];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    CIImage *imageCI = [[CIImage alloc] initWithImage:image];
    NSArray<CIFeature *> *features = [detector featuresInImage:imageCI];
    CIQRCodeFeature *codef = (CIQRCodeFeature *)features.firstObject;
    
    
    NSString *result = codef.messageString;
    if(!result || result.length == 0){
        return;
    }
    //获取我们要的结果，如果获取不到，则是扫描到不是我们规定的码，如果有值，则是我们要的码
    NSString *qrcodeValue = [self.viewModel analyticQrcodeStringValue:result];
    //判断一下权限，有些码没有权限或者入口不对，权限也不行
    if(![self.viewModel checkScanLimit]){
       
        [MHHUDManager showText:@"无法识别" Complete:^{
          
        }];
        return;
    }
    //不是我们要的结果
    if(!qrcodeValue || qrcodeValue.length == 0){
        if(result && ([result hasPrefix:@"http://"] || [result hasPrefix:@"https://"])){
            if([UIDevice currentDevice].systemVersion.floatValue >= 10.0){
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:result]]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success) {
                       
                    }];
                }
            }else{
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:result]]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
                }
            }
            return;
        }
        if (_completionBlock) {
            _completionBlock(result);
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(reader:didScanResult:)]) {
            [self.delegate reader:self didScanResult:result];
        }
        [MHHUDManager showErrorText:@"无法识别"];
        return;
        
        
    }
    //可以根据qrcodeType分别对不同的类型作处理
    //订单消费调另外的接口
    if(self.viewModel.type == MHQRCodeType_OrderCo && self.viewModel.qrcodeType == MHQrcode_scanTypeCouponOrder){
        [self.viewModel.showHUDSubject sendNext:@1];
        [self.viewModel.orderDetailCommand execute:qrcodeValue];
    }else{
        [self.viewModel.showHUDSubject sendNext:@1];
        [self.viewModel.analyticQRCodeCommand execute:result];
    }

    if (_completionBlock) {
        _completionBlock(result);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reader:didScanResult:)]) {
        [self.delegate reader:self didScanResult:result];
    }
    
    

}


#pragma mark - Action

- (void)rightBarItemAction {
     if (self.codeType == MHQRCodeType_OrderCo) {
         
         MHStoreOrdersConsumptionViewInputController *ordersConsumVC = [[MHStoreOrdersConsumptionViewInputController alloc] initWithNibName:@"MHStoreOrdersConsumptionViewInputController" bundle:nil];
         [self.navigationController pushViewController:ordersConsumVC animated:YES];
         
     }else if (self.codeType == MHQRCodeType_Collection) {
         MHMineInputFieldController * vc = [[MHMineInputFieldController alloc] initWithInputType:MHMineInputFieldType_InputQR parma:self.parma];
         [self.navigationController pushViewController:vc animated:YES];
     }else{
//         [self photoPickerController];
     }
}


- (void)setCompletionWithBlock:(void (^) (id resultAsString))completionBlock{
    self.completionBlock = completionBlock;
}

- (void)setSessionConfig{
    // 1.判断是否能够将输入添加到会话中
    if (![self.session canAddInput:self.deviceInput]) {
        
        return;
    }
    
    // 2.判断是否能够将输出添加到会话中
    if (![self.session canAddOutput:self.output]) {
        return;
    }
    
    // 3.将输入和输出都添加到会话中
    [self.session addInput:self.deviceInput];
    
    [self.session addOutput:self.output];
    
    // 4.设置输出能够解析的数据类型
    // 注意: 设置能够解析的数据类型, 一定要在输出对象添加到会员之后设置, 否则会报错
    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 5.添加预览图层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    // 添加绘制图层
    [self.previewLayer addSublayer:self.drawLayer];
    
    // 6.告诉session开始扫描
    [self.session startRunning];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startAnimation];
    });
    
    //要在startRunning 之后再设置，startRunning之前设置不准确
    
    CGRect intertRect = [self.previewLayer metadataOutputRectOfInterestForRect:self.scanView.frame];
    self.output.rectOfInterest = intertRect;
}

- (void)startScan {
    if (![self.session isRunning] && !self.viewModel.isRequesting) {
        [self.session startRunning];
    }
    [self startAnimation];
    
}

- (void)stopScan {
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    [self stopAnimation];
}

- (void)startAnimation {
    
    [self.view.layer removeAllAnimations];
    [self.scanLineView.layer removeAllAnimations];
    
    self.QRCodeScanAreaBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:3.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.QRCodeScanAreaBottomConstraint.constant = self.constraintHeight.constant;
        [UIView setAnimationRepeatCount:MAXFLOAT];
        [self.view layoutIfNeeded];
    } completion:nil];
}

// 停止动画
- (void)stopAnimation
{
    [self.view.layer removeAllAnimations];
    [self.scanLineView.layer removeAllAnimations];
}

/**
 *  当从二维码中获取到信息时，就会调用下面的方法
 *
 *  @param captureOutput   输出对象
 *  @param metadataObjects 信息
 *  @param connection connection
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 0.清空图层
    [self clearCorners];
    
    if (metadataObjects.count == 0 || metadataObjects == nil) {
        return;
    }
    
    // 1.获取扫描到的数据
    // 注意: 要使用stringValue
    
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects lastObject];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode] && [metadataObj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            
            // 扫描结果
            NSString *result = [metadataObjects.lastObject stringValue];
            NSLog(@"二维码扫描结果：%@",result);
            
            //获取我们要的结果，如果获取不到，则是扫描到不是我们规定的码，如果有值，则是我们要的码
            NSString *qrcodeValue = [self.viewModel analyticQrcodeStringValue:result];
            //判断一下权限，有些码没有权限或者入口不对，权限也不行
            if(![self.viewModel checkScanLimit]){
                // 停止扫描
                [self stopScan];
                [MHHUDManager showText:@"无法识别" Complete:^{
                    [self startScan];
                }];
                return;
            }
            //不是我们要的结果
            if(!qrcodeValue || qrcodeValue.length == 0){
                if(result && ([result hasPrefix:@"http://"] || [result hasPrefix:@"https://"])){
                    // 停止扫描
                    [self stopScan];
                    if([UIDevice currentDevice].systemVersion.floatValue >= 10.0){
                        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:result]]){
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success) {
                                if(!success){
                                    [self startScan];
                                }
                            }];
                        }
                    }else{
                        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:result]]){
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
                        }else{
                            [self startScan];
                        }
                    }
                    return;
                }else{
                    if (_completionBlock) {
                        _completionBlock(result);
                    }
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(reader:didScanResult:)]) {
                        [self.delegate reader:self didScanResult:result];
                    }
                    // 停止扫描
                    [self stopScan];
                    [MHHUDManager showText:@"无法识别" Complete:^{
                        [self startScan];
                    }];
                    return;
                }
                
                
            }
            //可以根据qrcodeType分别对不同的类型作处理
            //订单消费调另外的接口
            if(self.viewModel.type == MHQRCodeType_OrderCo && self.viewModel.qrcodeType == MHQrcode_scanTypeCouponOrder){
                [self.viewModel.showHUDSubject sendNext:@1];
                [self.viewModel.orderDetailCommand execute:qrcodeValue];
            }else{
                [self.viewModel.showHUDSubject sendNext:@1];
                [self.viewModel.analyticQRCodeCommand execute:result];
            }
            
            if (_completionBlock) {
                _completionBlock(result);
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(reader:didScanResult:)]) {
                [self.delegate reader:self didScanResult:result];
            }

            // 停止扫描
            [self stopScan];
            
            
            return;
        }
    }
    
    
    // 2.获取扫描到的二维码的位置
    // 2.1转换坐标
    for (AVMetadataObject *object in metadataObjects) {
        // 2.1.1判断当前获取到的数据, 是否是机器可识别的类型
        if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            // 2.1.2将坐标转换界面可识别的坐标
            AVMetadataMachineReadableCodeObject *codeObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:object];
            // 2.1.3绘制图形
            [self drawCorners:codeObject];
        }
    }
}

/**
 *  画出二维码的边框
 *
 *  @param codeObject 保存了坐标的对象
 */
- (void)drawCorners:(AVMetadataMachineReadableCodeObject *)codeObject {
    if (codeObject.corners.count == 0) {
        return;
    }
    
    // 1.创建一个图层
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.lineWidth = 4;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    // 2.创建路径
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint point = CGPointZero;
    NSInteger index = 0;
    
    // 2.1移动到第一个点
    // 从corners数组中取出第0个元素, 将这个字典中的x/y赋值给point
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)codeObject.corners[index++], &point);
    [path moveToPoint:point];
    
    // 2.2移动到其它的点
    while (index < codeObject.corners.count) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)codeObject.corners[index++], &point);
        [path addLineToPoint:point];
    }
    // 2.3关闭路径
    [path closePath];
    
    // 2.4绘制路径
    layer.path = path.CGPath;
    
    // 3.将绘制好的图层添加到drawLayer上
    [self.drawLayer addSublayer:layer];
}

/**
 *  清除边线
 */
- (void)clearCorners {
    if (self.drawLayer.sublayers == nil || self.drawLayer.sublayers.count == 0) {
        return;
    }
    
    for (CALayer *subLayer in self.drawLayer.sublayers) {
        [subLayer removeFromSuperlayer];
    }
}


#pragma mark - Getter
- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureDeviceInput *)deviceInput {
    if (!_deviceInput) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    }
    return _deviceInput;
}

- (AVCaptureMetadataOutput *)output {
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
    }
    return _output;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.frame = [UIScreen mainScreen].bounds;
    }
    return _previewLayer;
}

- (CALayer *)drawLayer {
    if (!_drawLayer) {
        _drawLayer = [[CALayer alloc] init];
        _drawLayer.frame = [UIScreen mainScreen].bounds;
    }
    return _drawLayer;
}

- (UIBarButtonItem *)backItemWithImageName:(NSString *)imageName {
    if (!_backItem) {
        UIButton *backButton = [[UIButton alloc] init];
        [backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
        [backButton sizeToFit];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }return _backItem;
}

- (UIBarButtonItem *)rightBarItemWithTitle:(NSString *)title{
    if (!_rightBarItem) {
        _rightBarItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemAction)];
        _rightBarItem.tintColor = [UIColor blackColor];
    }return _rightBarItem ;
}

- (MHQRCodeViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [[MHQRCodeViewModel alloc] init];
    }
    return _viewModel;
}
@end
