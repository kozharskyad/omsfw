#import <ObjFW/ObjFW.h>

OF_ASSUME_NONNULL_BEGIN

@interface OMSFWResponse : OFObject

@property (nonatomic, retain) id OF_GENERIC(OFJSONRepresentation) object;
@property (nonatomic, assign) short status;

@end

@interface OMSFWResponse (OFJSONRepresentation) OF_GENERIC(OFJSONRepresentation)

+ (instancetype)response;
+ (instancetype)response404;
+ (instancetype)response405;
+ (instancetype)response500;

@end

OF_ASSUME_NONNULL_END
