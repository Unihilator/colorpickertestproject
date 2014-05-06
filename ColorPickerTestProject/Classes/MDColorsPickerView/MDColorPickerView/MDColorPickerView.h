//
//  MDColorPickerView.h
//  ColorPickerTestProject
//
//  Created by Nikolay Rybalko on 2/3/14.
//  Copyright (c) 2014 Nickolay Rybalko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDColorPickerViewDelegate;

@interface MDColorPickerView : UIView

@property (nonatomic, assign) UIEdgeInsets gradientColorsInsets;
@property (nonatomic, assign) CGFloat colorSliderTopInset;
@property (nonatomic, weak) id<MDColorPickerViewDelegate> delegate;

@end

@protocol MDColorPickerViewDelegate <NSObject>
@optional
- (void)   colorPicker:(MDColorPickerView*)colorPicker
        didChooseColor:(UIColor*)color;
- (void)colorPickerWillChooseColor:(MDColorPickerView *)colorPicker;

@end
