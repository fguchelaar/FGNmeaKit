//
// Created by Frank Guchelaar on 15-12-14.
// Copyright (c) 2014 Frank Guchelaar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FGNmeaSentence.h"

/**
* GPRMC
* Talker: Global Positioning System (GPS)
* Sentence: Recommended Minimum Specific GNSS Data
*
* Time. date, position, course and speed data provided by a GNSS navigation receiver.
*/
@interface FGNmeaSentence_GPRMC : FGNmeaSentence

/**
* UTC date and time of position fix
*
* field 1 + 9
*/
@property(nonatomic, strong) NSDate *dateTime;

/**
* field 2
*/
@property(nonatomic, strong) id status;

/**
* field 3+4
*/
@property(nonatomic, assign) CLLocationDegrees latitude;

/**
* field 5+6
*/
@property(nonatomic, assign) CLLocationDegrees longitude;

/**
* Speed over ground, knots
*
* field 7
*/
@property(nonatomic, strong) id speedOverGround;

/**
* Course over ground, degrees True
*
* field 8
*/
@property(nonatomic, strong) id courseOverGround;

/**
* Magnetic variation, degrees E/W
*
* field 10 + 11
*/
@property(nonatomic, strong) id magneticVariation;

/**
* field 12
*/
@property(nonatomic, strong) id modeIndicator;

@end