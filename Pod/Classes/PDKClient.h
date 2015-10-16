//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 1/28/15.

@import Foundation;

/**
 *  Use the PDKClient to interact with the Pinterest SDK. Before making API calls
 *  the client must be configured with an appId. Once configured,
 *  authenticateWithPermissions:withSuccess:andFailure needs to be called to get the user's
 *  permission to access his/her account.
 *
 *  Once authenticated, calls can be made by passing in endpoints directly (using
 *  methods like getPath:parameters:success:failure:) or by using convience methods
 *  (like getPinsForBoard:success:failure)
 */
@interface PDKClient : NSObject

/**
 *  The assigned appId that is used to make API requests
 */
@property (nonatomic, readonly, copy) NSString *appId;

/**
 *  PDKClient is a singleton. This will return the one instance of the client.
 *
 *  @return A PDKClient object
 */
+ (instancetype)sharedInstance;

/**
 *  Before making API requests via the client, use this method to configure
 *  the client with an appId.
 *
 *  @param appId appId needed to make API requests
 */
+ (void)configureSharedInstanceWithAppId:(NSString *)appId;

#pragma mark - Authentication
/**
 *  After the user authorizes his/her Pinterest account, control switches back to the
 *  calling application. Placing a call to this method in application:handleOpenURL: will
 *  parse the oauth token out of the URL and call the successBlock or failureBlock that were
 *  passed into authenticateWithPermissions:withSuccess:andFailure. This method will also
 *  store the user's oauth token in the keychain.
 *
 *  @param url The URL that was passed into the application
 *
 *  @return YES if the URL was handled by PDKClient
 */
- (BOOL)handleCallbackURL:(NSURL *)url;

@end
