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
#import "LoadView.h"

@interface CameraViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) CLLocation* location;
@property (nonatomic) BOOL gotLocation;

@property (nonatomic, strong) PFGeoPoint* geoPoint;
@property (nonatomic, strong) PFObject* exam;

-(BOOL)startReading;
-(void)stopReading;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
//        NSLog(@"Geopoint error: %@", error);
//        _geoPoint = [PFGeoPoint geoPointWithLatitude:[geoPoint latitude] longitude:[geoPoint longitude]];
//    }];
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
    CLLocationManager* locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// ZBarReaderViewDeleageFunctions
//-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
//    
//}

-(BOOL)startReading {
    NSError *error;
    
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
//    dispatch_queue_t dispatchQueue;
//    dispatchQueue = dispatch_queue_create("myQueue", NULL);
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
            NSLog(@"Found QR Code: %@\n", [metadataObj stringValue]);
            
            [self stopReading];
            _isReading = NO;

            // Check if valid qrcode
            NSString* qrCode = [metadataObj stringValue];
            NSArray* splitString = [qrCode componentsSeparatedByString:@"_"];
            NSLog(@"Stopped Reading QRCode\n");
            
            if ([[splitString objectAtIndex:0] isEqualToString:@"tool"]) {
                // Check valid code in Parse
                PFQuery* query = [PFQuery queryWithClassName:@"Tools"];
                [query whereKey:@"qrCode" equalTo:qrCode];
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
                            ToolDetailViewController* tVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToolDetailViewController"];
                            
                            tVC.exam = _exam;
                            [self.navigationController pushViewController:tVC animated:YES];
                        }
                        
                    }
                    else {
                        [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"New QR Code" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                    }
                }];
                
            }
            else {
//                [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Incorrect QR Code" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];

                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Incorrect QR Code" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView setTag:3];
                [alertView show];
//                [self startReading];
            }
        }
    }
}

#pragma UIAlertViewDelegate Functions
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 1) {
        if (buttonIndex == 0) {
            ToolDetailViewController* tVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToolDetailViewController"];
            tVC.exam = _exam;
            [self.navigationController pushViewController:tVC animated:YES];
            
        } else {
            [_exam setObject:_geoPoint forKey:@"toolGeoPoint"];
            LoadView* lView = [[[NSBundle mainBundle] loadNibNamed:@"LoadView" owner:nil options:nil] lastObject];
            [self.view addSubview:lView];
            
            [_exam saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [lView removeFromSuperview];
                ToolDetailViewController* tVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ToolDetailViewController"];
                tVC.exam = _exam;
                [self.navigationController pushViewController:tVC animated:YES];
                
            }];
        }
        
    } else if ([alertView tag] == 3) {
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
