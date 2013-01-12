

// add this to view controllers that should support rotation
#define HEADLESS_ROTATION_SUPPORT \
- (NSUInteger)supportedInterfaceOrientations \
{ \
    return UIInterfaceOrientationMaskLandscape; \
} \
- (BOOL)shouldAutorotate \
{ \
    return YES; \
} \
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation \
{ \
    BOOL ret = NO; \
    if (interfaceOrientation == UIInterfaceOrientationPortrait || \
        interfaceOrientation == UIDeviceOrientationLandscapeLeft || \
        interfaceOrientation == UIDeviceOrientationLandscapeRight) \
        ret = YES; \
    return ret; \
}

// add this to view controllers that should not support rotation
#define HEADLESS_ROTATION_SUPPORT_NONE \
- (NSUInteger)supportedInterfaceOrientations \
{ \
    return UIInterfaceOrientationMaskPortrait; \
} \
- (BOOL)shouldAutorotate \
{ \
    return NO; \
} \
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation \
{ \
    return UIInterfaceOrientationPortrait; \
} \
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation \
{ \
    BOOL ret = NO; \
    if (interfaceOrientation == UIInterfaceOrientationPortrait) \
        ret = YES; \
    return ret; \
}