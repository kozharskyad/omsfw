#import <ObjFW/ObjFW.h>
#import "OMSFWController.h"
#import "OMSFWRequest.h"
#import "OMSFWResponse.h"
#import "OMSFWException.h"

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

  OMSFWRequest *forwardingRequest;

  @try {
    forwardingRequest = [OMSFWRequest forwardingRequest:request];
  } @catch (OMSFWException *exception) {
    OMSFWResponse *response = [OMSFWResponse response];

    response.status = exception.code;
    OFLog(@"Forwarding fatal exception: %@", exception.message);

    return response;
  }

  switch (controller.type) {
    case OMSFWControllerTypeSingleton:
    case OMSFWControllerTypeRoot:
      break;

    case OMSFWControllerTypeStateless:
      controller = [controller.class controllerWithType:controller.type
                                                   path:forwardingRequest.path
                                            controllers:_controllersArray];
      break;

    case OMSFWControllerTypeNone:
    default:
      return [OMSFWResponse response500];
  }

  @try {
    switch (request.method) {
      case OMSFWRequestMethodGet:
        return [controller handleGet:forwardingRequest];

      case OMSFWRequestMethodPost:
        return [controller handlePost:forwardingRequest];

      case OMSFWRequestMethodDelete:
        return [controller handleDelete:forwardingRequest];

      default:
        @throw [OMSFWException exceptionWithCode:405 message:@"Invalid HTTP method"];
    }
  } @catch (OMSFWException *exception) {
    OMSFWResponse *response = [OMSFWResponse response];

    response.status = exception.code;
    OFLog(@"Handling fatal exception: %@", exception.message);

    return response;
  }
}

@end
