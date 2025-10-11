#import <ObjFW/ObjFW.h>
#import "OMSFW.h"

OF_ASSUME_NONNULL_BEGIN

@interface TestController : OMSFWController

+ (instancetype)controller;
- (instancetype)init OF_DESIGNATED_INITIALIZER;

@end

OF_ASSUME_NONNULL_END
