//
// Created by Frank Guchelaar on 18-12-14.
// Copyright (c) 2014 Frank Guchelaar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FGNmeaSentence.h"
#import "FGNmeaSentence_GPRMC.h"

@interface FGNmeaSentence_GPRMCTests : XCTestCase

@end

@implementation FGNmeaSentence_GPRMCTests

- (void)testInterpretDateAndTime {

    NSString *sentence = @"$GPRMC,081836,A,3751.65,S,14507.36,E,000.0,360.0,130998,011.3,E";
    FGNmeaSentence_GPRMC *nmeaSentence = (FGNmeaSentence_GPRMC *) [FGNmeaSentence nmeaSentenceFromString:sentence error:nil];

    NSCalendar *gregorianCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorianCalendar componentsInTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]
                                                                      fromDate:nmeaSentence.dateTime];

    XCTAssertEqual(dateComponents.year, 1998, @"Invalid year");
    XCTAssertEqual(dateComponents.month, 9, @"Invalid month");
    XCTAssertEqual(dateComponents.day, 13, @"Invalid day");
    XCTAssertEqual(dateComponents.hour, 8, @"Invalid hour");
    XCTAssertEqual(dateComponents.minute, 18, @"Invalid minute");
    XCTAssertEqual(dateComponents.second, 36, @"Invalid second");
}

@end