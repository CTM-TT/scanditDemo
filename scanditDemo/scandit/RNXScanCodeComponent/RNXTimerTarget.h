//
//  RNXTimerTarget.h
//  Pods
//
//  Created by zch on 17/1/6.
//
//

#import <Foundation/Foundation.h>

@interface RNXTimerTarget : NSObject

@property (nonatomic,weak) id target;

@property (nonatomic,assign) SEL selector;

@property (nonatomic,strong,readonly) NSTimer *timer;



+(instancetype)timerTargetWithDuration:(NSTimeInterval)interval target:(id)target action:(SEL)selector userInfo:(NSDictionary *)dictionary repeats:(BOOL)yesOrNo;



- (void)firTimer;

@end
