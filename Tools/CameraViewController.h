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

#import "InventoryListViewController.h" // Controller which will be calling camera view controller

typedef NS_ENUM(NSInteger, CVCControllerState) {
    CVC_SCAN_TOOL = 0,
    CVC_INV_TAG_TOOL,
    CVC_INV_ADD_TOOL,
    CVC_INV_SHIP_TOOL,
    CVC_INV_RECIEVE_TOOL,
    CVC_INV_UPDATE_TOOL
};

@interface CameraViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate,
UIAlertViewDelegate, CLLocationManagerDelegate> {

}
@property (nonatomic) CVCControllerState controllerState;
@property (weak, nonatomic) IBOutlet UIButton *CancelBtn;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIButton *TorchBtn;

@property (strong, nonatomic) NSString* invToolId; // Information passed from Inventory view conrtroller
@property (nonatomic, weak) InventoryListViewController* inventoryListViewController;


@end
