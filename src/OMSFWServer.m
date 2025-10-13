#import <ObjFW/ObjFW.h>
#import "OMSFWServer.h"
#import "OMSFWRequest.h"
#import "OMSFWResponse.h"

@implementation OMSFWServer {
  OFHTTPServer *_httpServer;
}

+ (instancetype)serverWithControllers:(OMSFWControllersArray *)controllers {
  return [[self alloc] initWithControllers:controllers];
}

+ (instancetype)serverWithControllers:(OMSFWControllersArray *)controllers
                               prefix:(OFString *)prefix
                                 port:(uint16_t)port
{
  return [[self alloc] initWithControllers:controllers prefix:prefix port:port];
}

- (instancetype)initWithControllers:(OMSFWControllersArray *)controllers {
  OFDictionary<OFString *, OFString *> *environment =
    [OFApplication environment];
  OFString *prefix =
    [environment objectForKey:@"OMSFW_PREFIX"];
  unsigned short port =
    [environment objectForKey:@"OMSFW_PORT"].unsignedShortValue;

  if (prefix == nil) {
    prefix = @"/";
  }

  if (port == 0) {
    port = 8080;
  }

  self = [self initWithControllers:controllers prefix:prefix port:port];

  return self;
}

- (instancetype)initWithControllers:(OMSFWControllersArray *)controllers
                             prefix:(OFString *)prefix
                               port:(uint16_t)port
{
  self = [super initWithType:OMSFWControllerTypeRoot
                        path:prefix
                 controllers:controllers];

  _httpServer = [OFHTTPServer server];
  _httpServer.name = nil;
  _httpServer.host = @"0.0.0.0";
  _httpServer.port = port;
  _httpServer.delegate = self;

  return self;
}

- (instancetype)initWithType:(OMSFWControllerType)type
                        path:(OFString *)path
                 controllers:(OMSFWControllersArray *)controllers
{
  return [self initWithControllers:controllers prefix:path port:8080];
}

- (void)start {
  [_httpServer start];
}

@end

@implementation OMSFWServer (OFHTTPServerDelegate)

- (void)     server:(OFHTTPServer *)server
  didReceiveRequest:(OFHTTPRequest *)request
        requestBody:(OFStream *)requestBody
           response:(OFHTTPResponse *)response
{
  id requestBodyObject = [requestBody readString].objectByParsingJSON;

  if (
    ![requestBodyObject isKindOfClass:[OFDictionary class]] &&
    ![requestBodyObject isKindOfClass:[OFArray class]] &&
    requestBodyObject != nil
  ) {
    response.statusCode = 400;
    response.headers = @{@"Content-Length": @"0"};
    [response writeString:@""];

    return;
  }

  OMSFWRequestMethod omsfwMethod;

  switch (request.method) {
    case OFHTTPRequestMethodGet:
      omsfwMethod = OMSFWRequestMethodGet;
      break;

    case OFHTTPRequestMethodPost:
      omsfwMethod = OMSFWRequestMethodPost;
      break;

    case OFHTTPRequestMethodDelete:
      omsfwMethod = OMSFWRequestMethodDelete;
      break;

    default:
      response.statusCode = 400;
      response.headers = @{@"Content-Length": @"0"};
      [response writeString:@""];

      return;
  }

  OMSFWRequest *omsfwRequest = [OMSFWRequest requestWithPath:request.IRI.path
                                                      object:requestBodyObject
                                                      method:omsfwMethod
                                                     headers:request.headers];
  OMSFWResponse *omsfwResponse = [self forward:omsfwRequest];
  OFString *responseString =
    omsfwResponse.object.JSONRepresentation;
  OFMutableDictionary OF_GENERIC(OFString *, OFString *) *responseHeaders =
    [OFMutableDictionary dictionaryWithKeysAndObjects:
      @"Content-Type", @"application/json",
      @"Content-Length", [OFString stringWithFormat:@"%zu",
                                     responseString.length],
    nil];

  for (OFString *headerName in omsfwResponse.headers) {
    OFString *headerValue = omsfwResponse.headers[headerName];
    if (headerValue != nil) responseHeaders[headerName] = headerValue;
  }

  if (responseString == nil) {
    responseHeaders[@"Content-Type"] = @"text/plain";
    responseHeaders[@"Content-Length"] = @"0";
  }

  [responseHeaders makeImmutable];
  response.statusCode = omsfwResponse.status;
  response.headers = responseHeaders;
  [response writeString:responseString];
}

@end
