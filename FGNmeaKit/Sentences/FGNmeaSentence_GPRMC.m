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
}

- (NSDate *)dateFromDate:(NSString *)date andTime:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyy'T'HHmmss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *concatenatedString = [NSString stringWithFormat:@"%@T%@", date, time];
    return [dateFormatter dateFromString:concatenatedString];
}

@end