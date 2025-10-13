#import <ObjFW/ObjFW.h>

typedef enum {
  OMSFWRequestMethodGet,
  OMSFWRequestMethodPost,
  OMSFWRequestMethodDelete
} OMSFWRequestMethod;

OF_ASSUME_NONNULL_BEGIN

@interface OMSFWRequest : OFObject

@property (nonatomic, retain, readonly) OFString *path;
@property (nonatomic, retain, readonly, nullable)
  id OF_GENERIC(OFJSONRepresentation) object;
@property (nonatomic, assign, readonly) OMSFWRequestMethod method;
@property (nonatomic, copy, nullable, readonly)
  OFDictionary OF_GENERIC(OFString *, OFString *) *headers;

+ (instancetype)requestWithPath:(OFString *)path
              object:(nullable id OF_GENERIC(OFJSONRepresentation))object
              method:(OMSFWRequestMethod)method
             headers:(OFDictionary OF_GENERIC(OFString *, OFString *) *)headers;

- (instancetype)init OF_UNAVAILABLE;
- (instancetype)initWithPath:(OFString *)path
               object:(nullable id OF_GENERIC(OFJSONRepresentation))object
               method:(OMSFWRequestMethod)method
              headers:(OFDictionary OF_GENERIC(OFString *, OFString *) *)headers
              OF_DESIGNATED_INITIALIZER;

@end

OF_ASSUME_NONNULL_END
