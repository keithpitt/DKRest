//
//  DKRestObjectSpec.m
//  DiscoKit
//
//  Created by Keith Pitt on 12/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "SpecHelper.h"
#import "FGSpecRemoteUser.h"

#import "DKRestObject.h"

SPEC_BEGIN(DKRestObjectSpec)

context(@"- (id)formData:(DKAPIFormData *)formData valueForParameter:(NSString *)key", ^{
   
    it(@"should return the identifier", ^{
        
        FGSpecRemoteUser * user = [FGSpecRemoteUser new];
        user.identifier = [NSNumber numberWithInt:12];
        
        expect([user formData:nil valueForParameter:@"something[foo]"]).toEqual(user.identifier);
        
    });
    
});

context(@"- (NSString *)formData:(DKAPIFormData *)formData parameterForKey:(NSString *)key", ^{
    
    it(@"should return the key with an _id appended", ^{
        
        FGSpecRemoteUser * user = [FGSpecRemoteUser new];
        user.identifier = [NSNumber numberWithInt:12];
        
        expect([user formData:nil parameterForKey:@"something"]).toEqual(@"something_id");
        expect([user formData:nil parameterForKey:@"something[foo]"]).toEqual(@"something[foo_id]");
        expect([user formData:nil parameterForKey:@"something[foo][bar]"]).toEqual(@"something[foo][bar_id]");
        
    });
    
});

SPEC_END