//
//  OverlayViewC.m
//  ScannerDit
//
//  Created by zch on 16/12/26.
//  Copyright © 2016年 ShakeDetector. All rights reserved.
//

#import "OverlayViewC.h"
#import <objc/runtime.h>

#define LogoImageViewWidth 39.5
#define LogoImageViewHeight 6


@interface SCViewFinderBase

@end

@interface SCViewFinderBase (RNXDrawLogo)

- (BOOL)shouldDrawLogo;

@end

@implementation SCViewFinderBase (RNXDrawLogo)

- (BOOL)shouldDrawLogo {
    return NO;
}

@end

@interface OverlayViewC ()

@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation OverlayViewC

- (instancetype)init
{
    if (self = [super init]) {
        self.guiStyle = SBSGuiStyleNone;
        [self setBeepEnabled:NO];
        [self setVibrateEnabled:NO];
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LogoImageViewWidth, LogoImageViewHeight)];
        self.logoImageView.image = [UIImage imageNamed:@"scandit_logo"];
        self.logoImageView.tintColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLogoPosition:(CGPoint)position
{
    [self.logoImageView removeFromSuperview];
    [self.logoImageView setFrame:CGRectMake(position.x - LogoImageViewWidth, position.y - LogoImageViewHeight, LogoImageViewWidth, LogoImageViewHeight)];
    [self.view addSubview:self.logoImageView];
}

@end
