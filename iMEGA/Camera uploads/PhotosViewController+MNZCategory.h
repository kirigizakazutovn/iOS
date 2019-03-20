
#import "PhotosViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotosViewController (MNZCategory)

- (void)showCameraUploadBoardingScreen;

- (void)pushCameraUploadSettings;
- (void)pushVideoUploadSettings;

- (void)showLocalDiskIsFullWarningScreen;

@end

NS_ASSUME_NONNULL_END
