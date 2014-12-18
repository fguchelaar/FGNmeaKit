//
// Created by Frank Guchelaar on 13-12-14.
// Copyright (c) 2014 Frank Guchelaar. All rights reserved.
//

#import "FGNmeaSentence.h"
#import "FGNmeaSentence_Unknown.h"

@implementation FGNmeaSentence

+ (FGNmeaSentence *)nmeaSentenceFromString:(NSString *)sentence error:(NSError **)error {

    NSError *validationError;
    if (![self validateSentenceWithString:sentence error:&validationError]) {
        if (error != NULL) {
            *error = [[NSError alloc] initWithDomain:validationError.domain code:validationError.code userInfo:validationError.userInfo];
        }
        return nil;
    }

    // trim the string
    sentence = [sentence stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"$\r\n"]];
    NSArray *fields = [sentence componentsSeparatedByString:@","];

    // Find appropriate class. If none is found, return a sentence of type Unknown
    NSString *className = [NSString stringWithFormat:@"FGNmeaSentence_%@", fields[0]];
    Class sentenceClass = NSClassFromString(className);

    FGNmeaSentence *nmeaSentence;
    if (sentenceClass) {
        nmeaSentence = [(FGNmeaSentence *) [sentenceClass alloc] init];
    }
    else {
        nmeaSentence = [[FGNmeaSentence_Unknown alloc] init];
    }
    nmeaSentence.address = fields[0];

    // interpretFields can validate the data fields and set the error pointer to indicate that there is a problem
    NSError *dataError;
    NSArray *dataFields = [fields subarrayWithRange:NSMakeRange(1, fields.count - 1)];
    [nmeaSentence interpretFields:dataFields error:&dataError];
    if (dataError) {
        if (error != NULL) {
            *error = [[NSError alloc] initWithDomain:dataError.domain code:dataError.code userInfo:dataError.userInfo];
        }
        return nil;
    }

    return nmeaSentence;
}

/**
* Validates the basic 'syntax' of a sentence:
* - start of sentence ($)
* - length of address field (5)
* - checksum
*/
+ (BOOL)validateSentenceWithString:(NSString *)sentence error:(NSError **)error {
    if (sentence.length == 0) {
        if (error != NULL) {
            *error = [[NSError alloc] initWithDomain:@"FGNmeaSentenceValidation" code:1 userInfo:nil];
        }
        return NO;
    }

    if ([sentence characterAtIndex:0] != '$') {
        if (error != NULL) {
            *error = [[NSError alloc] initWithDomain:@"FGNmeaSentenceValidation" code:2 userInfo:nil];
        }
        return NO;
    }


    if (![self validateChecksum:sentence]) {
        if (error != NULL) {
            *error = [[NSError alloc] initWithDomain:@"FGNmeaSentenceValidation" code:3 userInfo:nil];
        }
        return NO;
    }

    sentence = [sentence stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"$\r\n"]];
    NSArray *fields = [sentence componentsSeparatedByString:@","];
    NSString *address = fields[0];
    if (address.length != 5) {
        if (error != NULL) {
            *error = [[NSError alloc] initWithDomain:@"FGNmeaSentenceValidation" code:4 userInfo:nil];
        }
        return NO;
    }

    return YES;
}

/**
* A sentence can optionally contain a checksum. If it does, there is an asterisk at the end of the sentence followed
* by a 2 character checksum (HEX). If there is no checksum available, YES will be returned, otherwise the checksum
* will be validated.
*/
+ (BOOL)validateChecksum:(NSString *)sentence {

    NSRange asteriskRange = [sentence rangeOfString:@"*" options:NSBackwardsSearch];

    if (asteriskRange.location == NSNotFound) {
        return YES;
    }
    else {
        NSRange checksumRange = NSMakeRange(asteriskRange.location + 1, 2);
        NSString *checksumString = [sentence substringWithRange:checksumRange];
        NSUInteger checksum = (NSUInteger) strtoull([checksumString UTF8String], NULL, 16);

        NSUInteger actualChecksum = 0;
        for (int i = 1; i < asteriskRange.location; i++) {
            actualChecksum ^= [sentence characterAtIndex:i];
        }
        return checksum == actualChecksum;
    }
}

- (void)interpretFields:(NSArray *)fields error:(NSError **)error {
    // noop
}

- (NSString *)talkerId {
    return [self.address substringWithRange:NSMakeRange(0, 2)];
}

- (NSString *)sentenceFormatter {
    return [self.address substringWithRange:NSMakeRange(2, 3)];
}


@end