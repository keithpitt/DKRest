//
//  DKRestRouter.m
//  DiscoKit
//
//  Created by Keith Pitt on 24/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestRouter.h"

#import "DKRestObject.h"
#import "NSString+Inflections.h"

@implementation DKRestRouter

@synthesize host, version, ssl;

+ (DKRestRouter *)defaultRouter {
    
    static DKRestRouter * defaultRouter;
    
    if (!defaultRouter) {
        defaultRouter = [self new];
    }
    
    return defaultRouter;
    
}

- (NSURL *)routeFor:(id)object {
    
    NSString * path;
    
    // If we're dealing with a class, or an instance of a class
    if ([object isKindOfClass:[DKRestObject class]]) {
        
        id identifier = [object performSelector:@selector(identifier)];
        
        if (identifier) {
            
            path = [NSString stringWithFormat:@"%@/%@",
                    [[object class] performSelector:@selector(resourcePath)],
                    identifier];            
            
        } else {
            
            path = [[object class] performSelector:@selector(resourcePath)];
            
        }

    } else {

        path = [object performSelector:@selector(resourcePath)];

    }
    
    NSString * protocol = ssl ? @"https" : @"http";
    
    NSString * absoluteURL = [NSString stringWithFormat:@"%@://%@/v%@/%@", protocol,
                              self.host,
                              self.version,
                              path];
    
    return [NSURL URLWithString:absoluteURL];
    
}

- (NSURL *)routeFor:(id<DKRestObjectProtocol>)object withPath:(NSString *)path {
    
    NSURL * url = [self routeFor:object];
    
    return path ? [url URLByAppendingPathComponent:path] : url;
    
}

@end