//
//  ESPopoverView.m
//  EduSoho
//
//  Created by Edusoho on 14-10-10.
//  Copyright (c) 2015年 Kuozhi Network Technology. All rights reserved.
//

#import "ESPopoverView.h"

#define SPACE 2
#define ROW_HEIGHT 44
#define TITLE_FONT [UIFont systemFontOfSize:14]

@interface ESPopoverView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIWindow *backWindow;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray <UIImage *>*imageArray;
@property (nonatomic, assign) ESPopoverAnimationType popoverAnimationType;
@property (nonatomic, assign) BOOL isUpward;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, strong) NSMutableArray *maskRedArray;

@end

@implementation ESPopoverView

- (instancetype)initWithView:(UIView *)view titles:(NSArray *)titles images:(NSArray *)images {
    self = [super init];
    if (self) {
        CGRect pointViewRect = [view.superview convertRect:view.frame toView:nil];
        _showPoint = CGPointMake(CGRectGetMidX(pointViewRect), 0);
        _titleArray = [NSMutableArray arrayWithArray:titles];
        if (CGRectGetMinY(pointViewRect) > CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetMaxY(pointViewRect)) {
            _showPoint.y = CGRectGetMinY(pointViewRect) - 2;
            _isUpward = YES;
        } else {
            _showPoint.y = CGRectGetMaxY(pointViewRect) + 2;
            _isUpward = NO;
        }
        _imageArray = images;
        self.backColor = [UIColor whiteColor];
        self.titleColor = [UIColor blackColor];
        _selectedIndex = -1;
        _index = -1;
        _selectedTitleColor = [UIColor colorWithRed:3/255.0 green:199/255.0 blue:119/255.0 alpha:1];
        for (int i = 0; i < _titleArray.count; i ++) {
            [self.maskRedArray addObject:@0];
        }
    }
    return self;
}

- (instancetype)initWithEvent:(UIEvent *)event titles:(NSArray *)titles images:(NSArray *)images {
    return [self initWithView:[event.allTouches.anyObject view] titles:titles images:images];
}

- (instancetype)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images {
    self = [super init];
    if (self) {
        _showPoint = point;
        _titleArray = [NSMutableArray arrayWithArray:titles];
        _imageArray = images;
        self.backColor = [UIColor whiteColor];
        self.titleColor = [UIColor blackColor];
        _selectedIndex = -1;
        _index = -1;
        _selectedTitleColor = [UIColor colorWithRed:3/255.0 green:199/255.0 blue:119/255.0 alpha:1];
        for (int i = 0; i < _titleArray.count; i ++) {
            [self.maskRedArray addObject:@0];
        }
    }
    return self;
}

- (NSMutableArray *)maskRedArray {
    if (!_maskRedArray) {
        _maskRedArray = [NSMutableArray array];
    }
    return _maskRedArray;
}

- (NSMutableArray *)colorArray {
    if (!_colorArray) {
        _colorArray = [NSMutableArray array];
    }
    return _colorArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self dismissWithAninamtionType:_popoverAnimationType];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissWithAninamtionType:_popoverAnimationType];
}

- (void)show {
    [self showWithAnimationType:ESPopoverAnimationNone];
}

- (void)showWithAnimationType:(ESPopoverAnimationType)animationType {
    _popoverAnimationType = animationType;
    _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backWindow.rootViewController = self;
    _backWindow.windowLevel = UIWindowLevelAlert;
    [_backWindow makeKeyAndVisible];
    
    if (animationType != ESPopoverAnimationNone) {
        
    }
}

- (CGRect)getViewFrame {
    CGRect frame = CGRectZero;
    frame.size.height = [_titleArray count] * ROW_HEIGHT;
    
    for (NSString *title in _titleArray) {
        CGFloat width = [title boundingRectWithSize:CGSizeMake(300, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : TITLE_FONT} context:nil].size.width;
        frame.size.width = MAX(width, frame.size.width);
    }
    
    if ([_titleArray count] == [_imageArray count]) {
        frame.size.width = 10 + 25 + 10 + frame.size.width + 30;
    } else {
        frame.size.width = 10 + frame.size.width + 30;
    }
    
    frame.origin.x = _showPoint.x - frame.size.width / 2;
    frame.origin.y = _showPoint.y - (_isUpward ? frame.size.height : 0);
    
    if (frame.origin.x < 2) {
        frame.origin.x = 2;
    }
    if ((frame.origin.x + frame.size.width) > self.view.bounds.size.width - 2) {
        frame.origin.x = self.view.bounds.size.width - 2 - frame.size.width;
    }
    
    if (frame.origin.y < 2) {
        frame.origin.y = 2;
    }
    if (frame.origin.y + frame.size.height > self.view.bounds.size.height - 2) {
        frame.origin.y = frame.origin.y - frame.size.height - 2;
    }
    
    return frame;
}

- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    _tableView.backgroundColor = _backColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self.colorArray removeAllObjects];
    for (int i = 0; i < _titleArray.count; i ++) {
        [self.colorArray addObject:_titleColor];
    }
    [_tableView reloadData];
}

- (void)dismissWithAninamtionType:(ESPopoverAnimationType)popoverAnimationType {
    if (popoverAnimationType == ESPopoverAnimationNone) {
        [self dismiss:NO];
    } else {
        [self dismiss:YES];
    }
}

- (void)dismiss:(BOOL)animate {
    if (!animate) {
        [_backWindow resignKeyWindow];
        [_backWindow setHidden:YES];
        _backWindow = nil;
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        return;
    }
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveLinear animations:^{
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _showPoint.y, _tableView.bounds.size.width, _tableView.bounds.size.height);
        self.view.alpha = 0;
        _tableView.alpha = 0;
    } completion:^(BOOL finished) {
        [_backWindow resignKeyWindow];
        [_backWindow setHidden:YES];
        _backWindow = nil;
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    }];
}

#pragma mark - UITableView

- (UITableView *)tableView {
    if (_tableView != nil) {
        return _tableView;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:[self getViewFrame] style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.rowHeight = ROW_HEIGHT;
    _tableView.backgroundColor = _backColor;
    _tableView.layer.cornerRadius = 4;
    _tableView.clipsToBounds = YES;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    return _tableView;
}

- (void)reloadIndex:(NSInteger)index title:(NSString *)title titleColor:(UIColor *)color {
    if (0 <= index < _titleArray.count) {
        [_titleArray removeObjectAtIndex:index];
        [_colorArray removeObjectAtIndex:index];
        [_colorArray insertObject:color atIndex:index];
        [_titleArray insertObject:title atIndex:index];
        [_tableView reloadData];
    }
}

- (void)showMaskRedBadgeIndex:(NSInteger)index {
    if (0 <= index < _titleArray.count) {
        [_maskRedArray removeObjectAtIndex:index];
        [_maskRedArray insertObject:@1 atIndex:index];
        [_tableView reloadData];
    }
}

- (void)clearMskRedBadgeIndex:(NSInteger)index {
    if (0 <= index < _titleArray.count) {
        [_maskRedArray removeObjectAtIndex:index];
        [_maskRedArray insertObject:@0 atIndex:index];
        [_tableView reloadData];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([_imageArray count] == [_titleArray count]) {
        cell.imageView.image = _imageArray[indexPath.row];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = TITLE_FONT;
    cell.textLabel.textColor = _colorArray[indexPath.row];
    cell.textLabel.highlightedTextColor = _selectedTitleColor;
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = [UIView new];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectRowAtIndex) {
        _selectRowAtIndex(indexPath.row);
    }
    [self dismissWithAninamtionType:_popoverAnimationType];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    [self.borderColor set]; //设置线条颜色
//    
//    CGRect frame = CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height - kArrowHeight);
//    
//    float xMin = CGRectGetMinX(frame);
//    float yMin = CGRectGetMinY(frame);
//    
//    float xMax = CGRectGetMaxX(frame);
//    float yMax = CGRectGetMaxY(frame);
//    
//    CGPoint arrowPoint = [self convertPoint:_showPoint fromView:_handerView];
//    
//    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
//    [popoverPath moveToPoint:CGPointMake(xMin, yMin)];//左上角
//    
//    /********************向上的箭头**********************/
//    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
//    [popoverPath addCurveToPoint:arrowPoint
//                   controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin)
//                   controlPoint2:arrowPoint];//actual arrow point
//    
//    [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin)
//                   controlPoint1:arrowPoint
//                   controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
//    /********************向上的箭头**********************/
//    
//    
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];//右上角
//    
//    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];//右下角
//    
//    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];//左下角
//    
//    //填充颜色
//    [RGB(245, 245, 245) setFill];
//    [popoverPath fill];
//    
//    [popoverPath closePath];
//    [popoverPath stroke];
//}


@end
