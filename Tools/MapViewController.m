//
//  MapViewController.m
//  Tools
//
//  Created by Mazin Biviji on 11/29/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () {

    BOOL firstTimeMapUpdate;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    firstTimeMapUpdate = true;
    // Do any additional setup after loading the view.
    _MapView.delegate = self;
    _MapView.showsUserLocation = YES;
    
    NSMutableArray* toolCenters = [[NSMutableArray alloc] init];
    NSMutableArray* toolCenterCount = [[NSMutableArray alloc] init];
    if (_controllerState == MV_SHOW_TOOLS || _controllerState == MV_SHOW_TOOLS_AND_SUPPLIERS) {
        for (PFObject* object in _toolObjects) {
            if ([object valueForKey:@"toolGeoPoint"] != nil) {
                // Check if there exists a tool center
                long idx = 0;
                bool centerFound = false;
                PFGeoPoint* toolGeoPoint = [object valueForKey:@"toolGeoPoint"];
                for (PFGeoPoint* toolCenter in toolCenters) {
                    if ([toolGeoPoint distanceInMilesTo:toolCenter] < 1.0) {
                        double lat = [toolCenterCount[idx] integerValue] * toolCenter.latitude + toolGeoPoint.latitude;
                        double lon = [toolCenterCount[idx] integerValue] * toolCenter.longitude + toolGeoPoint.longitude;
                        toolCenterCount[idx] = [NSNumber numberWithLong:([toolCenterCount[idx] integerValue] + 1)];
                        lat /= [toolCenterCount[idx] integerValue];
                        lon /= [toolCenterCount[idx] integerValue];
//                        toolCenter.latitude = [toolCenterCount[idx] integerValue] * toolCenter.latitude + toolGeoPoint.latitude;
//                        toolCenter.longitude = [toolCenterCount[idx] integerValue] * toolCenter.longitude + toolGeoPoint.longitude;

                        toolCenter.latitude = lat;
                        toolCenter.longitude = lon;
                        
                        idx++;
                        centerFound = true;
                        break;
                    }
                }
                if (!centerFound) {
                    [toolCenters addObject:toolGeoPoint];
                    [toolCenterCount addObject:[NSNumber numberWithInt:1]];
                }
            }
        }
        for (PFGeoPoint* toolCenter in toolCenters) {
            MKPointAnnotation* annontation = [[MKPointAnnotation alloc] init];
            [annontation setCoordinate:CLLocationCoordinate2DMake(toolCenter.latitude, toolCenter.longitude)];
            [self.MapView addAnnotation:annontation];
        }
    }
    
    
    
//    if (_controllerState == MV_SHOW_TOOLS || _controllerState == MV_SHOW_TOOLS_AND_SUPPLIERS) {
//        for (PFObject* object in _toolObjects) {
//            if ([object valueForKey:@"toolGeoPoint"] != nil) {
//                MKPointAnnotation* annontation = [[MKPointAnnotation alloc] init];
//                PFGeoPoint* toolGeoPoint = [object valueForKey:@"toolGeoPoint"];
//                [annontation setCoordinate:CLLocationCoordinate2DMake(toolGeoPoint.latitude, toolGeoPoint.longitude)];
//                [self.MapView addAnnotation:annontation];
//            }
//        }
//    }
//    if (_controllerState == MV_SHOW_SUPPLIERS || _controllerState == MV_SHOW_TOOLS_AND_SUPPLIERS) {
//        for (PFObject* object in _supplierObjects) {
//            if ([object valueForKey:@"supplierGeoPoint"] != nil) {
//                PFGeoPoint* geoPoint = [object valueForKey:@"supplierGeoPoint"];
//                MKPointAnnotation* annontation = [[MKPointAnnotation alloc] init];
//                [annontation setCoordinate:CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude)];
//                [self.MapView addAnnotation:annontation];
//            }
//        }
//    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (firstTimeMapUpdate) {
        _MapView.centerCoordinate = userLocation.location.coordinate;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 20000, 20000);
        [_MapView setRegion:region animated:NO];
        firstTimeMapUpdate = false;
    }
    
}
- (IBAction)ZoomBtnClicked:(id)sender {
    MKUserLocation *userLocation = _MapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 20, 20);
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
