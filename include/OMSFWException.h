#import <ObjFW/ObjFW.h>

OF_ASSUME_NONNULL_BEGIN

@interface OMSFWException : OFException

@property (nonatomic, copy, readonly) OFString *message;
@property (nonatomic, assign, readonly) short code;

+ (instancetype)exception OF_UNAVAILABLE;
+ (instancetype)exceptionWithCode:(short)code
                              message:(OFString *)message;

- (instancetype)init OF_UNAVAILABLE;
- (instancetype)initWithCode:(short)code
                         message:(OFString *)message OF_DESIGNATED_INITIALIZER;

@end

OF_ASSUME_NONNULL_END
