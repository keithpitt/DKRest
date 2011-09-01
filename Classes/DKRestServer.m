//
//  DKRestServer.m
//  DiscoKit
//
//  Created by Keith Pitt on 24/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestServer.h"

@implementation DKRestServer

@synthesize host;

static id <DKRestServerProtocol> defaultServer;

+ (id <DKRestServerProtocol>)defaultServer {
    
    return defaultServer;
    
}

+ (void)setDefaultServer:(id <DKRestServerProtocol>)server {
    
    if (defaultServer)
        [defaultServer release];
    
    defaultServer = [server retain];
    
}

+ (DKRestServer *)serverWithHost:(NSString *)host {
    
    return [[[self alloc] initWithHost:host] autorelease];
    
}

- (id)initWithHost:(NSString *)serverHost {
    
    if ((self = [self init])) {
        host = serverHost;
    }
    
    return self;
    
}

@end