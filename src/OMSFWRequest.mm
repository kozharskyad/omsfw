#import <ObjFW/ObjFW.h>
#import "OMSFWRequest.h"

@implementation OMSFWRequest

+ (instancetype)requestWithPath:(OFString *)path
              object:(nullable id OF_GENERIC(OFJSONRepresentation))object
              method:(OMSFWRequestMethod)method
             headers:(OFDictionary OF_GENERIC(OFString *, OFString *) *)headers
{
  return [[self alloc] initWithPath:path object:object method:method headers:headers];
}

- (instancetype)initWithPath:(OFString *)path
               object:(nullable id OF_GENERIC(OFJSONRepresentation))object
               method:(OMSFWRequestMethod)method
              headers:(OFDictionary OF_GENERIC(OFString *, OFString *) *)headers
{
  self = [super init];

  _path = path;
  _object = object;
  _headers = headers;

  return self;
}

@end
