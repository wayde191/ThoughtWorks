//
//  Fonts.h
//  WeChatMoments
//
//  Created by Wayde Sun on 4/4/15.
//  Copyright (c) 2015 iHakula. All rights reserved.
//

#ifndef WeChatMoments_Fonts_h
#define WeChatMoments_Fonts_h

#define UIColorFromRGB(rgbValue)            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COMMENT_USERNAME_TEXT_COLOR         UIColorFromRGB(0x8590AE)
#define COMMENT_CONTENT_TEXT_COLOR          UIColorFromRGB(0x000000)
#define COMMENT_BACKGROUND_COLOR            UIColorFromRGB(0xF0F0F2)
#define COMMENT_SEPARATOR_LINE_COLOR        UIColorFromRGB(0xF4F4F2)

// Font Size
#define FONTSIZE_BOLD_17     [UIFont boldSystemFontOfSize:17.0f]
#define FONTSIZE_17          [UIFont systemFontOfSize:17.0f]
#define FONTSIZE_BOLD_15     [UIFont boldSystemFontOfSize:15.0f]
#define FONTSIZE_15          [UIFont systemFontOfSize:15.0f]

#endif
