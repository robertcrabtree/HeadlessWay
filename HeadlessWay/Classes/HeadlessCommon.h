#define WIDTH_IPHONE_5 568
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == WIDTH_IPHONE_5)

// add this to view controllers that should support rotation
#define HEADLESS_ROTATION_SUPPORT \
- (NSUInteger)supportedInterfaceOrientations \
{ \
    return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait; \
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
    return YES; \
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