#import <ObjFW/ObjFW.h>
#import "OMSFWException.h"

@implementation OMSFWException

+ (instancetype)exceptionWithCode:(short)code message:(OFString *)message {
  return [[self alloc] initWithCode:code message:message];
}

- (instancetype)initWithCode:(short)code message:(OFString *)message {
  self = [super init];

  _code = code;
  _message = [message copy];

  return self;
}

@end
