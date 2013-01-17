// convert from html hex code
#define UIColorFromHex(rgbValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SET_LOOKS_NAVIGATION_BAR() { \
    [[UINavigationBar appearance] setTintColor:UIColorFromHex(0x354B65)]; \
}

#define SET_LOOKS_TOOLBAR() { \
    [[UIToolbar appearance] setTintColor:UIColorFromHex(0x354B65)]; \
}

#define SET_LOOKS_TABLE() { \
    UIImageView* bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]] autorelease]; \
    [self.tableView.backgroundView addSubview:bgView]; \
    self.tableView.backgroundColor = UIColorFromHex(0xD2D3D5); \
}

#define SET_LOOKS_TABLE_CELL() { \
    cell.backgroundColor = UIColorFromHex(0xF1E5C1); \
    cell.textLabel.textColor = UIColorFromHex(0x344B65); \
}
