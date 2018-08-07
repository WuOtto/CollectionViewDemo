//
//  CustomViewController.m
//  CollectionViewDemo
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 otto. All rights reserved.
//

#import "CustomViewController.h"
#import "OttoCollectionViewCell.h"
#import "OttoMistakeLayout.h"

@interface CustomViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,OttoMistakeLayoutDelegate>

@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic,strong) OttoMistakeLayout *ottoLayout;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation CustomViewController

- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        
        _ottoLayout = [[OttoMistakeLayout alloc] init];
        _ottoLayout.minimumLineSpacing = 1;
        _ottoLayout.delegate = self;
        _ottoLayout.minimumInteritemSpacing = 1;
        _ottoLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
        _ottoLayout.headerReferenceSize = CGSizeMake(Screen_Width, 0.f);
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, Screen_Width, Screen_Height - 20) collectionViewLayout:_ottoLayout];
        
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = [UIColor colorWithRed:0.8568 green:0.8568 blue:0.8568 alpha:1.0];
        _mainCollectionView.delegate = self;
        [_mainCollectionView registerClass:[OttoCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentiifer"];
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
}

- (void)moveDataItem:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath{
    NSLog(@"从%ld移动到%ld",fromIndexPath.item,toIndexPath.item);
}

- (void)endMove{
    
}
#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OttoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentiifer" forIndexPath:indexPath];
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
    
    OttoCollectionViewCell *cell = (OttoCollectionViewCell *)[self.mainCollectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.1 animations:^{
        //        cell.transform = CGAffineTransformMakeScale(0.8, 0.8);
        cell.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            //这里实现点击cell后要实现的内容
        }];
    }];
    
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
