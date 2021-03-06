//
//  SGASTouchTrackingApplication.m
//  SGASScreenRecorder
//
//  Created by Shmatlay Andrey on 21.06.13.
//  Edited by Aleksandr Gusev on 23/10/14
//

#import "SGASTouchTrackingApplication.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const SGASTouchTrackingApplicationTouchEventNotification = @"SGASApplicationTouchEventNotification";
NSString * const SGASTouchTrackingApplicationTouchEventKey = @"SGASApplicationTouchEventKey";

@implementation SGASTouchTrackingApplication

#pragma mark - NSObject

- (Class)class {
    return class_getSuperclass(object_getClass(self));
}

#pragma mark - UIApplication

- (void)sendEvent:(UIEvent *)event {
    BOOL touchEvent = event.type == UIEventTypeTouches;
    if (touchEvent) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SGASTouchTrackingApplicationTouchEventNotification
                                                            object:self
                                                          userInfo:@{SGASTouchTrackingApplicationTouchEventKey: event}];
    }
    
    // the following fiddling with objc_super is to ensure that we call the
    // superclass implementation on the actual superclass of the application object
    // when this method will me 'mixed-in', and not on UIApplication,
    // which is the superclass of SGASTouchTrackingApplication at compile time
    struct objc_super sup;
    sup.receiver = self;
    sup.super_class = class_getSuperclass(object_getClass(self));
    ((void(*)(struct objc_super *, SEL, UIEvent *))objc_msgSendSuper)(&sup, _cmd, event);
}

@end

NS_ASSUME_NONNULL_END
