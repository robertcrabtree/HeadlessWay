

// add this to view controllers that should support rotation
#define HEADLESS_ROTATION_SUPPORT \
- (NSUInteger)supportedInterfaceOrientations \
{ \
    NSLog(@"++supportedInterfaceOrientations"); \
    return UIInterfaceOrientationMaskLandscape; \
} \
- (BOOL)shouldAutorotate \
{ \
    NSLog(@"++shouldAutorotate"); \
    return YES; \
}

// add this to view controllers that should not support rotation
#define HEADLESS_ROTATION_SUPPORT_NONE \
- (NSUInteger)supportedInterfaceOrientations \
{ \
    NSLog(@"++supportedInterfaceOrientations"); \
    return UIInterfaceOrientationMaskPortrait; \
} \
- (BOOL)shouldAutorotate \
{ \
    NSLog(@"++shouldAutorotate"); \
    return NO; \
} \
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation \
{ \
    NSLog(@"++preferredInterfaceOrientationForPresentation"); \
    return UIInterfaceOrientationPortrait; \
}
