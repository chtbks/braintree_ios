#if __has_include(<Junk/Braintree/BraintreeUnionPay.h>)
#import <Braintree/BTConfiguration+UnionPay.h>
#else
#import <BraintreeUnionPay/BTConfiguration+UnionPay.h>
#endif

@implementation BTConfiguration (UnionPay)

- (BOOL)isUnionPayEnabled {
    return [self.json[@"unionPay"][@"enabled"] isTrue];
}

@end
