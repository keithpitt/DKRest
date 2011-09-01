//
//  main.m
//  Specs
//
//  Created by Keith Pitt on 21/06/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Cedar-iPhone/Cedar.h>

#import "DKCoreData.h"
#import "DKRestServer.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    // This should probably be somewhere else.
    DKCoreData * coreData = [[DKCoreData alloc] initWithDatabase:@"Specs" bundle:nil];
    
    // Delete the database
    [coreData deleteDatabase];
    
    // Setup the default server
    [DKRestServer setDefaultServer:[DKRestServer serverWithHost:@"http://api.example.com"]];
    
    int retVal = UIApplicationMain(argc, argv, nil, @"CedarApplicationDelegate");
    
    [pool release];
    [coreData release];
    
    return retVal;
    
}