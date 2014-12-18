//
// Created by Frank Guchelaar on 13-12-14.
// Copyright (c) 2014 Frank Guchelaar. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Base class for all NMEA-sentences. Subclasses should adhere to the following naming convention:
* FGNmeaSentence_<SENTENCE-IDENTIFIER>. For instance: FGNmeaSentence_GPRMC.
*/
@interface FGNmeaSentence : NSObject

/**
* Alphanumeric characters identifying type of TALKER. and Sentence Formatter.
*/
@property(nonatomic, copy) NSString *address;

/**
* Returns the first 2 characters of the address field.
*/
@property(nonatomic, readonly) NSString *talkerId;

/**
* Return the third till fifth characters of the address field.
*/
@property(nonatomic, readonly) NSString *sentenceFormatter;

/**
* After validating the sentence, an instance of an FGNmeaSentence subclass will be returned. We try to instantiate a
* class by using the address of the sentence; ie GPRMC -> FGNmeaSentence_GPRMC.
*/
+ (FGNmeaSentence *)nmeaSentenceFromString:(NSString *)sentence error:(NSError **)error;

/**
* Subclasses should implement this method and:
* 1. validate the input and set error when appropriate
* 2. set corresponding properties
*/
- (void)interpretFields:(NSArray *)fields error:(NSError **)error;
@end