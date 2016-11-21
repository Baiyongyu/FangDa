//
//  ViewController.m
//  头视图下拉放大
//
//  Created by 宇玄丶 on 2016/10/20.
//  Copyright © 2016年 宇玄丶. All rights reserved.
//

#import "ViewController.h"

#define kScreenbounds [UIScreen mainScreen].bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define pictureHeight 200

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIView *header;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 下面两个属性的设置是与translucent为NO,坐标变换的效果一样
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createTableView];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // 添加头视图 在头视图上添加ImageView
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, pictureHeight)];
    _pictureImageView = [[UIImageView alloc] initWithFrame:_header.bounds];
    _pictureImageView.image = [UIImage imageNamed:@"meinv.jpg"];

    // 这个属性的值决定了 当视图的几何形状变化时如何复用它的内容 这里用 UIViewContentModeScaleAspectFill 意思是保持内容高宽比 缩放内容 超出视图的部分内容会被裁减 填充UIView
    _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    // 这个属性决定了子视图的显示范围 取值为YES时，剪裁超出父视图范围的子视图部分.这里就是裁剪了_pictureImageView超出_header范围的部分.
    _pictureImageView.clipsToBounds = YES;
    [_header addSubview:_pictureImageView];
    self.tableView.tableHeaderView = _header;
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @"下拉查看动画效果";
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /**
     *  这里的偏移量是纵向从contentInset算起 则一开始偏移就是0 向下为负 上为正 下拉
     */
    // 获取到tableView偏移量
    CGFloat Offset_y = scrollView.contentOffset.y;
    // 下拉 纵向偏移量变小 变成负的
    if ( Offset_y < 0) {
        // 拉伸后图片的高度
        CGFloat totalOffset = pictureHeight - Offset_y;
        // 图片放大比例
        CGFloat scale = totalOffset / pictureHeight;
        CGFloat width = kScreenWidth;
        // 拉伸后图片位置
        _pictureImageView.frame = CGRectMake(-(width * scale - width) / 2, Offset_y, width * scale, totalOffset);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
