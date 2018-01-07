//
//  GXRulerConfig.h
//  GXRuler
//
//  Created by sgx on 2018/1/7.
//  Copyright © 2018年 sunguangxin. All rights reserved.
//

#ifndef GXRulerConfig_h
#define GXRulerConfig_h

/// sanbox path

#define kLibraryDirectory(fileName) [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:(fileName)]

/// color

#define GX_PINK_COLOR [UIColor colorWithRed:251./255 green:114./255 blue:153./255 alpha:1]

#undef HEXCOLOR
#undef HEXACOLOR
#undef RGBCOLOR
#undef RGBACOLOR

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEXACOLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define RGBCOLOR(r, g, b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


#endif /* GXRulerConfig_h */
