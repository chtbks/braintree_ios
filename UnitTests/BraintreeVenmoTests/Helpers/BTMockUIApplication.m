@import OCMock;

#import "BTMockUIApplication.h"

@interface BTMockUIApplication ()

@property (strong, nonatomic) id mockApplication;

@end

@implementation BTMockUIApplication

-(id)init {
    if (self = [super init]) {
        _mockApplication = [OCMockObject niceMockForClass:[UIApplication class]];
        [[[_mockApplication stub] andReturn:_mockApplication] sharedApplication];
    }
    return self;
}

- (void)stubCanOpenURLWith:(BOOL)canOpenURL {
    OCMStub([_mockApplication canOpenURL:[OCMArg any]]).andReturn(canOpenURL);
}

- (void)setupOpenURLExpectationsWithScheme:(NSString *)scheme merchantID:(NSString *)merchantID accessToken:(NSString *)accessToken {
    [[_mockApplication expect] openURL:[OCMArg checkWithBlock:^BOOL(id value){
        
        // This is the custom assertion block, we can inspect the `value` here
        // We need to return `YES`/`NO` depending if it matches our expectetations
        if (![value isKindOfClass:[NSURL class]]) {
            return NO;
        }
        NSURL *valueAsURL = (NSURL *)value;
        if (![valueAsURL.scheme isEqualToString:scheme]) {
            return FALSE;
        }
        if (![valueAsURL.absoluteString containsString:merchantID]) {
            return FALSE;
        }
        if (![valueAsURL.absoluteString containsString:accessToken]) {
            return FALSE;
        }
        return YES;
    }]
    options:[OCMArg any] completionHandler:[OCMArg any]];
}

- (void)verifyOpenURLExpectations {
    [_mockApplication verify];
}

@end
