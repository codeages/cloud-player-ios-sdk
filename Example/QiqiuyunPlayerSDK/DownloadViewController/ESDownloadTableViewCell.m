//
//  ESDownloadTableViewCell.m
//  ESCloudPlayerSDK_Example
//
//  Created by aaayi on 2019/11/28.
//  Copyright © 2019 aaayia. All rights reserved.
//

#import "ESDownloadTableViewCell.h"
#import <YYKit/YYKit.h>
#import "UIButton+PKDownloadButton.h"
#import <UIColor+YYAdd.h>
#import "PKCircleView+Edusoho.h"

#define COLORS [UIColor colorWithRGB:GREEN_COLOR_RGB]
#define RED_COLORS [UIColor colorWithRGB:RED_COLOR_RGB]
@interface ESDownloadTableViewCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *bufferView;

@end
@implementation ESDownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ready:) name:ESM3U8DownloadManagerReadyNotification object:nil];
    
    self.bufferView.hidden = YES;
    self.downloadButton.hidden = NO;

    [self.downloadButton.downloadedButton cleanDefaultAppearance];
    [self.downloadButton.downloadedButton setTintColor:UIColor.redColor];
    [self.downloadButton.downloadedButton setImage:[UIImage imageNamed:@"download-success"] forState:UIControlStateNormal];
    
    [self.downloadButton.stopDownloadButton setCircleColor:COLORS];
//    self.downloadButton.stopDownloadButton.stopButtonWidth = 7;
    self.downloadButton.stopDownloadButton.filledLineStyleOuter = YES;
    self.downloadButton.stopDownloadButton.emptyLineWidth = 1.0f;
    self.downloadButton.stopDownloadButton.filledLineWidth = 1.0f;
    self.downloadButton.stopDownloadButton.radius = 11.0f;

    [self.downloadButton.stopDownloadButton.stopButton cleanDefaultAppearance];
    [self.downloadButton.stopDownloadButton.stopButton setImage:[UIImage imageNamed:@"download-start"] forState:UIControlStateNormal];
    [self.downloadButton.stopDownloadButton.stopButton setImage:[UIImage imageNamed:@"download-paused"] forState:UIControlStateSelected];

    self.downloadButton.pendingView.tintColor = COLORS;
    self.downloadButton.pendingView.radius = 11.0f;
    self.downloadButton.pendingView.emptyLineRadians = 1.f;
    
    [self.downloadButton.startDownloadButton cleanDefaultAppearance];
    [self.downloadButton.startDownloadButton setImage:[UIImage imageNamed:@"download-start"] forState:UIControlStateNormal];

    [self configButtonState:ESDownloadStatusUnknow];
    
    @weakify(self)
    self.downloadButton.callback = ^(PKDownloadButton *downloadButton, PKDownloadButtonState state) {
        @strongify(self)
        switch (state) {
            case kPKDownloadButtonState_StartDownload: {
                if (self.tap) {
                    self.tap(self.task);
                }
                break;
            }
            case kPKDownloadButtonState_Downloading: {
                if (self.tap) {
                    self.tap(self.task);
                }
                break;
            }
            default:
                break;
        }
    };
    [self configButtonState:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (float)progress{
    float progress = 0;
    if (self.task.progress.totalUnitCount > 0) {
        progress = self.task.progress.completedUnitCount / (self.task.progress.totalUnitCount  *1.0);
    }
    if (progress > 1) {
        progress  = 1;
    }
    if (progress < 0) {
        progress  = 0;
    }
   return progress;
}

- (void)setTask:(ESM3U8DownloadTask *)task{
    _task = task;
    @weakify(self)
    [task progress:YES handler:^(ESM3U8DownloadTask *t) {
        [self configButtonState:t.status];
    }];
    
    [task success:YES handler:^(ESM3U8DownloadTask *t) {
        @strongify(self);
        [self configButtonState:t.status];
    }];
    
    [task failure:YES handler:^(ESM3U8DownloadTask *t) {
        @strongify(self);
        [self configButtonState:t.status];
    }];
    if (task) {
        [self configButtonState:task.status];
    }
}


- (void)configButtonState:(ESDownloadStatus )status {

    self.downloadButton.startDownloadButton.enabled = YES;
    [self.downloadButton.stopDownloadButton setCircleColor:COLORS];
    self.downloadButton.userInteractionEnabled = YES;
    switch (status) {
        case ESDownloadStatusSucceeded:{
            self.downloadButton.userInteractionEnabled = NO;
            self.downloadButton.state = kPKDownloadButtonState_Downloaded;
            break;
        }
        case ESDownloadStatusRunning:{
            self.downloadButton.state = kPKDownloadButtonState_Downloading;
            self.downloadButton.stopDownloadButton.progress = self.progress;
            [self.downloadButton.stopDownloadButton setCircleColor:COLORS];
            self.downloadButton.stopDownloadButton.stopButton.selected = NO;
            break;
        }
        case ESDownloadStatusFailed:{
            self.downloadButton.state = kPKDownloadButtonState_Downloading;
            self.downloadButton.stopDownloadButton.progress = self.progress;
            [self.downloadButton.stopDownloadButton setCircleColor:RED_COLORS];
            self.downloadButton.stopDownloadButton.stopButton.selected = YES;
            break;
        }
        case ESDownloadStatusWaiting:{
            self.downloadButton.state = kPKDownloadButtonState_Pending;
            self.downloadButton.pendingView.tintColor = COLORS;
            [self.downloadButton.pendingView startSpin];
            break;
        }
        case ESDownloadStatusSuspended:{
            self.downloadButton.state = kPKDownloadButtonState_Downloading;
            self.downloadButton.stopDownloadButton.progress = self.progress;
            [self.downloadButton.stopDownloadButton setCircleColor:RED_COLORS];
            self.downloadButton.stopDownloadButton.stopButton.selected = YES;

            break;
        }
        default:{
            self.downloadButton.state = kPKDownloadButtonState_StartDownload;
//            [self.downloadButton.startDownloadButton setImage:[UIImage imageNamed:@"DownloadStart"] forState:UIControlStateNormal];
            break;
        }
    }

}


- (void)ready:(NSNotification *)note {
    NSString *resNo = note.userInfo[@"resNo"];
    BOOL isStop = [note.userInfo[@"isStop"] boolValue];
    if ([resNo isEqualToString:self.resNo]) {
        if (!isStop) {
            self.downloadButton.hidden = YES;
            self.bufferView.hidden = NO;
            [self.bufferView startAnimating];
        }else{
            self.downloadButton.hidden = NO;
            self.bufferView.hidden = YES;
            [self.bufferView stopAnimating];
        }
        [self configButtonState:self.task.status];
    }
}
@end
