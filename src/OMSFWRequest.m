#import <ObjFW/ObjFW.h>
#import "OMSFWRequest.h"
#import "OMSFWException.h"

@implementation OMSFWRequest

+ (instancetype)requestWithBody:(id)body
                  ofhttpRequest:(OFHTTPRequest *)request
                     forwarding:(BOOL)forwarding
{
  return [[self alloc]
    initWithBody:body ofhttpRequest:request forwarding:forwarding];
}

+ (instancetype)requestWithObject:(id)body ofhttpRequest:(OFHTTPRequest *)request {
  return [[self alloc] initWithObject:body ofhttpRequest:request];
}

+ (instancetype)forwardingRequest:(OMSFWRequest *)omsfwRequest {
  return [[self alloc] initForwardingRequest:omsfwRequest];
}

- (instancetype)initWithBody:(id)body
                  ofhttpRequest:(OFHTTPRequest *)request
                     forwarding:(BOOL)forwarding
{
  self = [super init];

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
      @throw [OMSFWException exceptionWithCode:405 message:@"Unsupported request method"];
  }

  id requestBodyObject = body;

  if ([requestBodyObject isKindOfClass:[OFString class]]) {
    OFString *requestBodyString = requestBodyObject;
    requestBodyObject = requestBodyString.objectByParsingJSON;
  }

  if (
    ![requestBodyObject isKindOfClass:[OFDictionary class]] &&
    ![requestBodyObject isKindOfClass:[OFArray class]] &&
    requestBodyObject != nil
  ) {
    @throw [OMSFWException exceptionWithCode:400 message:@"Invalid request body"];
  }

  OFMutableDictionary <OFString *, OFString *> *query =
    [OFMutableDictionary dictionary];

  for (OFPair<OFString *, OFString *> *queryPair in request.IRI.queryItems) {
    OFString *queryKey = queryPair.firstObject;
    OFString *queryValue = queryPair.secondObject;

    if (queryKey != nil && queryValue != nil) {
      query[queryKey] = queryValue;
    }
  }

  [query makeImmutable];

  _ofHttpRequest = request;
  _method = omsfwMethod;
  _path = request.IRI.path;
  _query = query;
  _headers = request.headers;
  _object = requestBodyObject;

  if (forwarding) {
    OFArray<OFString *> *pathSplit = [_path componentsSeparatedByString:@"/"
      options:OFStringSkipEmptyComponents];
    OFArray<OFString *> *filteredPathSplit = [pathSplit
      filteredArrayUsingBlock:^BOOL(OFString *component, size_t index) {
        return index > 0;
      }
    ];

    _path = [filteredPathSplit componentsJoinedByString:@"/"];
  }

  return self;
}

- (instancetype)initWithObject:(id)body ofhttpRequest:(OFHTTPRequest *)request {
  return [self initWithBody:body ofhttpRequest:request forwarding:NO];
}

- (instancetype)initForwardingRequest:(OMSFWRequest *)omsfwRequest {
  return [self initWithBody:omsfwRequest.object ofhttpRequest:omsfwRequest.ofHttpRequest forwarding:YES];
}

@end
