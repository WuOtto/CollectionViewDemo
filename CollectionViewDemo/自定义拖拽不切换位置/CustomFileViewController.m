//
//  CustomFileViewController.m
//  CollectionViewDemo
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 otto. All rights reserved.
//

#import "CustomFileViewController.h"
#import "OttoCollectionViewCell.h"

@interface CustomFileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;    //当前的IndexPath
@property (nonatomic, strong) UIView *mappingImageView;

@property (nonatomic,strong)NSIndexPath *endFromIndexPath;
@property (nonatomic,strong)NSIndexPath *endToIndexPath;

@end

@implementation CustomFileViewController

- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {

        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 1;
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, Screen_Width, Screen_Height - 20) collectionViewLayout:_flowLayout];

        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = [UIColor colorWithRed:0.8568 green:0.8568 blue:0.8568 alpha:1.0];
        _mainCollectionView.delegate = self;
        [_mainCollectionView registerClass:[OttoCollectionViewCell class] forCellWithReuseIdentifier:@"OttoCollectionViewCell"];
    }
    return _mainCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i++) {
        [self.array addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    
    [self.view addSubview:self.mainCollectionView];
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    
    [self.mainCollectionView addGestureRecognizer:_longPress];
}

- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress{
    if (self.array.count <= 1) {
        return;
    }
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint location = [longPress locationInView:self.mainCollectionView];
            NSIndexPath* indexPath = [self.mainCollectionView indexPathForItemAtPoint:location];
            if (!indexPath) return;
            
            self.currentIndexPath = indexPath;
            
            _endFromIndexPath = self.currentIndexPath;
            UICollectionViewCell* targetCell = [self.mainCollectionView cellForItemAtIndexPath:self.currentIndexPath];
            //得到当前cell的映射(截图)
            UIView* cellView = [targetCell snapshotViewAfterScreenUpdates:YES];
            self.mappingImageView = cellView;
            self.mappingImageView.frame = cellView.frame;
            targetCell.hidden = YES;
            [self.mainCollectionView addSubview:self.mappingImageView];
            
            cellView.center = targetCell.center;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [longPress locationInView:self.mainCollectionView];
            //更新cell的位置
            self.mappingImageView.center = point;
            NSIndexPath * indexPath = [self.mainCollectionView indexPathForItemAtPoint:point];
            if (indexPath == nil ){
                _endToIndexPath = self.currentIndexPath;
                return;
            }
            _endToIndexPath = indexPath;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            
            UICollectionViewCell *cell = [self.mainCollectionView cellForItemAtIndexPath:self.currentIndexPath];
            UICollectionViewCell *testCell = [self.mainCollectionView cellForItemAtIndexPath:_endToIndexPath];
            if (self.currentIndexPath == _endToIndexPath) {
                [self.mappingImageView removeFromSuperview];
                cell.hidden           = NO;
                self.mappingImageView = nil;
                self.currentIndexPath = nil;
                return;
            }
            self.mappingImageView.center = testCell.center;
            // 放大缩小动画
            [UIView animateWithDuration:0.3 animations:^{
                // 放大
                self.mappingImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    // 缩小
                    self.mappingImageView.transform = CGAffineTransformMakeScale(0.6, 0.6);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3 animations:^{
                        // 还原
                        //                        self.mappingImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        self.mappingImageView.transform = CGAffineTransformMakeScale(0.3, 0.3);
                    } completion:^(BOOL finished) {
                        [self.array removeObjectAtIndex:self.endFromIndexPath.item];
                        [self.mainCollectionView reloadData];
                        NSLog(@"最终从%ld移动到%ld",(long)self.endFromIndexPath.item,(long)self.endToIndexPath.item);
                        [self.mappingImageView removeFromSuperview];
                        cell.hidden           = NO;
                        [cell removeFromSuperview];
                        self.mappingImageView = nil;
                        self.currentIndexPath = nil;
                        
                    }];
                }];
            }];
            
        }
            break;
        default:
        {
            
        }
            break;
    }
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OttoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OttoCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.labelText.text = self.array[indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Screen_Width / 3 - 1.5, Screen_Width / 3 - 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
