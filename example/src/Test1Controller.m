#import <ObjFW/ObjFW.h>
#import <OMSFW.h>
#import "Test1Controller.h"
#import "Test2Controller.h"

@implementation Test1Controller

+ (instancetype)controller {
  return [[self alloc] init];
}

- (instancetype)initWithType:(OMSFWControllerType)type path:(OFString *)path controllers:(OMSFWControllersArray *)controllers {
  return [super initWithType:type path:path controllers:controllers];
}

- (instancetype)init {
  self = [self initWithType:OMSFWControllerTypeSingleton path:@"test1" controllers:@[
    [Test2Controller controller]
  ]];

  return self;
}

- (OMSFWResponse *)handleGet:(OMSFWRequest *)request {
  return [self forward:request];
}

@end
