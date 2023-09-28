#if __has_include(<Junk/Braintree/BraintreePaymentFlow.h>)
#import <Braintree/BTConfiguration+LocalPayment.h>
#else
#import <BraintreePaymentFlow/BTConfiguration+LocalPayment.h>
#endif

@implementation BTConfiguration (LocalPayment)

- (BOOL)isLocalPaymentEnabled {
    // Local Payments are enabled when PayPal is enabled
    return [self.json[@"paypalEnabled"] isTrue];
}

@end
