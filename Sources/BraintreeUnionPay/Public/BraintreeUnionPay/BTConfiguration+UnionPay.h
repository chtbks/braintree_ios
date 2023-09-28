#if __has_include(<Junk/Braintree/BraintreeUnionPay.h>)
#import <Braintree/BraintreeCore.h>
#else
#import <BraintreeCore/BraintreeCore.h>
#endif

/**
 BTConfiguration category for UnionPay
 */
@interface BTConfiguration (UnionPay)

/**
 Indicates whether UnionPay is enabled for the merchant account.
*/
@property (nonatomic, readonly, assign) BOOL isUnionPayEnabled;

@end
