#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTMockUIApplication : NSObject

/// Injects a stub return value for `UIApplication.shared.canOpenURL(_:)`
- (void)stubCanOpenURLWith:(BOOL)canOpenURL;

/// Defines the parameters that we expect `UIApplication.shared.openURL(_:options:completionHandler:)` to be called with.
/// - Parameters:
///   - scheme: The expected URL scheme
///   - queryItems: An array of expected query items
- (void)setupOpenURLExpectationsWithScheme:(NSString *)expectedScheme
                                      host:(NSString *)expectedHost
                                      path:(NSString *)expectedPath
                                queryItems:(NSArray<NSURLQueryItem *>*)expectedQueryItems;

/// Run OCMock assertion on expected parameters.
- (void)verifyOpenURLExpectations;

@end

NS_ASSUME_NONNULL_END
