//
// Created by Frank Guchelaar on 13-12-14.
// Copyright (c) 2014 Frank Guchelaar. All rights reserved.
//

#import "FGNmeaSentence.h"

@interface FGNmeaSentence ()

@property(nonatomic, strong) NSArray *fields;

@end

@implementation FGNmeaSentence

+ (FGNmeaSentence *)nmeaSentenceFromString:(NSString *)sentence error:(NSError **)error {

    NSError *validationError;
    if (![self validateSentenceWithString:sentence error:&validationError]) {
        if (error != NULL) {
            *error = [[NSError alloc] initWithDomain:validationError.domain code:validationError.code userInfo:validationError.userInfo];
        }
        return nil;
    }
    return [[FGNmeaSentence alloc] initWithFields:nil];
}

+ (BOOL)validateSentenceWithString:(NSString *)sentence error:(NSError **)error {
    if (sentence.length == 0) {
        if (error != NULL) {
            *error = [[NSError alloc] initWithDomain:@"FGNmeaSentenceValidation" code:1 userInfo:nil];
        }
        return NO;
    }

    if(![self validateChecksum:sentence]) {
        if (error != NULL) {
            *error = [[NSError alloc] initWithDomain:@"FGNmeaSentenceValidation" code:2 userInfo:nil];
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

- (instancetype)initWithFields:(NSArray *)fields {
    self = [super init];
    if (self) {
        _fields = [fields copy];
    }
    return self;
}


@end