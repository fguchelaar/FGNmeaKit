//
// Created by Frank Guchelaar on 13-12-14.
// Copyright (c) 2014 Frank Guchelaar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FGNmeaKit/FGNmeaKit.h>

@interface FGNmeaSentenceTests : XCTestCase

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

@end