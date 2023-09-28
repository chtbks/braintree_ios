#if __has_include(<Junk/Braintree/BraintreePayPal.h>)
#import <Braintree/BTPayPalCreditFinancingAmount.h>
#else
#import <BraintreePayPal/BTPayPalCreditFinancingAmount.h>
#endif

@interface BTPayPalCreditFinancingAmount ()

- (instancetype)initWithCurrency:(NSString *)currency value:(NSString *)value;

@end
