//
//  CameraViewController.h
//  Tools
//
//  Created by Avdhut Joshi on 11/20/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, ControllerState) {
    SCAN_TOOL = 0,
    ADD_TOOL,
    SHIP_TOOL
};

@interface CameraViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate,
UIAlertViewDelegate, CLLocationManagerDelegate> {
//    ControllerState controllerState;
}

@property (nonatomic) ControllerState controllerState;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@end
