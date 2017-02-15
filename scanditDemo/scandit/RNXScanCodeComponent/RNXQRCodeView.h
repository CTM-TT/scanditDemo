//
//  ScanBarCodeView.h
//  ScannerDit
//
//  Created by zch on 16/12/24.
//  Copyright © 2016年 ShakeDetector. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNXScanCodeView.h"

@interface RNXQRCodeView : UIView <RNXScanCodeView>


@property (nonatomic,weak) id<RNXScanCodeViewDelegate> rnxScanCodeViewDelegate;

@property (nonatomic,assign) BOOL scanning;

@property (nonatomic,assign) CGPoint logoPosition;

@property (nonatomic,assign) float zoomScaled;

@property (nonatomic,assign) CGRect scanArea;

@property (nonatomic,copy) NSString *torchMode;


/**
 开始扫描
 */
- (void)startScanning;
/**
 停止扫描
 */
- (void)stopScanning;
@end
