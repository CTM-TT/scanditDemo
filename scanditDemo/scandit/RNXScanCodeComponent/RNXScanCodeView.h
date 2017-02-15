//
//  RNXScanCodeView.h
//  Pods
//
//  Created by EmingK on 2017/2/1.
//
//

#ifndef RNXScanCodeView_h
#define RNXScanCodeView_h

#import "RNXCodeScanResult.h"

@protocol RNXScanCodeView;

@protocol RNXScanCodeViewDelegate <NSObject>

/**
 * Invoked on a Barcode is successfully recognized.
 */
@required
- (void)RNXScanCodeView:(UIView<RNXScanCodeView> *)scanCodeView ScanningComplete:(RNXCodeScanResult *)data;

/**
 * Invoked on a ScanCodeView has connected to camera.
 */
@optional
- (void)RNXScanCodeViewHasConnectedToDevice;

@end

@protocol RNXScanCodeView <NSObject>

@property (nonatomic, weak) id<RNXScanCodeViewDelegate> rnxScanCodeViewDelegate;
@property (nonatomic,assign) float zoomScaled;
@property (nonatomic,assign) CGRect scanArea;
@property (nonatomic,copy) NSString *torchMode;

- (void)startScanning;
- (void)stopScanning;

@end

#endif /* RNXScanCodeView_h */
