//
//  MDColorsViewController.m
//  ColorPickerTestProject
//
//  Created by Nikolay Rybalko on 2/21/14.
//  Copyright (c) 2014 mobidev. All rights reserved.
//

#import "MDColorsViewController.h"

#import "MDColorPickerView.h"
#import "MDColorsChooserView.h"

@interface MDColorsViewController ()<MDColorPickerViewDelegate,MDColorsChooserViewDelegate>

@property (weak, nonatomic) IBOutlet MDColorPickerView *colorPicker;
@property (weak, nonatomic) IBOutlet MDColorsChooserView *secondChooserView;
@property (weak, nonatomic) IBOutlet MDColorsChooserView *firstColorsChooserView;

@end

@implementation MDColorsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeColorsVC];
}

- (void)initializeColorsVC {
	[self initializeColorPicker];
	[self initializeSecondChooserView];
	[self initializeFirstColorsChooserView];
}

- (void)initializeColorPicker {
	self.colorPicker.delegate = self;
}

- (void)initializeFirstColorsChooserView {
	UICollectionView *colorsCollectionView = self.firstColorsChooserView.colorsCollectionView;
	CGRect colorsCollectionViewFrame = colorsCollectionView.frame;
	colorsCollectionViewFrame.size.height += 45.0;
	colorsCollectionView.frame = colorsCollectionViewFrame;
	self.firstColorsChooserView.delegate = self;
}

- (void)initializeSecondChooserView {
	self.secondChooserView.delegate = self;
	UICollectionView *colorsCollectionView = self.secondChooserView.colorsCollectionView;
	CGRect colorsCollectionViewFrame = colorsCollectionView.frame;
	colorsCollectionViewFrame.origin.y += 10;
	colorsCollectionViewFrame.size.height += 30.0;
	colorsCollectionView.frame = colorsCollectionViewFrame;
	self.secondChooserView.layout.itemSize = CGSizeMake(50, 50);

	self.secondChooserView.maxNumColors = 4;

	MDColorPickerView *colorPickerView = self.secondChooserView.colorPickerView;
	colorPickerView.gradientColorsInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	colorPickerView.colorSliderTopInset = -10.0;
}

#pragma mark - MDColorPickerViewDelegate

- (void)   colorPicker:(MDColorPickerView *)colorPicker
        didChooseColor:(UIColor *)color {
	self.view.backgroundColor = color;
}

- (void)colorPickerWillChooseColor:(MDColorPickerView *)colorPicker {

}

#pragma mark - MDColorsChooserViewDelegate

- (void)  colorsChooser:(MDColorsChooserView*)colorsChooser
        didChangeColors:(NSArray*)colors {

}

- (void)            colorsChooser:(MDColorsChooserView*)colorsChooser
        didChangeColorsRGBStrings:(NSArray*)colorsRGBStrings {
	NSLog(@"%@",colorsRGBStrings);
}

@end
