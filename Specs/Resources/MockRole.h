//
//  MockRole.h
//  DKRest
//
//  Created by Keith Pitt on 1/09/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestObject.h"

@interface MockRole : DKRestObject

@property (nonatomic, copy) NSString * resourceIdentifier;
@property (nonatomic, copy) NSString * name;

@end