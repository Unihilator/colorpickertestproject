//
//  MDColorsChooserView.h
//  ColorPickerTestProject
//
//  Created by Nikolay Rybalko on 2/4/14.
//  Copyright (c) 2014 Nickolay Rybalko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDColorsChooserViewDelegate;
@class MDColorPickerView;

@interface MDColorsChooserView : UIView

@property (nonatomic, weak) id<MDColorsChooserViewDelegate> delegate;

@property (nonatomic, readonly) NSArray *currentColors;
@property (nonatomic, readonly) NSArray *currentColorsRGBStrings;

@property (nonatomic, readonly) MDColorPickerView *colorPickerView;
@property (nonatomic, readonly) UICollectionViewFlowLayout *layout;
@property (nonatomic, readonly) UICollectionView *colorsCollectionView;
@property (nonatomic, assign) NSUInteger maxNumColors;

@end

@protocol MDColorsChooserViewDelegate <NSObject>
@optional
- (void)colorsChooser:(MDColorsChooserView*)colorsChooser didChangeColors:(NSArray*)colors;
- (void)colorsChooser:(MDColorsChooserView*)colorsChooser didChangeColorsRGBStrings:(NSArray*)colorsRGBStrings;

@end