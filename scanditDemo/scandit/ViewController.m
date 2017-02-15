//
//  ViewController.m
//  scandit
//
//  Created by zch on 17/2/14.
//  Copyright © 2017年 RNX Team. All rights reserved.
//

#import "ViewController.h"
#import "RNXQRCodeView.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<RNXScanCodeViewDelegate>
@property (nonatomic,strong) RNXQRCodeView *codeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.codeView =  [self getscanview];
    [self.codeView setZoomScaled:0];
    CGRect scanarea = CGRectMake(0.1, 0.20, 0.8, screenWidth*0.8/screenHeight);
    [self.codeView setScanArea:scanarea];
    [self.view addSubview:self.codeView];
    
}
- (RNXQRCodeView *)getscanview
{
    RNXQRCodeView *codeView = [[RNXQRCodeView alloc] init];
    codeView.frame = [UIScreen mainScreen].bounds;
    codeView.rnxScanCodeViewDelegate = self;
    return codeView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 * Invoked on a Barcode is successfully recognized.
 */
- (void)RNXScanCodeView:(UIView<RNXScanCodeView> *)scanCodeView ScanningComplete:(RNXCodeScanResult *)data{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sweep code results" message:data.data preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
}

/**
 * Invoked on a ScanCodeView has connected to camera.
 */
- (void)RNXScanCodeViewHasConnectedToDevice{
    
}

@end
