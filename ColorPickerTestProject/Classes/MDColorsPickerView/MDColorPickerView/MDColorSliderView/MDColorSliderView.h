//
//  MDColorSliderView.h
//  ColorPickerTestProject
//
//  Created by Nikolay Rybalko on 2/3/14.
//  Copyright (c) 2014 Nickolay Rybalko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDColorSliderView : UIView

+ (instancetype)colorSliderViewWithBottomPosition:(CGFloat)bottomPosition;
- (void)dismiss;

- (void)setX:(CGFloat)x withColor:(UIColor*)color;

@end
