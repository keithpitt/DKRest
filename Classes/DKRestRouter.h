//
//  DKRestRouter.h
//  DiscoKit
//
//  Created by Keith Pitt on 24/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DKRestRouterProtocol.h"

@interface DKRestRouter : NSObject <DKRestRouterProtocol>

@property (nonatomic) BOOL ssl;
@property (nonatomic, retain) NSString * host;
@property (nonatomic, retain) NSString * version;

+ (DKRestRouter *)defaultRouter;

@end