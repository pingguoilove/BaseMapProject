//
//  ViewController.m
//  maptestobjc
//
//  Created by Sergey Garazha on 10/06/14.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "RootViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RootViewController () <CLLocationManagerDelegate,MKMapViewDelegate> {
    CLLocationManager *locationManager;
}

@property (strong, nonatomic)  MKMapView *mapView;

@end

@implementation RootViewController
@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLocationManager];
    [self setupMapView];
    [self startLocate];
    
}

#pragma mark Setup methods
- (void)setupMapView {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.scrollEnabled = YES;
    self.mapView.zoomEnabled = YES;
    
    [self.view addSubview:self.mapView];
}

#pragma mark - Location manager helpers
- (void)startLocate {
    if([CLLocationManager locationServicesEnabled]) {
        [locationManager startUpdatingLocation];
    }
}

- (void)setupLocationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status != kCLAuthorizationStatusNotDetermined) {
        [locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
}

#pragma mark MapView Delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D loc = [userLocation.location coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000.0f, 1000.0f);
    [self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    static NSString *defaultPinID = @"com.invasivecode.pin";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                     initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.canShowCallout = NO;
    pinView.animatesDrop = YES;
    
    return pinView;
}
@end
