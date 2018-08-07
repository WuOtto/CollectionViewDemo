//
//  OttoMistakeLayout.h
//  CollectionViewDemo
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 otto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OttoMistakeLayoutDelegate <NSObject>

//去改变数据源
- (void)moveDataItem:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath;

- (void)endMove;

@end

@interface OttoMistakeLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id <OttoMistakeLayoutDelegate> delegate;

@end
