//
//  OttoCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by apple on 2018/7/30.
//  Copyright © 2018年 otto. All rights reserved.
//

#import "OttoCollectionViewCell.h"

@implementation OttoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // label
        [self.contentView addSubview:self.labelText];
        self.labelText.backgroundColor = [UIColor lightGrayColor];
        self.labelText.frame = CGRectMake(20, 20, self.contentView.frame.size.width - 40, self.contentView.frame.size.height - 40);
        self.labelText.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (UILabel *)labelText{
    if (!_labelText) {
        _labelText = [[UILabel alloc] init];
    }
    return _labelText;
}
@end
