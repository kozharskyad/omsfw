#import <ObjFW/ObjFW.h>
#import "OMSFWController.h"

OF_ASSUME_NONNULL_BEGIN

@interface OMSFWServer : OMSFWController

+ (instancetype)serverWithControllers:(OMSFWControllersArray *)controllers;
+ (instancetype)serverWithControllers:(OMSFWControllersArray *)controllers prefix:(OFString *)prefix port:(uint16_t)port;

- (instancetype)initWithControllers:(OMSFWControllersArray *)controllers;
- (instancetype)initWithControllers:(OMSFWControllersArray *)controllers prefix:(OFString *)prefix port:(uint16_t)port OF_DESIGNATED_INITIALIZER;
- (void)start;

@end

@interface OMSFWServer (OFHTTPServerDelegate) OF_GENERIC(OFHTTPServerDelegate)

//

@end

OF_ASSUME_NONNULL_END
