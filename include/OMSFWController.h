#import <ObjFW/ObjFW.h>

typedef enum {
  OMSFWControllerTypeRoot = -1,
  OMSFWControllerTypeNone,
  OMSFWControllerTypeSingleton,
  OMSFWControllerTypeStateless,
} OMSFWControllerType;

@class OMSFWRequest;
@class OMSFWResponse;
@class OMSFWController;

typedef OFMutableDictionary OF_GENERIC(OFString *, OMSFWController *)
  OMSFWControllersMutableRegistry;
typedef OFDictionary OF_GENERIC(OFString *, OMSFWController *)
  OMSFWControllersRegistry;
typedef OFArray OF_GENERIC(OMSFWController *) OMSFWControllersArray;

OF_ASSUME_NONNULL_BEGIN

@interface OMSFWController : OFObject

@property (nonatomic, assign, readonly) OMSFWControllerType type;
@property (nonatomic, retain, readonly) OFString *path;
@property (nonatomic, retain, readonly) OMSFWControllersRegistry *controllers;

+ (instancetype)controllerWithType:(OMSFWControllerType)type
                              path:(OFString *)path
                       controllers:(OMSFWControllersArray *)controllers;

- (instancetype)init OF_UNAVAILABLE;
- (instancetype)initWithType:(OMSFWControllerType)type
                        path:(OFString *)path
                 controllers:(OMSFWControllersArray *)controllers
                             OF_DESIGNATED_INITIALIZER;

- (OMSFWResponse *)handle404:(OMSFWRequest *)request;
- (OMSFWResponse *)handleGet:(OMSFWRequest *)request;
- (OMSFWResponse *)handlePost:(OMSFWRequest *)request;
- (OMSFWResponse *)handleDelete:(OMSFWRequest *)request;
- (OMSFWResponse *)forward:(OMSFWRequest *)request;

@end

OF_ASSUME_NONNULL_END
