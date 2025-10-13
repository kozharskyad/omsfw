#import <ObjFW/ObjFW.h>
#import "OMSFWController.h"
#import "OMSFWRequest.h"
#import "OMSFWResponse.h"

@implementation OMSFWController {
  OMSFWControllersArray *_controllersArray;
}

+ (instancetype)controllerWithType:(OMSFWControllerType)type
                              path:(OFString *)path
                       controllers:(OMSFWControllersArray *)controllers
{
  return [[self alloc] initWithType:type path:path controllers:controllers];
}

- (instancetype)initWithType:(OMSFWControllerType)type 
                        path:(OFString *)path
                 controllers:(OMSFWControllersArray *)controllers
{
  self = [super init];

  _type = type;
  _path = path;

  OMSFWControllersMutableRegistry *registry =
    [OMSFWControllersMutableRegistry dictionaryWithCapacity:controllers.count];

  for (OMSFWController *controller in controllers) {
    registry[controller.path] = controller;
  }

  [registry makeImmutable];
  _controllers = registry;
  _controllersArray = controllers;

  return self;
}

- (OMSFWResponse *)handle404:(OMSFWRequest *)request {
  return [OMSFWResponse response404];
}

- (OMSFWResponse *)handleGet:(OMSFWRequest *)request {
  return [OMSFWResponse response405];
}

- (OMSFWResponse *)handlePost:(OMSFWRequest *)request {
  return [OMSFWResponse response405];
}

- (OMSFWResponse *)handleDelete:(OMSFWRequest *)request {
  return [OMSFWResponse response405];
}

- (OMSFWResponse *)forward:(OMSFWRequest *)request {
  OFString *requestPath = request.path;
  size_t prefixPathLength = _path.length;

  if (_type == OMSFWControllerTypeRoot) {
    if (requestPath.length < prefixPathLength) {
      return [OMSFWResponse response404];
    }

    OFString *pathHead =
      [requestPath substringToIndex:prefixPathLength];

    if (![pathHead isEqual:_path]) {
      return [OMSFWResponse response404];
    }

    requestPath = [requestPath substringFromIndex:prefixPathLength];
  }

  OFArray<OFString *> *currentPathComponents =
    [requestPath componentsSeparatedByString:@"/"
                                     options:OFStringSkipEmptyComponents];
  size_t currentPathComponentsCount = currentPathComponents.count;

  if (currentPathComponentsCount == 0) {
    return [OMSFWResponse response404];
  }

  OFString *firstComponent =
    currentPathComponents.firstObject;
  OMSFWController *controller = [_controllers objectForKey:firstComponent];

  if (controller == nil) {
    return [OMSFWResponse response404];
  }

  OFMutableArray<OFString *> *forwardingPathComponents = [OFMutableArray array];

  for (size_t i = 1; i < currentPathComponentsCount; i++) {
    [forwardingPathComponents
      addObject:[currentPathComponents objectAtIndex:i]];
  }

  OFString *forwardingPath =
    [forwardingPathComponents componentsJoinedByString:@"/"];
  OMSFWRequest *forwardingRequest = [OMSFWRequest requestWithPath:forwardingPath
                                                        object:request.object
                                                        method:request.method
                                                       headers:request.headers];

  switch (controller.type) {
    case OMSFWControllerTypeSingleton:
    case OMSFWControllerTypeRoot:
      break;

    case OMSFWControllerTypeStateless:
      controller = [controller.class controllerWithType:controller.type
                                                   path:forwardingPath
                                            controllers:_controllersArray];
      break;

    case OMSFWControllerTypeNone:
    default:
      return [OMSFWResponse response500];
  }

  switch (request.method) {
    case OMSFWRequestMethodGet:
      return [controller handleGet:forwardingRequest];

    case OMSFWRequestMethodPost:
      return [controller handlePost:forwardingRequest];

    case OMSFWRequestMethodDelete:
      return [controller handleDelete:forwardingRequest];

    default:
      return [OMSFWResponse response405];
  }
}

@end
