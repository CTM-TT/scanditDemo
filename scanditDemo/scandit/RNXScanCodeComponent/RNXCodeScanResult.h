//
//  RNXCodeScanResult.h
//  RNXScanCodeComponent
//
//  Created by zch on 16/12/31.
//  Copyright © 2016年 RNX Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBSCode,AVMetadataMachineReadableCodeObject;
@interface RNXCodeScanResult : NSObject
/**
 * Code scan result.
 * For different underlying code scanners, provide a wrapper to pass uniform data to our delegates.
 */
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *data;

@end
