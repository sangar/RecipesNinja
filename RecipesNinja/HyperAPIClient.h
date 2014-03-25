//
//  HyperAPIClient.h
//  RecipesNinja
//
//  Created by Gard Sandholt on 13/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HyperAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
