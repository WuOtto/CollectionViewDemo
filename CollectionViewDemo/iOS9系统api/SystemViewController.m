//
//  SystemViewController.m
//  CollectionViewDemo
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 otto. All rights reserved.
//

#import "SystemViewController.h"
#import "OttoCollectionViewCell.h"

@interface SystemViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation SystemViewController

- (UICollectionView *)mainCollectionView{
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
        [self.array addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    
    [self.view addSubview:self.mainCollectionView];
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    
    [self.mainCollectionView addGestureRecognizer:_longPress];
}

- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress{
    
    CGPoint point = [longPress locationInView:_mainCollectionView];
    NSIndexPath *indexPath = [self.mainCollectionView indexPathForItemAtPoint:point];
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            
            if (!indexPath) {
                break;
            }
            
            BOOL canMove = [_mainCollectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            if (!canMove) {
                break;
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            [_mainCollectionView updateInteractiveMovementTargetPosition:point];
            break;
            
        case UIGestureRecognizerStateEnded:
            [_mainCollectionView endInteractiveMovement];
            break;
            
        default:
            [_mainCollectionView cancelInteractiveMovement];
            break;
    }
    
}

#pragma mark - CollectionViewDelegate

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

#pragma mark - iOS9 api
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//当移动结束的时候会调用这个方法。
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    /**
     *sourceIndexPath 原始数据 indexpath
     * destinationIndexPath 移动到目标数据的 indexPath
     */
    //取出源item数据
    id obj = [self.array objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.array removeObject:obj];
    //将数据插入到资源数组中的目标位置上
    [self.array insertObject:obj atIndex:destinationIndexPath.item];
    
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
