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

@property NSMutableDictionary* toolsDict;
@property NSMutableDictionary* supplierDict;

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
    
//    NSMutableDictionary* toolCenterDict = [[NSMutableDictionary alloc] init];
//    _toolsDict = [[NSMutableDictionary alloc] init];
//    _supplierDict = [[NSMutableDictionary alloc] init];
    
    
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
                        
//                        NSMutableArray* toolArray = [[toolCenterDict objectForKey:[NSNumber numberWithInt:idx]] mutableCopy];
//                        [toolArray addObject:object];
//                        [toolCenterDict setObject:toolArray forKey:[NSNumber numberWithInt:idx]];
                        
                        idx++;
                        centerFound = true;
                        break;
                    }
                }
                if (!centerFound) {
//                    [toolCenterDict setObject:[NSMutableArray arrayWithObject:object] forKey:[NSNumber numberWithInt:[toolCenters count]]];
                    [toolCenters addObject:toolGeoPoint];
                    [toolCenterCount addObject:[NSNumber numberWithInt:1]];
                }
            }
        }
        long idx = 0;
        for (PFGeoPoint* toolCenter in toolCenters) {
            MKPointAnnotation* annontation = [[MKPointAnnotation alloc] init];
            [annontation setCoordinate:CLLocationCoordinate2DMake(toolCenter.latitude, toolCenter.longitude)];
            NSString* titleString = [NSString stringWithFormat:@"Number of tools: %ld", [[toolCenterCount  objectAtIndex:idx] integerValue]];
            [annontation setTitle:titleString];
            [self.MapView addAnnotation:annontation];
            
//            NSMutableArray* toolArray = [toolCenterDict objectForKey:[NSNumber numberWithInt:idx]];
//            [_toolsDict setObject:toolArray forKey:toolCenter];

            idx++;
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
    
    if (_controllerState == MV_SHOW_SUPPLIERS || _controllerState == MV_SHOW_TOOLS_AND_SUPPLIERS) {
        for (PFObject* object in _supplierObjects) {
            if ([object valueForKey:@"supplierGeoPoint"] != nil) {
                PFGeoPoint* geoPoint = [object valueForKey:@"supplierGeoPoint"];
                MKPointAnnotation* annontation = [[MKPointAnnotation alloc] init];
                [annontation setCoordinate:CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude)];
                NSString* titleString = [NSString stringWithFormat:@"Supplier: %@", [object valueForKey:@"supplier"]];
                [annontation setTitle:titleString];
                [self.MapView addAnnotation:annontation];
            }
        }
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (firstTimeMapUpdate) {
        _MapView.centerCoordinate = userLocation.location.coordinate;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 20000, 20000);
        [_MapView setRegion:region animated:NO];
        firstTimeMapUpdate = false;
    }
    
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        NSString* titleString = [annotation title];
        if ([titleString containsString:@"Number of tools"]) {
            MKPinAnnotationView* view = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ToolPinView"];
            if (!view) {
                view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ToolPinView"];
                view.canShowCallout = YES;
                view.pinColor = MKPinAnnotationColorGreen;
                return view;
            }
            else {
                view.pinColor = MKPinAnnotationColorGreen;
                return view;
            }
        }
        if ([titleString containsString:@"Supplier"]) {
            MKPinAnnotationView* view = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"SupplierPinView"];
            if (!view) {
                view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"SupplierPinView"];
                view.canShowCallout = YES;
                view.pinColor = MKPinAnnotationColorRed;
                return view;
            }
        }
        
//        CLLocationCoordinate2D currCoordinate = [annotation coordinate];
//        PFGeoPoint* currGeoPoint = [PFGeoPoint geoPointWithLatitude:currCoordinate.latitude longitude:currCoordinate.longitude];
//        NSMutableArray* toolsArray = [_toolsDict objectForKey:currGeoPoint];
//        NSLog(@"Number of tools: %ld", [toolsArray count]);
        
    }
    return nil;
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
