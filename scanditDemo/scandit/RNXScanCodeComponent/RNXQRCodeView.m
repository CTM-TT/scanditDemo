//
//  ScanBarCodeView.m
//  ScannerDit
//
//  Created by zch on 16/12/24.
//  Copyright © 2016年 ShakeDetector. All rights reserved.
//

#import "RNXQRCodeView.h"
#import "OverlayViewC.h"
#import "RNXCodeScanResult.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface RNXCodeScanResult (RNXScandit)
+ (instancetype)resultFromSBSCode:(SBSCode *)code;
@end

@implementation RNXCodeScanResult (RNXScandit)

+ (instancetype)resultFromSBSCode:(SBSCode *)code {
    if (!code) {
        return nil;
    }
    RNXCodeScanResult *result = [RNXCodeScanResult new];
    result.type = code.symbologyString;
    result.data = code.data;
    return result;
}

@end

@interface RNXQRCodeView() <SBSScanDelegate>

@property (nonatomic,strong) SBSBarcodePickerView *pickerView;

@property (nonatomic,strong) OverlayViewC *overlay;

@property (nonatomic , strong) AVCaptureDevice *device;

@end


@implementation RNXQRCodeView

- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.pickerView];
        [self setupSettings];
        OverlayViewC *overlay= [[OverlayViewC alloc] init];
        self.pickerView.viewController.overlayController = overlay;
        self.overlay = overlay;
        [self setAllSettingsOnPicker:self.pickerView];
        //添加自定义遮盖
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 启动会话
            [self.pickerView startScanning];
            
        });
        
    }
    return self;
}


/**init overlayView  hotSpot*/
- (void)setAllSettingsOnPicker:(SBSBarcodePickerView *)picker {
    [picker.viewController setAutoFocusOnTapEnabled:YES];
    picker.viewController.overlayController.guiStyle = SBSGuiStyleNone;
    [picker.viewController.overlayController setViewfinderPortraitWidth:0.7 height:0.4];
    [picker.viewController.overlayController setVibrateEnabled:NO];
    [picker.viewController.overlayController setBeepEnabled:NO];
    [picker setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
}

/**
 懒加载view
**/
- (SBSBarcodePickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[SBSBarcodePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _pickerView.viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getconnect) name:AVCaptureSessionDidStartRunningNotification object:nil];
        _pickerView.scanDelegate  = self;
    }
    return _pickerView;
}
- (void)getconnect
{
    /**connect video device*/
    if (_rnxScanCodeViewDelegate && [_rnxScanCodeViewDelegate respondsToSelector:@selector(RNXScanCodeViewHasConnectedToDevice)]) {
        [_rnxScanCodeViewDelegate RNXScanCodeViewHasConnectedToDevice];
    }
#if DEBUG
    NSLog(@"---------------connected----------------");
#endif
}
/**init settings*/
- (void)setupSettings
{
    self.pickerView.EAN8 = YES;
    self.pickerView.EAN13 = YES;
    self.pickerView.UPC12 = YES;
    self.pickerView.UPCE = YES;
    self.pickerView.code39 = YES;
    self.pickerView.code93 = YES;
    self.pickerView.code128 = YES;
    self.pickerView.PDF417 = YES;
    self.pickerView.datamatrix = YES;
    self.pickerView.QR = YES;
    self.pickerView.ITF = YES;
    self.pickerView.MSIPlessey = YES;
    self.pickerView.GS1Databar = YES;
    self.pickerView.GS1DatabarExpanded = YES;
    self.pickerView.codabar = YES;
    self.pickerView.aztec = YES;
    self.pickerView.twoDigitAddOn = YES;
    self.pickerView.fiveDigitAddOn = YES;
    self.pickerView.code11 = YES;
    self.pickerView.maxiCode = YES;
    self.pickerView.microPDF417 = YES;
    self.pickerView.code25 = YES;
    self.pickerView.uiVibrate = NO;
    self.pickerView.uiBeep = NO;
    self.pickerView.viewController.pinchToZoomEnabled = YES;
    self.pickerView.viewController.autoFocusOnTapEnabled = YES;

}

/**Barcode delegate*/
- (void)barcodePicker:(SBSBarcodePicker *)picker didScan:(SBSScanSession *)session
{
#if DEBUG
    for (SBSCode *code in session.newlyRecognizedCodes) {
        NSLog(@"newlyRecognizedCodes ==>%@，%@，%@",code.symbologyString,code.symbologyName,code.data);
        
    }
#endif
    if (_rnxScanCodeViewDelegate && [_rnxScanCodeViewDelegate respondsToSelector:@selector(RNXScanCodeView:ScanningComplete:)]) {
        [_rnxScanCodeViewDelegate RNXScanCodeView:self ScanningComplete:[RNXCodeScanResult resultFromSBSCode:[session.newlyRecognizedCodes lastObject]]];
    }
}
/** 获取摄像设备 */
- (AVCaptureDevice *)device
{
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self.pickerView stopScanning];

    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}


#pragma mark - 接口

- (void)setScanning:(BOOL)scanning
{
    if (scanning) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 启动会话
            [self.pickerView startScanning];
        });
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.pickerView stopScanning];
        });
    }
}


- (void)setTorchMode:(NSString *)torchMode
{
    if (torchMode && torchMode.length>0) {
        if ([torchMode isEqualToString:@"on"]) {
            [self turnOnLight:YES];
        }else if([torchMode isEqualToString:@"off"]){
            [self turnOnLight:NO];
        }
    }else{
#if DEBUG
        NSLog(@"开关字符不正确");
#endif
    }
}

#pragma mark 设置logo位置  需要计算
-(void)setLogoPosition:(CGPoint)logoPosition
{
    _logoPosition = logoPosition;
    [self.overlay setLogoPosition:logoPosition];
    [self.overlay resetUI];
}
#pragma mark 缩放比例
- (void)setZoomScaled:(float)zoomScaled
{
    _zoomScaled = zoomScaled;
    [self.pickerView.viewController setRelativeZoom:zoomScaled];
}
#pragma mark 设置扫描识别区域
- (void)setScanArea:(CGRect)scanArea
{
    _scanArea = scanArea;
    SBSScanSettings *scansettings = [self currentScanSettingsWithscanArea:_scanArea];
    [self.pickerView.viewController applyScanSettings:scansettings completionHandler:^{
        NSLog(@"================>设置完成？不完成？ 测试一下");
    }];
    /*dispatch_semaphore_t signal = dispatch_semaphore_create(1); //传入值必须 >=0, 若传入为0则阻塞线程并等待timeout,时间到后会执行其后的语句
    dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC);
    
    dispatch_semaphore_wait(signal, overTime); //signal 值 -1
    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        SBSScanSettings*scansetting = [self.pickerView valueForKeyPath:@"scanSettings"];
        scansetting.restrictedAreaScanningEnabled = YES;
        scansetting.scanningHotSpot = CGPointMake(scanArea.size.width/2+scanArea.origin.x,scanArea.size.height/2+scanArea.origin.y);
        [scansetting setActiveScanningArea:scanArea];
        [self.pickerView setValue:[NSNumber numberWithBool:NO] forKeyPath:@"settingsChanged"];
        [self.pickerView setValue:scansetting forKeyPath:@"scanSettings"];
        [self.pickerView.viewController applyScanSettings:scansetting completionHandler:^{
            [self.pickerView setValue:[NSNumber numberWithBool:NO] forKeyPath:@"settingsChanged"];
        }];
        [self.pickerView setValue:[NSNumber numberWithBool:YES] forKeyPath:@"settingsChanged"];
        dispatch_semaphore_signal(signal); //signal 值 +1
    });*/
//    [self setNeedsLayout];
}


- (SBSScanSettings*)currentScanSettingsWithscanArea:(CGRect)scanArea {
    
    // Configure the barcode picker through a scan settings instance by defining which
    // symbologies should be enabled.
    SBSScanSettings* scanSettings = [SBSScanSettings defaultSettings];
    
    // prefer backward facing camera over front-facing cameras.
    scanSettings.cameraFacingPreference = SBSCameraFacingDirectionBack;
    
    // enable/disable 1D symbologies based on the current settings
    [scanSettings setSymbology:SBSSymbologyEAN13
                       enabled:YES];
    
    [scanSettings setSymbology:SBSSymbologyUPC12
                       enabled:YES];
    
    [scanSettings setSymbology:SBSSymbologyEAN8
                       enabled:YES];
    
    [scanSettings setSymbology:SBSSymbologyUPCE
                       enabled:YES];
    
    [scanSettings setSymbology:SBSSymbologyTwoDigitAddOn
                       enabled:NO];
    
    [scanSettings setSymbology:SBSSymbologyFiveDigitAddOn
                       enabled:NO];
    
    [scanSettings setSymbology:SBSSymbologyCode39
                       enabled:YES];
    
    [scanSettings setSymbology:SBSSymbologyCode93
                       enabled:YES];
    
    [scanSettings setSymbology:SBSSymbologyCode128
                       enabled:YES];
    
    [scanSettings setSymbology:SBSSymbologyMSIPlessey
                       enabled:YES];
    
    [scanSettings setSymbology:SBSSymbologyITF
                       enabled:YES];
    [scanSettings setSymbology:SBSSymbologyCode25
                       enabled:YES];
    [scanSettings setSymbology:SBSSymbologyCodabar
                       enabled:YES];
    [scanSettings setSymbology:SBSSymbologyCode11
                       enabled:YES];
    [scanSettings setSymbology:SBSSymbologyGS1Databar
                       enabled:YES];
    
    [scanSettings setSymbology:SBSSymbologyGS1DatabarExpanded
                       enabled:YES];
    [scanSettings setSymbology:SBSSymbologyGS1DatabarLimited
                       enabled:YES];
    // enable/disable 2D symbologies based on the current settings
    [scanSettings setSymbology:SBSSymbologyQR
                       enabled:YES];
    
    [scanSettings setSymbology:SBSSymbologyAztec
                       enabled:YES];
    
    [scanSettings setSymbology:SBSSymbologyDatamatrix
                       enabled:YES];
    
    [scanSettings setSymbology:SBSSymbologyPDF417
                       enabled:YES];
    [scanSettings setSymbology:SBSSymbologyMicroPDF417
                       enabled:YES];
    [scanSettings setSymbology:SBSSymbologyMaxiCode
                       enabled:YES];
    [scanSettings setSymbology:SBSSymbologyRM4SCC
                       enabled:YES];
    [scanSettings setSymbology:SBSSymbologyKIX
                       enabled:YES];
    
    SBSChecksum checksum = SBSChecksumMod10;
    
    NSSet *checksums = [NSSet setWithObject:[NSNumber numberWithInteger:checksum]];
    [scanSettings settingsForSymbology:SBSSymbologyMSIPlessey].checksums = checksums;
    

    SBSSymbologySettings *dataMatrixSettings =
    [scanSettings settingsForSymbology:SBSSymbologyDatamatrix];
    dataMatrixSettings.colorInvertedEnabled = YES;
    [dataMatrixSettings setExtension:SBSSymbologySettingsExtensionTiny
                             enabled:YES];
    scanSettings.restrictedAreaScanningEnabled = YES;
    scanSettings.scanningHotSpot = CGPointMake(scanArea.size.width/2+scanArea.origin.x,scanArea.size.height/2+scanArea.origin.y);
    if (scanSettings.restrictedAreaScanningEnabled) {
        [scanSettings setActiveScanningArea:scanArea];
    }

    SBSSymbologySettings *qrSettings =
    [scanSettings settingsForSymbology:SBSSymbologyQR];
    qrSettings.colorInvertedEnabled = YES;

    return scanSettings;
    
}


#pragma mark - 闪光灯
- (void)turnOnLight:(BOOL)on {
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([_device hasTorch]) {
        [_device lockForConfiguration:nil];
        if (on) {
            [_device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [_device setTorchMode: AVCaptureTorchModeOff];
        }
        [_device unlockForConfiguration];
    }
}

/**
 开始扫描
 */
-(void)startScanning
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.pickerView startScanning];
    });
    
}
/**
 停止扫描
 */
- (void)stopScanning
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.pickerView stopScanning];
    });
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureSessionDidStartRunningNotification object:nil];
}

@end
