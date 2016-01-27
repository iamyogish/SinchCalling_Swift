/*
 * Copyright (c) 2015 Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Sinch/SINExport.h>

/**
 * If input position is front-facing camera, returns back-facing camera.
 * If input position is back-facing camera, returns front-facing camera.
 * If input is AVCaptureDevicePositionUnspecified, returns input.
 */
SIN_EXPORT AVCaptureDevicePosition SINToggleCaptureDevicePosition(AVCaptureDevicePosition position);

@protocol SINVideoController <NSObject>

/**
 * Indicates the capture device position (front-facing or back-facing
 * camera) currently in use. This property may be set to to change
 * which capture device should be used.
 */
@property (nonatomic, assign, readwrite) AVCaptureDevicePosition captureDevicePosition;

/**
 * Automatically set/unset UIApplication.idleTimerDisabled when video capturing is started / stopped.
 * Default is YES.
 */
@property (nonatomic, assign, readwrite) BOOL disableIdleTimerOnCapturing;

/**
 * View into which the remote peer video stream is rendered.
 */
- (UIView*)remoteView;

/**
 * View into which the locally captured video stream is rendered.
 */
- (UIView*)localView;

@end
