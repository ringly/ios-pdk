//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 1/28/15.

#if TARGET_OS_IPHONE
@import UIKit;
#endif

#import "PDKCategories.h"
#import "PDKClient.h"
#import "PDKPin.h"

@interface PDKClient()
@property (nonatomic, assign) BOOL configured;
@property (nonatomic, copy, readwrite) NSString *appId;
@property (nonatomic, copy) NSString *clientRedirectURLString;
@property (nonatomic, copy) NSString *oauthToken;
@property (nonatomic, assign, readwrite) BOOL authorized;

@end

@implementation PDKClient

+ (instancetype)sharedInstance
{
    static PDKClient *gClientSDK;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gClientSDK = [[self class] new];
    });
    return gClientSDK;
}

+ (void)configureSharedInstanceWithAppId:(NSString *)appId
{
    [[self sharedInstance] setAppId:appId];
    [[self sharedInstance] setClientRedirectURLString:[NSString stringWithFormat:@"pdk%@", appId]];
    [[self sharedInstance] setConfigured:YES];
}

- (NSString *)appId
{
    NSAssert(self.configured == YES, @"PDKClient must be configured before use. Call [PDK configureShareInstanceWithAppId:]");
    return _appId;
}

- (BOOL)handleCallbackURL:(NSURL *)url
{
    BOOL handled = NO;
    NSString *urlScheme = [url scheme];
    if ([urlScheme isEqualToString:self.clientRedirectURLString]) {
        // get the oauth token
        NSDictionary *parameters = [NSDictionary _PDK_dictionaryWithQueryString:[url query]];
        NSString *method = parameters[@"method"];
        
        if ([method isEqualToString:@"pinit"]) {
            if (parameters[@"error"]) {
                [PDKPin callUnauthFailureWithError:parameters[@"error"]];
            } else {
                [PDKPin callUnauthSuccess];
            }
            handled = YES;
        }
    }
    return handled;
}

@end
