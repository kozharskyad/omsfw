#import <ObjFW/ObjFW.h>
#import "OMSFW/OMSFWResponse.h"

@implementation OMSFWResponse

//

@end

@implementation OMSFWResponse (OFJSONRepresentation)

+ (instancetype)response {
  return [[self alloc] init];
}

+ (instancetype)response404 {
  auto response = [self response];
  response.status = 404;
  return response;
}

+ (instancetype)response405 {
  auto response = [self response];
  response.status = 405;
  return response;
}

+ (instancetype)response500 {
  auto response = [self response];
  response.status = 500;
  return response;
}

- (OFString *)JSONRepresentation {
  return [_object JSONRepresentation];
}

- (OFString *)JSONRepresentationWithOptions:(OFJSONRepresentationOptions)options {
  return [_object JSONRepresentationWithOptions:options];
}

@end
