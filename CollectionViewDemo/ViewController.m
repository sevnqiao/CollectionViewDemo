//
//  ViewController.m
//  CollectionViewDemo
//
//  Created by xiong on 2017/7/27.
//  Copyright © 2017年 xiong. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

#define AVAILABLE_IOS_9_0 [UIDevice currentDevice].systemVersion.floatValue >= 9

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) UIView *tempView;
@property (assign, nonatomic) CGPoint beginPoint;
@property (strong, nonatomic) NSIndexPath *beginIndexPath;
@property (strong, nonatomic) CollectionViewCell *beginCell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.dataArray = [NSMutableArray arrayWithObjects:
                      [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19"] mutableCopy],
                      [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19"] mutableCopy],
                      [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19"] mutableCopy],
                      [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19"] mutableCopy],
                      [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19"] mutableCopy]                      , nil];
    
    

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize =CGSizeMake(80, 30);
    flowLayout.minimumLineSpacing = 11;
    flowLayout.minimumInteritemSpacing = 11;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 11, 10, 11);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.collectionView];
    
    UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longG.minimumPressDuration = 0.2f;
    [self.collectionView addGestureRecognizer:longG];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    [cell cellWithTitle:self.dataArray[indexPath.section][indexPath.row]];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self updateDataWithSourceIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

#pragma mark - longPress手势
- (void)longPress:(UILongPressGestureRecognizer *)lpGesture{
    
    switch(lpGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self collectionViewCellDidBeginChange:lpGesture];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self collectionViewCellDidChange:lpGesture];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self collectionViewCellDidEndChange:lpGesture];
            break;
        }
        default:
            if (AVAILABLE_IOS_9_0)
            {
                [self.collectionView cancelInteractiveMovement];
            }
            break;
    }
}

- (void)collectionViewCellDidBeginChange:(UILongPressGestureRecognizer *)lpGesture
{
    self.beginIndexPath = [self.collectionView indexPathForItemAtPoint:[lpGesture locationInView:self.collectionView]];
    self.beginCell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.beginIndexPath];
    
    if (AVAILABLE_IOS_9_0)
    {
        [self.collectionView beginInteractiveMovementForItemAtIndexPath:self.beginIndexPath];
    }
    else
    {
        // 截图  并隐藏原 cell
        self.tempView = [self.beginCell snapshotViewAfterScreenUpdates:YES];
        self.tempView.frame = self.beginCell.frame;
        [self.collectionView addSubview:self.tempView];
        
        self.beginPoint = [lpGesture locationInView:self.collectionView];
        self.beginCell.hidden = YES;
    }
}

- (void)collectionViewCellDidChange:(UILongPressGestureRecognizer *)lpGesture
{
    CGPoint targetPosion = [lpGesture locationInView:lpGesture.view];
    
    if (AVAILABLE_IOS_9_0)
    {
        [self.collectionView updateInteractiveMovementTargetPosition:targetPosion];
    }
    else
    {
        CGFloat tranX = [lpGesture locationOfTouch:0 inView:self.collectionView].x - self.beginPoint.x;
        CGFloat tranY = [lpGesture locationOfTouch:0 inView:self.collectionView].y - self.beginPoint.y;
        
        // 设置截图视图位置
        self.tempView.center = CGPointApplyAffineTransform(self.tempView.center, CGAffineTransformMakeTranslation(tranX, tranY));
        self.beginPoint = [lpGesture locationOfTouch:0 inView:_collectionView];
        
        // 计算截图视图和哪个cell相交
        for (UICollectionViewCell *cell in [_collectionView visibleCells])
        {
            //跳过隐藏的cell
            if ([_collectionView indexPathForCell:cell] == self.beginIndexPath)
            {
                continue;
            }
            //计算中心距
            CGFloat space = sqrtf(pow(self.tempView.center.x - cell.center.x, 2) + powf(self.tempView.center.y - cell.center.y, 2));
            
            //如果相交一半且两个视图Y的绝对值小于高度的一半就移动
            if (space <= self.tempView.bounds.size.width * 0.5 && (fabs(self.tempView.center.y - cell.center.y) <= self.tempView.bounds.size.height * 0.5))
            {
                NSIndexPath *nextIndexPath = [_collectionView indexPathForCell:cell];
                
                [self updateDataWithSourceIndexPath:self.beginIndexPath toIndexPath:nextIndexPath];
                
                [_collectionView moveItemAtIndexPath:self.beginIndexPath toIndexPath:nextIndexPath];
                
                //设置移动后的起始indexPath
                self.beginIndexPath = nextIndexPath;
                
                break;
            }
        }
    }
}
- (void)collectionViewCellDidEndChange:(UILongPressGestureRecognizer *)lpGesture
{
    if (AVAILABLE_IOS_9_0)
    {
        [self.collectionView endInteractiveMovement];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.tempView.center = self.beginCell.center;
            
        }completion:^(BOOL finished) {
            
            [self.tempView removeFromSuperview];
            self.beginCell.hidden = NO;
        }];
    }
}

#pragma mark - 更新数据源
- (void)updateDataSourceWithDeleteIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = self.dataArray[indexPath.section];
    
    [arr removeObjectAtIndex:indexPath.row];
    
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    [self.collectionView reloadData];
}

- (void)updateDataWithSourceIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.section == destinationIndexPath.section) // 同一个 section 间移动
    {
        for (NSInteger i = MIN(sourceIndexPath.item, destinationIndexPath.item); i < MAX(sourceIndexPath.item, destinationIndexPath.item); i++) {
            [self.dataArray[sourceIndexPath.section] exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
        }
    }
    else // 不同 section 之间移动 ,  删除 sourceData, 插入到 destinationData
    {
        NSMutableArray *sourceArr = self.dataArray[sourceIndexPath.section];
        NSMutableArray *destinationArr = self.dataArray[destinationIndexPath.section];
        
        id obj = [sourceArr objectAtIndex:sourceIndexPath.row];
        
        [sourceArr removeObjectAtIndex:sourceIndexPath.row];
        
        [destinationArr insertObject:obj atIndex:destinationIndexPath.row];
    }
    
}

@end
