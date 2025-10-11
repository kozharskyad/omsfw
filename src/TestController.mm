#import <ObjFW/ObjFW.h>
#import "TestController.h"
#import "QweController.h"

@implementation TestController

+ (instancetype)controller {
  return [[self alloc] init];
}

- (instancetype)initWithType:(OMSFWControllerType)type path:(OFString *)path controllers:(OMSFWControllersRegistry *)controllers {
  return [self init];
}

- (instancetype)init {
  return [super initWithType:OMSFWControllerTypeSingleton path:@"test" controllers:@[
    [QweController controller]
  ]];
}

- (OMSFWResponse *)handleGet:(OMSFWRequest *)request {
  // auto response = [OMSFWResponse response];

  // response.status = 200;
  // response.object = @{@"message": @"Hello from TestController", @"path": request.path};

  // return response;

  return [self forward:request];
}

@end
