#import <ObjFW/ObjFW.h>
#import <OMSFW.h>
#import "Test2Controller.h"

@implementation Test2Controller

+ (instancetype)controller {
  return [[self alloc] init];
}

- (instancetype)initWithType:(OMSFWControllerType)type path:(OFString *)path controllers:(OMSFWControllersArray *)controllers {
  return [super initWithType:type path:path controllers:controllers];
}

- (instancetype)init {
  self = [self initWithType:OMSFWControllerTypeSingleton path:@"test2" controllers:@[]];
  return self;
}

- (OMSFWResponse *)handleGet:(OMSFWRequest *)request {
  OMSFWResponse *response = [OMSFWResponse response];

  response.status = 200;
  response.headers = @{@"X-Sample-Header": @"sample-header-value"};
  response.object = @{@"message": @"Hello from Test2"};

  return response;
}

@end
