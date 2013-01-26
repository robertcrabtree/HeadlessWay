// convert from html hex code
#define UIColorFromHex(rgbValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SET_LOOKS_NAVIGATION_BAR() { \
    [[UINavigationBar appearance] setTintColor:UIColorFromHex(0x4C5B74)]; \
}

#define SET_LOOKS_TOOLBAR() { \
    [[UIToolbar appearance] setTintColor:UIColorFromHex(0x4C5B74)]; \
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"toolbar"] \
                        forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault]; \
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"toolbar-landscape"] \
                        forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsLandscapePhone]; \
}

#define SET_LOOKS_TABLE() { \
    UIImage *backgroundImage = [UIImage imageNamed:@"background"]; \
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:backgroundImage]; \
    self.tableView.backgroundView = backgroundImageView; \
    self.tableView.backgroundColor = [UIColor clearColor]; \
    [backgroundImageView release]; \
}

#define SET_LOOKS_TABLE_CELL() { \
    cell.backgroundColor = UIColorFromHex(0xF1E5C1); \
    cell.textLabel.textColor = UIColorFromHex(0x344B65); \
}
