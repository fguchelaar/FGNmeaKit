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
    return YES;
}

- (instancetype)initWithFields:(NSArray *)fields {
    self = [super init];
    if (self) {
        _fields = [fields copy];
    }
    return self;
}


@end