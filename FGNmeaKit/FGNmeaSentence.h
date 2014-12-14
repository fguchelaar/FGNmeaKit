//
// Created by Frank Guchelaar on 13-12-14.
// Copyright (c) 2014 Frank Guchelaar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FGNmeaSentence : NSObject
+ (FGNmeaSentence *)nmeaSentenceFromString:(NSString *)sentence error:(NSError **)error;
@end