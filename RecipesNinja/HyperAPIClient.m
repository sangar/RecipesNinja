//
//  HyperAPIClient.m
//  RecipesNinja
//
//  Created by Gard Sandholt on 13/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "HyperAPIClient.h"

static NSString * const kHyperAPIURLString = @"http://hyper-recipes.herokuapp.com";

@implementation HyperAPIClient

+ (instancetype)sharedClient {
    static HyperAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HyperAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kHyperAPIURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    });
    
    return _sharedClient;
}

//- (id)initWithBaseURL:(NSURL *)url {
//    self = [super initWithBaseURL:url];
//    if (!self) {
//        return nil;
//    }
//    
//    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    [self setDefaultHeader:@"Accept" value:@"application/json"];
//    
//    return self;
//}


@end
