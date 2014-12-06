//
//  CameraViewController.m
//  Tools
//
//  Created by Avdhut Joshi on 11/20/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "CameraViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ToolDetailViewController.h"
#import "AddToolViewController.h"
#import "AddToolTableViewController.h"
#import "LoadView.h"

@interface CameraViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic) BOOL gotLocation;

@property (nonatomic, strong) PFGeoPoint* geoPoint;
@property (nonatomic, strong) PFObject* exam;
@property (nonatomic, strong) NSString* qrCodeString;

-(BOOL)startReading;
-(void)stopReading;

-(void)ScanTool;
-(void)ScanToolNext;

//-(void)InvTagTool;
//-(void)InvAddTool;
//-(void)InvShipTool;
//-(void)InvRecieveTool;
//-(void)InvUpdateTool;
-(void)HandleInv;

-(void)AddToolWithCheck:(BOOL)check;
-(void)AddToolNext;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _locationManager = [[CLLocationManager alloc] init];
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    _locationManager.delegate = self;
    [self.TorchBtn setImage:[UIImage imageNamed:@"TorchSelected"] forState:UIControlStateSelected];
    
}
- (IBAction)TourchTouchUpInside:(id)sender {
    
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success)
        {
            if ([flashLight isTorchActive]) {
                self.TorchBtn.imageView.image = [UIImage imageNamed:@"TorchSelected"];
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            } else {
                self.TorchBtn.imageView.image = [UIImage imageNamed:@"Torch"];
                [flashLight setTorchMode:AVCaptureTorchModeOn];
            }
            [flashLight unlockForConfiguration];
        }
    }

    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _captureSession = nil;
    _isReading = NO;
    if ([self startReading]) {
        _isReading = YES;
    } else {
        NSLog(@"Error in starting to capture\n");
    }

    [_locationManager startUpdatingLocation];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopReading];
    _isReading = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)startReading {
    NSError *error;
    _qrCodeString = nil;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_cameraView.layer.bounds];
    [_cameraView.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}

-(void)stopReading {
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            [self stopReading];
            _isReading = NO;

            // Check if valid qrcode
            _qrCodeString = [metadataObj stringValue];
            if (self.controllerState == CVC_SCAN_TOOL) {
                [self ScanTool];
            }
            else if (self.controllerState == CVC_INV) {
                [self HandleInv];
            }
//            else if (self.controllerState == CVC_INV_TAG_TOOL) {
//                [self InvTagTool];
//            }
//            else if (self.controllerState == CVC_INV_ADD_TOOL) {
//                [self InvAddTool];
//            }
//            else if (self.controllerState == CVC_INV_SHIP_TOOL) {
//                [self InvShipTool];
//            }
        }
    }
}

#pragma SCAN TOOL Functions
-(void)ScanTool {
    NSArray* splitString = [_qrCodeString componentsSeparatedByString:@"_"];
    
    if ([[splitString objectAtIndex:0] isEqualToString:@"tool"]) {
        // Check valid code in Parse
        PFQuery* query = [PFQuery queryWithClassName:@"Tools"];
        [query whereKey:@"qrCode" equalTo:_qrCodeString];
        LoadView* lView = [[[NSBundle mainBundle] loadNibNamed:@"LoadView" owner:nil options:nil] lastObject];
        [self.view addSubview:lView];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [lView removeFromSuperview];
            if ([objects count] > 0) {
                // Push New View Controller
                _exam = [objects firstObject];
                
                PFGeoPoint* examGeoPoint = [_exam objectForKey:@"toolGeoPoint"];
                if ([_geoPoint distanceInKilometersTo:examGeoPoint] > 1000 || !examGeoPoint) {
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Update" message:@"Update Geolocation of the tool" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                    [alertView setTag:1];
                    [alertView show];
                } else {
                    [self ScanToolNext];

                }
                
            }
            else {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"New QR Code" message:@"Do you want to add a new tool?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alertView setTag:2];
                [alertView show];
            }
        }];
        
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Incorrect QR Code" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView setTag:3];
        [alertView show];
    }
}

-(void)ScanToolNext {
    AddToolTableViewController* aTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToolTableViewController"];
    [aTVC setControllerState:ATVC_VIEW_TOOL];
    [aTVC setExam:_exam];
    [self.navigationController pushViewController:aTVC animated:YES];
}

#pragma Inventory Functions

-(void)HandleInv {
    NSArray* splitString = [_qrCodeString componentsSeparatedByString:@"_"];
    if ([[splitString objectAtIndex:0] isEqualToString:@"tool"]) {
        [_inventoryListViewController setQrCodeString:_qrCodeString];
        [self.navigationController popViewControllerAnimated:YES];
//        [_inventoryListViewController gotQRCode:_qrCodeString];
//        [self dismissViewControllerAnimated:YES completion:^{
//            [_inventoryListViewController gotQRCode:_qrCodeString];
//        }];
        
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Incorrect QR Code" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView setTag:3];
        [alertView show];
    }
    
}
/*
-(void)InvTagTool {
    PFQuery* query = [PFQuery queryWithClassName:@"Tools"];
    [query whereKey:@"qrCode" equalTo:_qrCodeString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] != 0) {
            // QR Code already exists
            [self dismissViewControllerAnimated:YES completion:^{
                [_inventoryListViewController gotQRCode:nil];
            }];
        }
        else {
            [self dismissViewControllerAnimated:YES completion:^{
                [_inventoryListViewController gotQRCode:_qrCodeString];
            }];
        }
    }];
}

-(void)InvAddTool {
    PFQuery* query = [PFQuery queryWithClassName:@"Tools"];
    [query whereKey:@"qrCode" equalTo:_qrCodeString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] != 0) {
            // QR Code already exists
            [self dismissViewControllerAnimated:YES completion:^{
                [_inventoryListViewController gotQRCode:nil];
            }];
        }
        else {
            [_inventoryListViewController gotQRCode:_qrCodeString];
        }
    }];
}

-(void)InvShipTool {
    [self dismissViewControllerAnimated:YES completion:^{
        [_inventoryListViewController gotQRCode:_qrCodeString];
    }];
}

-(void)InvRecieveTool {
    [self dismissViewControllerAnimated:YES completion:^{
        [_inventoryListViewController gotQRCode:_qrCodeString];
    }];
}
 */

#pragma Add Tool Functions
-(void)AddToolWithCheck:(BOOL)check {
    if (check) {
        PFQuery* query = [PFQuery queryWithClassName:@"Tools"];
        [query whereKey:@"qrCode" equalTo:_qrCodeString];
        LoadView* lView = [[[NSBundle mainBundle] loadNibNamed:@"LoadView" owner:nil options:nil] lastObject];
        [self.view addSubview:lView];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [lView removeFromSuperview];
            if ([objects count] == 0) {
                [self AddToolNext];
//                AddToolViewController* aTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToolViewController"];
//                [aTVC setQRCode:_qrCodeString];
//                // [self.navigationController pushViewController:aTVC animated:YES];
//                [self presentViewController:aTVC animated:YES completion:^{
//                }];
            } else {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tool Exists" message:@"This tool ID already exists in the system" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView setTag:4];
                [alertView show];
            }
        }];
        
    } else {
        [self AddToolNext];
//        AddToolViewController* aTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToolViewController"];
//        [aTVC setQRCode:_qrCodeString];
//        // [self.navigationController pushViewController:aTVC animated:YES];
//        [self presentViewController:aTVC animated:YES completion:^{
//        }];
    }
}

-(void)AddToolNext {
    AddToolTableViewController* aTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddToolTableViewController"];
    [aTVC setControllerState:ATVC_ADD_TOOL];
    [aTVC setQRCode:_qrCodeString];
    [self.navigationController pushViewController:aTVC animated:YES];
}

#pragma UIAlertViewDelegate Functions
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // Update Location AlertView
    if ([alertView tag] == 1) {
        if (buttonIndex == 0) {
            [self ScanToolNext];
        } else {
            [_exam setObject:_geoPoint forKey:@"toolGeoPoint"];
            LoadView* lView = [[[NSBundle mainBundle] loadNibNamed:@"LoadView" owner:nil options:nil] lastObject];
            [self.view addSubview:lView];
            
            [_exam saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [lView removeFromSuperview];
                [self ScanToolNext];
                
            }];
        }
    }  // End of Update Location Alert View
    else  if ([alertView tag] == 2) {  // New tool AlertView
        if (buttonIndex == 0) {
            [self startReading];
        }
        else {
            [self AddToolWithCheck:NO];
            
        }        
    }
    else if ([alertView tag] == 3) {  // Invalid QRCode AlertView
        [self startReading];
    }
    
}

#pragma CLLocationManagerDelegate Functions
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _location = [locations lastObject];
    _geoPoint = [PFGeoPoint geoPointWithLocation:_location];
//    _geoPoint = [PFGeoPoint geoPointWithLatitude:[_location.coordinate.latitude] longitude:_location.co]
    _gotLocation = true;
    [manager stopUpdatingLocation];
}

- (IBAction)LogoutClicked:(id)sender {
    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

@end
