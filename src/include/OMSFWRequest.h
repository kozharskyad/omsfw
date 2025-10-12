#import <ObjFW/ObjFW.h>

typedef enum {
  OMSFWRequestMethodGet,
  OMSFWRequestMethodPost,
  OMSFWRequestMethodDelete
} OMSFWRequestMethod;

OF_ASSUME_NONNULL_BEGIN

@interface OMSFWRequest : OFObject

@property (nonatomic, retain, readonly) OFString *path;
@property (nonatomic, retain, readonly, nullable) id OF_GENERIC(OFJSONRepresentation) object;
@property (nonatomic, assign, readonly) OMSFWRequestMethod method;

+ (instancetype)requestWithPath:(OFString *)path object:(nullable id OF_GENERIC(OFJSONRepresentation))object method:(OMSFWRequestMethod)method;

- (instancetype)init OF_UNAVAILABLE;
- (instancetype)initWithPath:(OFString *)path object:(nullable id OF_GENERIC(OFJSONRepresentation))object method:(OMSFWRequestMethod)method OF_DESIGNATED_INITIALIZER;

@end

OF_ASSUME_NONNULL_END
