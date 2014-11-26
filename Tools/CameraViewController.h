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

//#import "ZBarReaderView.h"

@interface CameraViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate,
            UIAlertViewDelegate, CLLocationManagerDelegate>

//@property (weak, nonatomic) IBOutlet ZBarReaderView *zBarReaderView;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@end
