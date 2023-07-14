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

- (void)setupOpenURLExpectationsWithScheme:(NSString *)expectedScheme
                                      host:(NSString *)expectedHost
                                      path:(NSString *)expectedPath
                                queryItems:(NSArray<NSURLQueryItem *>*)expectedQueryItems {
    [[_mockApplication expect] openURL:[OCMArg checkWithBlock:^BOOL(id value){
        
        // This is the custom assertion block, we can inspect the `value` here
        // We need to return `YES`/`NO` depending if it matches our expectetations
        if (![value isKindOfClass:[NSURL class]]) {
            return NO;
        }
        NSURL *valueAsURL = (NSURL *)value;
        if (![valueAsURL.scheme isEqualToString:expectedScheme]) {
            return FALSE;
        }
        
        if (![valueAsURL.host isEqualToString:expectedHost]) {
            return FALSE;
        }
        
        if (![valueAsURL.path isEqualToString:expectedPath]) {
            return FALSE;
        }
        
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:valueAsURL resolvingAgainstBaseURL:YES];
        NSArray<NSURLQueryItem *> *actualQueryItems = urlComponents.queryItems;
        
        for (NSURLQueryItem *expectedQueryItem in expectedQueryItems) {
            if (![actualQueryItems containsObject:expectedQueryItem]) {
                return FALSE;
            }
        }
        return YES;
    }]
    options:[OCMArg any] completionHandler:[OCMArg any]];

    
    // TODO: - After we verify that we have expected params into this func, it isn't calling it's own completion ever
    
}

- (void)verifyOpenURLExpectations {
    [_mockApplication verify];
}

@end
