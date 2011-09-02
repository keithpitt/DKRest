//
//  MockRole.m
//  DKRest
//
//  Created by Keith Pitt on 1/09/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "MockRole.h"

@implementation MockRole

@synthesize name, resourceIdentifier;

+ (void)configureResource:(DKRestConfiguration *)config {

    [config primaryKey:@"resourceIdentifier"];

    [config resourceName:@"role"];

}

@end