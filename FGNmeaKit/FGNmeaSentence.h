//
// Created by Frank Guchelaar on 13-12-14.
// Copyright (c) 2014 Frank Guchelaar. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Base class for all NMEA-sentences. Subclasses should adhere to the following naming convention:
* FGNmeaSentence_<SENTENCE-IDENTIFIER>. For instance: FGNmeaSentence_GPRMC
*/
@interface FGNmeaSentence : NSObject

@property(nonatomic, readonly) NSString *talkerId;

@property(nonatomic, readonly) NSString *sequenceIdentifier;

+ (FGNmeaSentence *)nmeaSentenceFromString:(NSString *)sentence error:(NSError **)error;

@end