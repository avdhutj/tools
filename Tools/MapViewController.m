//
//  MapViewController.m
//  Tools
//
//  Created by Mazin Biviji on 11/29/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _MapView.delegate = self;
    _MapView.showsUserLocation = YES;
}

- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    _MapView.centerCoordinate =
    userLocation.location.coordinate;
}
- (IBAction)ZoomBtnClicked:(id)sender {
    MKUserLocation *userLocation = _MapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 20000, 20000);
    [_MapView setRegion:region animated:NO];
}
- (IBAction)TypeBtnClicked:(id)sender {
    if (_MapView.mapType == MKMapTypeStandard)
        _MapView.mapType = MKMapTypeSatellite;
    else
        _MapView.mapType = MKMapTypeStandard;
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

@end
