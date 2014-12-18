//
// Created by Frank Guchelaar on 15-12-14.
// Copyright (c) 2014 Frank Guchelaar. All rights reserved.
//

#import "FGNmeaSentence_GPRMC.h"


@implementation FGNmeaSentence_GPRMC

- (void)interpretFields:(NSArray *)fields error:(NSError **)error {
    [super interpretFields:fields error:error];

    if (fields.count != 11) {
        if (error != NULL) {
            *error = [[NSError alloc] initWithDomain:@"FGNmeaSentenceDataFieldsValidation" code:1 userInfo:nil];
        }
        return;
    }

    self.dateTime = [self dateFromDate:fields[8] andTime:fields[0]];
    self.latitude = [self degreesFromCoordinate:fields[2] inQuadrasphere:fields[3]];
    self.longitude = [self degreesFromCoordinate:fields[4] inQuadrasphere:fields[5]];
}

- (NSDate *)dateFromDate:(NSString *)date andTime:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyy'T'HHmmss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *concatenatedString = [NSString stringWithFormat:@"%@T%@", date, time];
    return [dateFormatter dateFromString:concatenatedString];
}

- (CLLocationDegrees)degreesFromCoordinate:(NSString *)coordinate inQuadrasphere:(NSString *)nsew {
    NSRange dotRange = [coordinate rangeOfString:@"."];

    double whole = [[coordinate substringWithRange:NSMakeRange(0, dotRange.location - 2)] doubleValue];
    double decimals = [[coordinate substringFromIndex:dotRange.location - 2] doubleValue] / 60;

    double degrees = whole + decimals;
    if ([nsew isEqualToString:@"S"] || [nsew isEqualToString:@"W"]) {
        degrees *= -1;
    }
    return degrees;
}

@end