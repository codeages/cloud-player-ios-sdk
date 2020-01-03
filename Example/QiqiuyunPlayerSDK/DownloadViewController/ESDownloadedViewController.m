//
//  ESDownloadedViewController.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/12/3.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESDownloadedViewController.h"

@interface ESDownloadedViewController ()
@property (strong, nonatomic) NSMutableArray<ESM3U8DownloadTask *> *deleteArray;
@end

@implementation ESDownloadedViewController
- (NSMutableArray<ESM3U8DownloadTask *> *)deleteArray {
    if (!_deleteArray) {
        _deleteArray = [@[] mutableCopy];
    }
    return _deleteArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *allSelectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [allSelectedButton setTitle:@"      全选      " forState:UIControlStateNormal];
    [allSelectedButton setTitle:@"      取消      " forState:UIControlStateSelected];
    [allSelectedButton addTarget:self action:@selector(allSelected:) forControlEvents:UIControlEventTouchUpInside];
    [allSelectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *allselectedItem = [[UIBarButtonItem alloc]initWithCustomView:allSelectedButton];
    
    UIBarButtonItem *removeItem = [[UIBarButtonItem alloc]initWithTitle:@"      清除样本   " style:UIBarButtonItemStylePlain target:self action:@selector(allRemove:)];
    [removeItem setTintColor:[UIColor redColor]];
    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc]initWithTitle:@"        " style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc]initWithTitle:@"        " style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.bottomToolBar setItems:@[allselectedItem, spaceItem1, spaceItem2, removeItem] animated:YES];
    
    [self.m3u8Mgr.tasks enumerateObjectsUsingBlock:^(__kindof ESDownloadTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.status == ESDownloadStatusSucceeded) {
            [self.tasks addObject:obj];
        }
    }];
    self.shouldEdit = YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        [self.deleteArray addObject:[self.tasks objectAtIndex:indexPath.row]];
    }else{
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (tableView.isEditing) {
        [self.deleteArray removeObject:[self.tasks objectAtIndex:indexPath.row]];
    }
}

- (void)allSelected:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        for (int i = 0; i < self.tasks.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        if (self.deleteArray.count > 0) {
            [self.deleteArray removeAllObjects];
        }
        [self.deleteArray addObjectsFromArray:self.tasks];
    }else{
         for (int i = 0; i< self.tasks.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
             [self.deleteArray removeAllObjects];
        }
    }
}

- (void)allRemove:(UIButton *)sender {
    @weakify(self)
    [self.deleteArray enumerateObjectsUsingBlock:^(ESM3U8DownloadTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        [task remove:YES handler:^(id t) {
            @strongify(self);
            self.tableView.editing = NO;
            self.rightButton.selected = NO;
            self.bottomToolBar.hidden = YES;
            [self.tasks removeObject:t];
            [self.tableView reloadData];
        }];
    }];
}

- (void)m3u8DownloadSuccess:(ESM3U8DownloadTask *)task{
    [self.tasks addObject:task];
    [self.tableView reloadData];
}

- (void)m3u8DownloadFailure:(ESM3U8DownloadTask *)task{
    
}

@end
