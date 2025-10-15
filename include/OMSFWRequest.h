#import <ObjFW/ObjFW.h>

typedef enum {
  OMSFWRequestMethodGet,
  OMSFWRequestMethodPost,
  OMSFWRequestMethodDelete
} OMSFWRequestMethod;

OF_ASSUME_NONNULL_BEGIN

@interface OMSFWRequest : OFObject

@property (nonatomic, strong, readonly) OFHTTPRequest *ofHttpRequest;
@property (nonatomic, strong, readonly) OFString *path;
@property (nonatomic, strong, readonly, nullable)
  id OF_GENERIC(OFJSONRepresentation) object;
@property (nonatomic, assign, readonly) OMSFWRequestMethod method;
@property (nonatomic, copy, nullable, readonly)
  OFDictionary OF_GENERIC(OFString *, OFString *) *headers;
@property (nonatomic, strong, readonly)
  OFDictionary OF_GENERIC(OFString *, OFString *) *query;

+ (instancetype)requestWithBody:(id)body
                  ofhttpRequest:(OFHTTPRequest *)request
                     forwarding:(BOOL)forwarding;
+ (instancetype)requestWithObject:(id)body
                    ofhttpRequest:(OFHTTPRequest *)request;
+ (instancetype)forwardingRequest:(OMSFWRequest *)omsfwRequest;

- (instancetype)init OF_UNAVAILABLE;
- (instancetype)initWithBody:(id)body
               ofhttpRequest:(OFHTTPRequest *)request
                  forwarding:(BOOL)forwarding
                  OF_DESIGNATED_INITIALIZER;
- (instancetype)initWithObject:(id)body
               ofhttpRequest:(OFHTTPRequest *)request;
- (instancetype)initForwardingRequest:(OMSFWRequest *)omsfwRequest;

@end

OF_ASSUME_NONNULL_END
