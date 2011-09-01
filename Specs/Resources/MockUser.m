//
//  MockUser.m
//  DKRest
//
//  Created by Keith Pitt on 1/09/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "MockUser.h"

@implementation MockUser

+ (void)configureResource:(DKRestConfiguration *)config {
    
    [config resourceName:@"user"];
    
}

@end