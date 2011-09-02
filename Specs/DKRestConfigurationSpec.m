//
//  DKRestConfigurationSpec.m
//  DiscoKit
//
//  Created by Keith Pitt on 12/07/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import "SpecHelper.h"

#import "MockUser.h"
#import "DKRestServer.h"
#import "MockRole.h"

SPEC_BEGIN(DKRestConfigurationSpec)

afterEach(^{
    
    [MockUser performSelector:@selector(resetResourceConfiguration)];
    
});

context(@"- (id)init", ^{
    
    it(@"should set the default server", ^{
        
        DKRestConfiguration * config = [MockUser resourceConfiguration];
        
        DKRestServer * defaultServer = [DKRestServer defaultServer];
        
        expect(config.restServer).toEqual(defaultServer);
        
    });
    
});

context(@"- (id)initWithRestClass:(Class)klass", ^{
    
    __block DKRestConfiguration * config;
    
    beforeEach(^{
        
        config = [MockUser resourceConfiguration];
        
    });
    
    it(@"should set a default resource name", ^{
        
        expect(config.resourceName).toEqual(@"user");
        
    });
    
    it(@"should set a default primary key", ^{
        
        expect(config.primaryKey).toEqual(@"identifier");
        
    });
    
    it(@"should set a default way of loading a resource from an object", ^{
        
        NSDictionary * dataObject = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                        @"12", @"id",
                                                                        @"Keith", @"first_name",
                                                                        nil] forKey:@"user"];
        
        MockUser * user = (MockUser *)config.resourceFromDataObject(dataObject);
        
        expect(user.identifier).toEqual(@"12");
        expect(user.firstName).toEqual(@"Keith");
        
    });
    
    it(@"should set a default way of generating post properties", ^{
        
        MockUser * user = [[MockUser alloc] initWithObjectsAndKeys:
                           @"12", @"id",
                           @"Keith", @"firstName",
                           nil];
        
        NSDictionary * postAttributes = config.postParametersBlock(user);
        
        expect([postAttributes valueForKey:@"identifier"]).toEqual(@"12");
        expect([postAttributes valueForKey:@"first_name"]).toEqual(@"Keith");
        
    });
    
});

context(@"- (void)resourceName:(NSString *)name", ^{
    
    it(@"should allow you to get a resource name", ^{
        
        DKRestConfiguration * config = [MockUser resourceConfiguration];
        
        [config resourceName:@"ruut"];
        
        expect(config.resourceName).toEqual(@"ruut");
        
    });
    
    it(@"should update the resouces path", ^{
        
        DKRestConfiguration * config = [MockUser resourceConfiguration];
        
        [config resourceName:@"ruut"];
        
        MockUser * user = [MockUser new];
        user.identifier = @"1";
        
        expect(config.resourcePathBlock(nil)).toEqual(@"ruuts");
        expect(config.resourcePathBlock(user)).toEqual(@"ruuts/1");
        
    });
    
});

context(@"- (NSString *)resourceName", ^{
    
    it(@"should allow you to get a resource name", ^{
        
        DKRestConfiguration * config = [MockUser resourceConfiguration];
        
        expect(config.resourceName).toEqual(@"user");
        
    });
    
});

context(@"- (void)resourceVersion:(NSString *)version", ^{
    
    it(@"should allow you to set a resource version", ^{
        
        DKRestConfiguration * config = [MockUser resourceConfiguration];
        
        [config resourceVersion:@"2"];
        
        expect(config.resourceVersion).toEqual(@"2");
        
    });
    
});

context(@"- (void)primaryKey:(NSString *)version", ^{
    
    it(@"should allow you to set a primary key", ^{
        
        DKRestConfiguration * config = [MockUser resourceConfiguration];
        
        [config primaryKey:@"2"];
        
        expect(config.primaryKey).toEqual(@"2");
        
    });
    
});

context(@"- (void)mapProperty:(NSString *)property toParameter:(NSString *)param nestObjects:(BOOL)nestObjects", ^{
    
    __block DKRestConfiguration * config;
    
    beforeEach(^{
        
        config = [MockUser resourceConfiguration];
        
    });
    
    it(@"should allow you to ignore some properties", ^{
        
        MockUser * user = [[MockUser alloc] initWithObjectsAndKeys:
                           @"12", @"id",
                           @"Keith", @"firstName",
                           @"Pitt", @"lastName",
                           nil];
        
        [config mapProperty:@"firstName" toParameter:nil];
        [config ignoreProperty:@"lastName"];
        
        NSDictionary * postAttributes = config.postParametersBlock(user);
        
        expect([postAttributes valueForKey:@"first_name"]).toBeNil();
        expect([postAttributes valueForKey:@"last_name"]).toBeNil();
        
    });
    
    it(@"should allow you remap properties", ^{
        
        MockUser * user = [[MockUser alloc] initWithObjectsAndKeys:
                           @"12", @"id",
                           @"Keith", @"firstName",
                           nil];
        
        [config mapProperty:@"firstName" toParameter:@"real_first_name"];
        
        NSDictionary * postAttributes = config.postParametersBlock(user);
        
        expect([postAttributes objectForKey:@"real_first_name"]).toEqual(@"Keith");
        
    });
    
    it(@"should allow you to have associations", ^{
        
        MockUser * user = [[MockUser alloc] initWithObjectsAndKeys: @"12", @"id", @"Keith", @"firstName", nil];
        user.defaultRole = [[MockRole alloc] initWithObjectsAndKeys:@"Admin", @"name", @"12", @"id", nil];
        
        NSDictionary * postAttributes = config.postParametersBlock(user);
        
        NSLog(@"%@", postAttributes);
        
    });
    
    it(@"should allow you to include a list of ids as a post parameter", ^{
        
        MockUser * user = [[MockUser alloc] initWithObjectsAndKeys: @"12", @"id", @"Keith", @"firstName", nil];
        
        MockRole * adminRole = [[MockRole alloc] initWithObjectsAndKeys:@"Admin", @"name", @"12", @"id", nil];
        MockRole * designerRole = [[MockRole alloc] initWithObjectsAndKeys:@"Designer", @"name", @"12", @"id", nil];
        
        user.roles = [NSArray arrayWithObjects:adminRole, designerRole, nil];
        
        NSDictionary * postAttributes = config.postParametersBlock(user);
        
        NSLog(@"%@", postAttributes);
        
        expect(true).toBeFalsy();
        
    });
    
    it(@"should allow you to nest objects", ^{
        
        MockUser * user = [[MockUser alloc] initWithObjectsAndKeys: @"12", @"id", @"Keith", @"firstName", nil];
        
        MockRole * adminRole = [[MockRole alloc] initWithObjectsAndKeys:@"Admin", @"name", @"12", @"id", nil];
        MockRole * designerRole = [[MockRole alloc] initWithObjectsAndKeys:@"Designer", @"name", @"12", @"id", nil];
        
        user.roles = [NSArray arrayWithObjects:adminRole, designerRole, nil];
        
        [config mapProperty:@"roles" toParameter:@"roles_attributes" nestObjects:YES];
        
        NSDictionary * postAttributes = config.postParametersBlock(user);
        
        NSLog(@"%@", postAttributes);
        
        expect(true).toBeFalsy();
        
    });
    
});

SPEC_END