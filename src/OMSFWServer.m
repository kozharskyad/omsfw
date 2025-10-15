#import <ObjFW/ObjFW.h>
#import "OMSFWServer.h"
#import "OMSFWRequest.h"
#import "OMSFWResponse.h"
#import "OMSFWException.h"

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
  OMSFWRequest *omsfwRequest;

  @try {
    omsfwRequest = [OMSFWRequest requestWithObject:[requestBody readString] ofhttpRequest:request];
  } @catch (OMSFWException *exception) {
    response.statusCode = exception.code;
    response.headers = @{@"Content-Length": @"0"};
    [response writeString:@""];

    OFLog(@"Server fatal exception: %@", exception.message);

    return;
  }

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
    responseString = @"";
    responseHeaders[@"Content-Type"] = @"text/plain";
    responseHeaders[@"Content-Length"] = @"0";
  }

  [responseHeaders makeImmutable];
  response.statusCode = omsfwResponse.status;
  response.headers = responseHeaders;
  [response writeString:responseString];
}

@end
