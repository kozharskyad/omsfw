#import <ObjFW/ObjFW.h>
#import "QweController.h"

@implementation QweController

+ (instancetype)controller {
  return [[self alloc] init];
}

- (instancetype)init {
  return [super initWithType:OMSFWControllerTypeSingleton path:@"qwe" controllers:@[]];
}

- (instancetype)initWithType:(OMSFWControllerType)type path:(OFString *)path controllers:(OMSFWControllersArray *)controllers {
  return [self init];
}

- (OMSFWResponse *)handleGet:(OMSFWRequest *)request {
  auto response = [OMSFWResponse response];

  response.status = 200;
  response.object = @{@"message": @"QweController", @"path": request.path};

  return response;
}
@end
