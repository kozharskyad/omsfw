#import <ObjFW/ObjFW.h>
#import "OMSFW/OMSFWRequest.h"

@implementation OMSFWRequest

+ (instancetype)requestWithPath:(OFString *)path object:(id)object method:(OMSFWRequestMethod)method {
  return [[self alloc] initWithPath:path object:object method:method];
}

- (instancetype)initWithPath:(OFString *)path object:(id)object method:(OMSFWRequestMethod)method {
  self = [super init];

  _path = path;
  _object = object;

  return self;
}

@end
