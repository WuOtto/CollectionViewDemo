//
//  OttoMistakeLayout.m
//  CollectionViewDemo
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 otto. All rights reserved.
//

#import "OttoMistakeLayout.h"

@interface OttoMistakeLayout ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;    //当前的IndexPath
@property (nonatomic, strong) UIView *mappingImageView;         //拖动cell的截图

@property (nonatomic,strong) NSIndexPath *endFromIndexPath;

@end

@implementation OttoMistakeLayout

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureObserver];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self configureObserver];
    }
    return self;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"collectionView"];
}

#pragma mark - setup

- (void)configureObserver{
    [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setUpGestureRecognizers{
    if (self.collectionView == nil) {
        return;
    }
    _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    _longPress.minimumPressDuration = 0.2f;
    _longPress.delegate = self;
    [self.collectionView addGestureRecognizer:_longPress];
}

#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"collectionView"]) {
        [self setUpGestureRecognizers];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint location = [longPress locationInView:self.collectionView];
            NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:location];
            if (!indexPath) return;
            
            self.currentIndexPath = indexPath;
            _endFromIndexPath = self.currentIndexPath;
            UICollectionViewCell* targetCell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            //得到当前cell的映射(截图)
            UIView* cellView = [targetCell snapshotViewAfterScreenUpdates:YES];
            self.mappingImageView = cellView;
            self.mappingImageView.frame = cellView.frame;
            targetCell.hidden = YES;
            [self.collectionView addSubview:self.mappingImageView];
            
            cellView.center = targetCell.center;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [longPress locationInView:self.collectionView];
            //更新cell的位置
            self.mappingImageView.center = point;
            NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath == nil ){
                return;
            }
            if (![indexPath isEqual:self.currentIndexPath])
            {
                [self.collectionView moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                self.currentIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            
        [UIView animateWithDuration:0.25 animations:^{
                self.mappingImageView.center = cell.center;
            } completion:^(BOOL finished) {
                //改变数据源
                if ([self.delegate respondsToSelector:@selector(moveDataItem:toIndexPath:)]) {
                    [self.delegate moveDataItem:self.endFromIndexPath toIndexPath:self.currentIndexPath];
                }
                if ([self.delegate respondsToSelector:@selector(endMove)]) {
                    [self.delegate endMove];
                }
                [self.mappingImageView removeFromSuperview];
                cell.hidden           = NO;
                self.mappingImageView = nil;
                self.currentIndexPath = nil;
            }];
        }
            
            break;
        default:
        {
            
        }
            break;
    }
    
    
}

@end

