//
//  MapViewController.h
//  Tools
//
//  Created by Mazin Biviji on 11/29/14.
//  Copyright (c) 2014 Fun. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


typedef NS_ENUM(NSUInteger, MVControllerState) {
    MV_SHOW_TOOLS = 0,
    MV_SHOW_SUPPLIERS,
    MV_SHOW_TOOLS_AND_SUPPLIERS
};

@interface MapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (weak, nonatomic) IBOutlet UIButton *zoomBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;

//@property (strong, nonatomic) PFObject *supplier;
//@property (strong, nonatomic) PFObject *tool;

@property (strong, nonatomic) NSArray* toolObjects;
@property (strong, nonatomic) NSArray* supplierObjects;

@property (nonatomic) MVControllerState controllerState;

@end
