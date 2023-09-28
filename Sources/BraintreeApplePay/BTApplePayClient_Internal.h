#if __has_include(<Junk/Braintree/BraintreeApplePay.h>)
#import <Braintree/BTApplePayClient.h>
#else
#import <BraintreeApplePay/BTApplePayClient.h>
#endif

@interface BTApplePayClient ()
/**
 Exposed for testing to get the instance of BTAPIClient
*/
@property (nonatomic, strong) BTAPIClient *apiClient;

@end
