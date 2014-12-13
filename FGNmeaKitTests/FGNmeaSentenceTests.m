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
    XCTAssertNil([FGNmeaSentence nmeaSentenceFromString:nil], @"Expected nil result for nil-string");
}

@end