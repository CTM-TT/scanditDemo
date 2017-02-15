//
//  RNXTimerTarget.m
//  Pods
//
//  Created by zch on 17/1/6.
//
//

#import "RNXTimerTarget.h"

@interface RNXTimerTarget(private)



@end

@implementation RNXTimerTarget

static RNXTimerTarget *_instance = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


+ (instancetype)timerTargetWithDuration:(NSTimeInterval)interval target:(id)target action:(SEL)selector userInfo:(NSDictionary *)dictionary repeats:(BOOL)yesOrNo
{
    RNXTimerTarget *timerTarget = [[RNXTimerTarget alloc] init];
    timerTarget.target = target;
    timerTarget.selector = selector;
    const char * timerQueueName = "timerQueue";
    dispatch_queue_t serialQueue = dispatch_queue_create(timerQueueName, DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        [timerTarget setTimer:[NSTimer timerWithTimeInterval:interval target:timerTarget selector:@selector(actionSelector) userInfo:dictionary repeats:yesOrNo]];
        [[NSRunLoop currentRunLoop] addTimer:timerTarget.timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3000]];
    });
    return timerTarget;
}

-(void)setTimer:(NSTimer *)timer
{
    _timer = timer;
}
- (void)actionSelector
{
    if (self.target) {
        [self.target performSelector:self.selector withObject:nil afterDelay:0];
    }
}

- (void)firTimer
{
    if (self.timer.isValid) {
        [self.timer invalidate];
        [self.timer fire];
    }
}
- (void)dealloc
{
    NSLog(@"timer Distroy");
}
@end
