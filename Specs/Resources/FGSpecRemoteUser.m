//
//  FGSpecRemoteUser.m
//  DiscoKit
//
//  Created by Keith Pitt on 29/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "FGSpecRemoteUser.h"

@implementation FGSpecRemoteUser

@synthesize identifier;

+ (NSString *)resourcePath {
    
    return @"users";
    
}

@end