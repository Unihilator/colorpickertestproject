//
//  MDColorsChooserView.m
//  ColorPickerTestProject
//
//  Created by Nikolay Rybalko on 2/4/14.
//  Copyright (c) 2014 Nickolay Rybalko. All rights reserved.
//

#import "MDColorsChooserView.h"

#import "MDColorsChooserViewCell.h"
#import "MDColorPickerView.h"

NSUInteger const kMDColorsChooserMaxNumOfColors = 10;
CGSize const kMDColorsChooserCellSize = { 26.0,26.0 };


@interface MDColorsChooserView ()<MDColorPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) MDColorPickerView *colorPickerView;
@property (weak, nonatomic) UICollectionView *colorsCollectionView;

@property (nonatomic, strong) NSMutableArray *colorsDatasource;

@end

@implementation MDColorsChooserView

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - lifeCycle

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initializeColorsChooserView];
	}
	return self;
}

- (id)init {
	self = [super init];
	if (self) {
		[self initializeColorsChooserView];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self initializeColorsChooserView];
}

#pragma mark - initialize

- (void)initializeColorsChooserView {
	[self initializeOutlets];
	[self initializeColorPicker];
	[self initializeDatasourse];
	self.maxNumColors = kMDColorsChooserMaxNumOfColors;
}

- (void)initializeOutlets {
	[self initializeCollectionView];
}

- (void)initializeColorPicker {
	MDColorPickerView *colorPickerView = [[MDColorPickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 55)];
	self.colorPickerView = colorPickerView;
	[self addSubview:colorPickerView];
	self.colorPickerView.delegate = self;
}

- (void)initializeCollectionView {
	UICollectionViewFlowLayout *defaultFlowLayoyt = [self defaultFlowLayout];
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 55, CGRectGetWidth(self.frame), 30) collectionViewLayout:defaultFlowLayoyt];
	collectionView.backgroundColor = [UIColor clearColor];
	[self addSubview:collectionView];
	self.colorsCollectionView = collectionView;
	self.colorsCollectionView.delegate = self;
	self.colorsCollectionView.dataSource = self;
}

- (UICollectionViewFlowLayout*)defaultFlowLayout {
	UICollectionViewFlowLayout *defaultFlowLayout = [UICollectionViewFlowLayout new];
	defaultFlowLayout.itemSize = kMDColorsChooserCellSize;
	defaultFlowLayout.footerReferenceSize = CGSizeZero;
	defaultFlowLayout.headerReferenceSize = CGSizeZero;
	defaultFlowLayout.sectionInset = UIEdgeInsetsMake(4, 15, 0, 15);
	defaultFlowLayout.minimumLineSpacing = 10;
	defaultFlowLayout.minimumInteritemSpacing = 3;
	return defaultFlowLayout;
}

- (void)initializeDatasourse {
	self.colorsDatasource = [[NSMutableArray alloc] initWithCapacity:kMDColorsChooserMaxNumOfColors];
	[self.colorsCollectionView reloadData];
	[self.colorsCollectionView registerNib:[MDColorsChooserViewCell nib]
	            forCellWithReuseIdentifier:[MDColorsChooserViewCell reuseIdentifier]];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - MDColorPickerViewDelegate

- (void)colorPicker:(MDColorPickerView *)colorPicker didChooseColor:(UIColor *)color {
	[self addNewColor:color];
	self.colorsCollectionView.userInteractionEnabled = YES;
}

- (void)colorPickerWillChooseColor:(MDColorPickerView *)colorPicker {
	self.colorsCollectionView.userInteractionEnabled = NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - collectionViewDatasourse

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MDColorsChooserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MDColorsChooserViewCell reuseIdentifier]
	                                                                          forIndexPath:indexPath];

	cell.choosedColor = self.colorsDatasource[indexPath.row];
	return cell;
}

- (NSInteger)   collectionView:(UICollectionView *)collectionView
        numberOfItemsInSection:(NSInteger)section {
	collectionView.contentInset = UIEdgeInsetsZero;
	return self.colorsDatasource.count;
}

- (void)          collectionView:(UICollectionView *)collectionView
        didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[self removeColorAtIndexPath:indexPath];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - add/removeColors

- (void)addNewColor:(UIColor*)color {
	if (self.colorsDatasource.count >= self.maxNumColors) {
		return;
	}
	[self.colorsDatasource addObject:color];
	NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.colorsDatasource.count-1
	                                                 inSection:0];
	[self.colorsCollectionView insertItemsAtIndexPaths:@[lastIndexPath]];
	[self didChangeColors];
}

- (void)removeColorAtIndexPath:(NSIndexPath*)indexPath {
	[self.colorsDatasource removeObjectAtIndex:indexPath.row];
	[self.colorsCollectionView deleteItemsAtIndexPaths:@[indexPath]];
	[self didChangeColors];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - MDColorsChooserViewDelegate calls

- (void)didChangeColors {
	if (self.delegate && [self.delegate respondsToSelector:@selector(colorsChooser:didChangeColorsRGBStrings:)]) {
		[self.delegate colorsChooser:self didChangeColorsRGBStrings:[self currentColorsRGBStrings]];
	}
	if (self.delegate && [self.delegate respondsToSelector:@selector(colorsChooser:didChangeColors:)]) {
		[self.delegate colorsChooser:self didChangeColors:self.colorsDatasource.copy];
	}
}

- (NSArray*)colorsRGBStrings {
	NSMutableArray *colorsRGBStrings = [[NSMutableArray alloc] initWithCapacity:self.colorsDatasource.count];
	for (UIColor *color in self.colorsDatasource) {
		NSString *hexString = [self hexStringFromColor:color];
		[colorsRGBStrings addObject:hexString];
	}
	return colorsRGBStrings.copy;
}

- (NSString*)hexStringFromColor:(UIColor*)color {
	const CGFloat* components = CGColorGetComponents(color.CGColor);
	NSString *hexString = [NSString stringWithFormat:@"%02X%02X%02X"
	                       ,(unsigned char)(components[0]*255+0.5)
	                       ,(unsigned char)(components[1]*255+0.5)
	                       ,(unsigned char)(components[2]*255+0.5)];
	return hexString;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - public

- (NSArray*)currentColors {
	return self.colorsDatasource.copy;
}

- (NSArray*)currentColorsRGBStrings {
	return [self colorsRGBStrings];
}

- (UICollectionViewFlowLayout*)layout {
	return (UICollectionViewFlowLayout*)self.colorsCollectionView.collectionViewLayout;
}

@end
