//
//  MDColorsChooserViewCell.h
//  ColorPickerTestProject
//
//  Created by Nikolay Rybalko on 2/4/14.
//  Copyright (c) 2014 Nickolay Rybalko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDColorsChooserViewCell : UICollectionViewCell

+ (NSString*)reuseIdentifier;
+ (UINib*)nib;

@property (nonatomic, strong) UIColor *choosedColor;

@end
