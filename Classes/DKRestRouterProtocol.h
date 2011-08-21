//
//  DKRestRouterProtocol.h
//  DiscoKit
//
//  Created by Keith Pitt on 24/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestObjectProtocol.h"

@protocol DKRestRouterProtocol <NSObject>

- (NSURL *)routeFor:(id <DKRestObjectProtocol>)object;
- (NSURL *)routeFor:(id <DKRestObjectProtocol>)object withPath:(NSString *)path;

@end