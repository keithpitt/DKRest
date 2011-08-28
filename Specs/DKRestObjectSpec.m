//
//  DKRestObjectSpec.m
//  DiscoKit
//
//  Created by Keith Pitt on 12/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "SpecHelper.h"
#import "FGSpecRemoteUser.h"

#import "DKRest.h"

SPEC_BEGIN(DKRestObjectSpec)

context(@"- (id)formData:(DKAPIFormData *)formData valueForKey:(NSString *)key", ^{
   
    it(@"should return the identifier", ^{
        
        FGSpecRemoteUser * user = [FGSpecRemoteUser new];
        user.identifier = [NSNumber numberWithInt:12];
        
        NSNumber * formDataResult = [user formData:nil valueForKey:@"something[foo]"];
        
        expect(formDataResult).toEqual(user.identifier);
        
    });
    
});

SPEC_END