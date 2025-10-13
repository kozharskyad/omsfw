#import <ObjFW/ObjFW.h>
#import <OMSFW.h>
#import "Application.h"
#import "Test1Controller.h"

@implementation Application {
  OMSFWServer *_server;
}

- (void)applicationDidFinishLaunching:(OFNotification *)notification {
  _server = [OMSFWServer serverWithControllers:@[
    [Test1Controller controller]
  ]];

  [_server start];
  OFLog(@"Server started");
}

@end
