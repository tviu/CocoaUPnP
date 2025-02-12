// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "UPPEventSubscription.h"
#import "UPPEventServer.h"

@class UPPBasicService;

/**
 This class is responsible for managing service subscription objects.
 */
@interface UPPEventSubscriptionManager : NSObject <UPPEventServerDelegate>

/**
 An event server instance for service event callbacks.
 */
@property (strong, nonatomic) UPPEventServer *eventServer;

/**
 @return A shared event subscription manager instance, with the `NSURLSession`
 set to `[NSURLSession sharedSession]`.
 */
+ (instancetype)sharedManager;

/**
 Instantiate a new instance of event subscription manager with an NSURLSession.

 @param session The session to use during network calls.

 @return A newly allocated and initialised subscription manager instance.
 */
- (instancetype)initWithSession:(NSURLSession *)session;

/**
 Subscribe an observer to UPnP service events.

 @param observer   The observer object, which conforms to
 `UPPEventSubscriptionDelegate`.
 @param service    The service to subscribe to.
 @param completion A block to run when the subscription call finishes. Returns a
 BOOL corresponding to wether the call succeeded or failed.
 */
- (void)subscribeObserver:(id<UPPEventSubscriptionDelegate>)observer toService:(UPPBasicService *)service completion:(void(^)(UPPEventSubscription *subscription, NSError *error))completion;

/**
 Renew a current subscription.

 @param subscription The subscription to renew.
 @param completion   A block which is run when the subscription call finishes.
 Returns the new subscription identifier, the new expiry date, or if renewing
 failed, an error object.
 */
- (void)renewSubscription:(UPPEventSubscription *)subscription completion:(void(^)(NSString *subscriptionID, NSDate *expiryDate, NSError *error))completion;

/**
 Renew an expired subscription. This differs from renewing an existing
 subscription, as the service is essentially subscribed as if new. However, any
 existing observers are kept around and therefore do not need re-adding.

 @param subscription The subscription to renew.
 @param completion   A block which is run when the subscription call finishes.
 Returns the new subscription identifier, the new expiry date, or if renewing
 failed, an error object.
 */
- (void)subscriptionExpired:(UPPEventSubscription *)subscription completion:(void(^)(NSString *subscriptionID, NSDate *expiryDate, NSError *error))completion;

/**
 Unsubscribe an observer from a service. If there are no more observers, then
 the subscription object unsubscribes from service notifications and the
 subscription object is destroyed.

 @param observer   The observer object to remove from subscription events.
 @param service    The service that the object is subscribed to.
 @param completion A block to run when the subscription call finishes. Returns a
 BOOL corresponding to whether the call succeeded or failed.
 */
- (void)removeObserver:(id<UPPEventSubscriptionDelegate>)observer fromService:(UPPBasicService *)service completion:(void(^)(BOOL success))completion;

/**
 Unsubscribe a specific subscription. Used internally, but may be useful for
 batch unsubscribing all event subscribers.

 @param subscription The subscription to unsubscribe.
 @param completion A block to run when the subscription call finishes. Returns a
 BOOL corresponding to whether the call succeeded or failed.
 */
- (void)unsubscribe:(UPPEventSubscription *)subscription completion:(void(^)(BOOL success))completion;

@end
