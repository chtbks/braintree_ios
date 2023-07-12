#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTMockUIApplication : NSObject

//-(id)init; do i ned this

- (void)stubCanOpenURLWith:(BOOL)canOpenURL;

- (void)setupOpenURLCalledWith:(NSURL *)url scheme:(NSString *)scheme merchantID:(NSString *)merchantID;

- (void)verifyOpenURLCalledWith:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
