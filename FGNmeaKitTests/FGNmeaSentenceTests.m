//
// Created by Frank Guchelaar on 13-12-14.
// Copyright (c) 2014 Frank Guchelaar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FGNmeaKit/FGNmeaKit.h>

@interface FGNmeaSentenceTests : XCTestCase

@end

// Category to make private methods visible
@interface FGNmeaSentence (Test)

+ (BOOL)validateChecksum:(NSString *)sentence;

@end

@implementation FGNmeaSentenceTests

- (void)testNilStringCreatesNilSentence {
    XCTAssertNil([FGNmeaSentence nmeaSentenceFromString:nil error:nil], @"Expected nil result for nil-sentence");
}

- (void)testErrorExpectedForInvalidSentence {
    NSError *error;
    FGNmeaSentence *sentence = [FGNmeaSentence nmeaSentenceFromString:nil error:&error];
    XCTAssertNotNil(error, @"Expected error object for invalid sentence");
    XCTAssertNil(sentence, @"Expected nil result for nil-sentence");
}

- (void)testErrorExpectedForSentenceWithInvalidChecksum {
    NSError *error;
    FGNmeaSentence *sentence = [FGNmeaSentence nmeaSentenceFromString:@"$GPGSA,A,1,,,,,,,,,,,,,0.0,0.0,0.0*AA" error:&error];
    XCTAssertNotNil(error, @"Expected error object for sentence with invalid checksum");
    XCTAssertNil(sentence, @"Expected nil result for nil-sentence");
}

- (void)testValidateChecksum {

    // Valid - no checksum
    NSString *sentence = @"$GPRMC,081836,A,3751.65,S,14507.36,E,000.0,360.0,130998,011.3,E";
    XCTAssertTrue([FGNmeaSentence validateChecksum:sentence], @"expected YES due to no checksum available");

    // Valid
    sentence = @"$GPRMC,081836,A,3751.65,S,14507.36,E,000.0,360.0,130998,011.3,E*62";
    XCTAssertTrue([FGNmeaSentence validateChecksum:sentence], @"expected correct checksum");

    sentence = @"$GPGSA,A,1,,,,,,,,,,,,,0.0,0.0,0.0*30";
    XCTAssertTrue([FGNmeaSentence validateChecksum:sentence], @"expected correct checksum");

    sentence = @"$GPGSV,3,1,09,3,,,,6,73,209,28,10,,,,13,,,*41";
    XCTAssertTrue([FGNmeaSentence validateChecksum:sentence], @"expected correct checksum");

    // Invalid
    sentence = @"$GPGSA,A,1,,,,,,,,,,,,,0.0,0.0,0.0*AA";
    XCTAssertFalse([FGNmeaSentence validateChecksum:sentence], @"expected invalid checksum");

    sentence = @"$GPGSV,3,1,09,3,,,,6,73,209,28,10,,,,13,,,*0C";
    XCTAssertFalse([FGNmeaSentence validateChecksum:sentence], @"expected invalid checksum");
}

- (void)testParseReturnsCorrectClass {
    NSString *sentence = @"$GPRMC,081836,A,3751.65,S,14507.36,E,000.0,360.0,130998,011.3,E";
    FGNmeaSentence *nmeaSentence = [FGNmeaSentence nmeaSentenceFromString:sentence error:nil];
    XCTAssertTrue([nmeaSentence isKindOfClass:[FGNmeaSentence_GPRMC class]]);
}

- (void)testParseSetsCorrectAddress {
    NSString *sentence = @"$GPRMC,081836,A,3751.65,S,14507.36,E,000.0,360.0,130998,011.3,E";
    FGNmeaSentence *nmeaSentence = [FGNmeaSentence nmeaSentenceFromString:sentence error:nil];
    XCTAssertEqualObjects(@"GPRMC", nmeaSentence.address, @"Expected GPRMC address");
    XCTAssertEqualObjects(@"GP", nmeaSentence.talkerId, @"Expected GP talker");
    XCTAssertEqualObjects(@"RMC", nmeaSentence.sentenceFormatter, @"Expected RMC sentence formatter");
}

- (void)testParseReturnsUnknownClassForUnknownIdentifier {
    NSString *sentence = @"$BOGUS,081836,A,3751.65,S,14507.36,E,000.0,360.0,130998,011.3,E";
    FGNmeaSentence *nmeaSentence = [FGNmeaSentence nmeaSentenceFromString:sentence error:nil];
    XCTAssertTrue([nmeaSentence isKindOfClass:[FGNmeaSentence_Unknown class]]);
}
@end