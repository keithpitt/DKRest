//
//  MockUser.h
//  DKRest
//
//  Created by Keith Pitt on 1/09/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "DKRestObject.h"

@interface MockUser : DKRestObject

@property (nonatomic, copy) NSString * identifier;

@property (nonatomic, copy) NSString * firstName;
@property (nonatomic, copy) NSString * lastName;

@end