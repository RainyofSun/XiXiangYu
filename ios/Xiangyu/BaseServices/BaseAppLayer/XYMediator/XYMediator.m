//
//  XYMediator.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/6/5.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYMediator.h"
#import <objc/runtime.h>

@interface XYMediator ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

static XYMediator *mediator = nil;

@implementation XYMediator

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[XYMediator alloc] init];
    });
    return mediator;
}

- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion {
    NSMutableDictionary *params = @{}.mutableCopy;
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }

    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:XYMediatorNative]) {
        return @(NO);
    }
    // 针对URL的路由处理就取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
    id result = [self performTarget:url.host action:actionName params:params shouldCacheTarget:NO];
    
    if (completion) {
        if (result) {
            completion(@{XYMediatorBlockResult:result});
        } else {
            completion(nil);
        }
    }
    return result;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    
    NSString *targetClassString = XYMediatorTargetName(targetName);
    
    NSString *actionString = XYMediatorActionName(actionName);
    
    Class targetClass;
    
    NSObject *target = self.cachedTarget[targetClassString];
    
    if (target == nil) {
        targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }
    
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
    
        [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
        return nil;
    }
    
    if (shouldCacheTarget) {
        
        self.cachedTarget[targetClassString] = target;
    }
    
    if ([target respondsToSelector:action]) {
        
        return [self safePerformAction:action target:target params:params];
    } else {
        // 有可能target是Swift对象
        actionString = [NSString stringWithFormat:@"%@%@WithParams:", XYMediatorActionPrefix, actionName];
        action = NSSelectorFromString(actionString);
        if ([target respondsToSelector:action]) {
            
            return [self safePerformAction:action target:target params:params];
        } else {
            
            SEL action = NSSelectorFromString(XYMediatorActionName(XYMediatorNotFoundAction));
            if ([target respondsToSelector:action]) {
                
                return [self safePerformAction:action target:target params:params];
                
            } else {
                
                [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
                [self.cachedTarget removeObjectForKey:targetClassString];
                return nil;
            }
        }
    }
}

- (void)releaseCachedTargetWithTargetName:(NSString *)targetName {
    [self.cachedTarget removeObjectForKey:XYMediatorTargetName(targetName)];
}

#pragma mark - private methods
- (void)NoTargetActionResponseWithTargetString:(NSString *)targetString selectorString:(NSString *)selectorString originParams:(NSDictionary *)originParams {
    
    SEL action = NSSelectorFromString(XYMediatorActionName(XYMediatorNoResponeAction));
    
    NSObject *target = [[NSClassFromString(XYMediatorTargetName(@"Base")) alloc] init];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    params[XYMediatorNoResponeParams] = originParams;
    params[XYMediatorNoResponeTarget] = targetString;
    params[XYMediatorNoResponeSelector] = selectorString;
    
    [self safePerformAction:action target:target params:params];
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params {
    NSMethodSignature * methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    
}

#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTarget {
    if (!_cachedTarget) {
        _cachedTarget = @{}.mutableCopy;
    }
    return _cachedTarget;
}
@end
