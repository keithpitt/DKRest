//
//  DKRestServer.h
//  DiscoKit
//
//  Created by Keith Pitt on 24/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DKRestServerProtocol.h"

@interface DKRestServer : NSObject <DKRestServerProtocol>

@property (nonatomic, copy) NSString * host;

+ (id <DKRestServerProtocol>)defaultServer;

+ (void)setDefaultServer:(id <DKRestServerProtocol>)server;

+ (DKRestServer *)serverWithHost:(NSString *)host;

- (id)initWithHost:(NSString *)serverHost;

@end