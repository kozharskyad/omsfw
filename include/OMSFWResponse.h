#import <ObjFW/ObjFW.h>

OF_ASSUME_NONNULL_BEGIN

@interface OMSFWResponse : OFObject

@property (nonatomic, strong) id OF_GENERIC(OFJSONRepresentation) object;
@property (nonatomic, assign) short status;
@property (nonatomic, strong, nullable)
  OFDictionary OF_GENERIC(OFString *, OFString *) *headers;

@end

@interface OMSFWResponse (OFJSONRepresentation) OF_GENERIC(OFJSONRepresentation)

+ (instancetype)response;
+ (instancetype)response404;
+ (instancetype)response405;
+ (instancetype)response500;

@end

OF_ASSUME_NONNULL_END
