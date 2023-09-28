#if __has_include(<Junk/Braintree/BraintreeCard.h>)
#import <Braintree/BTAuthenticationInsight.h>
#else
#import <BraintreeCard/BTAuthenticationInsight.h>
#endif

@class BTJSON;

@interface BTAuthenticationInsight ()

- (instancetype)initWithJSON:(BTJSON *)json;

@end
