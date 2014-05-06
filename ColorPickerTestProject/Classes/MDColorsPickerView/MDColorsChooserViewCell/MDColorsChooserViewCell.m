//
//  MDColorsChooserViewCell.m
//  ColorPickerTestProject
//
//  Created by Nikolay Rybalko on 2/4/14.
//  Copyright (c) 2014 Nickolay Rybalko. All rights reserved.
//

#import "MDColorsChooserViewCell.h"
#import "MDColorsChooserViewCross.h"

@interface MDColorsChooserViewCell ()

@property (weak, nonatomic) IBOutlet UIView *colorChooseView;
@property (weak, nonatomic) IBOutlet MDColorsChooserViewCross *crossView;

@end

@implementation MDColorsChooserViewCell

+ (NSString*)reuseIdentifier {
	static NSString *reuseIdentifier = nil;
	if (reuseIdentifier==Nil) {
		reuseIdentifier = NSStringFromClass(self);
	}
	return reuseIdentifier;
}

+ (UINib*)nib {
	return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initializeColorsChooserViewCell];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self initializeColorsChooserViewCell];
}

- (void)initializeColorsChooserViewCell {
	self.colorChooseView.layer.cornerRadius = 5;
	self.colorChooseView.layer.masksToBounds = YES;
}

- (void)setChoosedColor:(UIColor *)choosedColor {
	_choosedColor = choosedColor;
	self.colorChooseView.backgroundColor = choosedColor;
	self.crossView.crossColor = choosedColor;
}

@end
