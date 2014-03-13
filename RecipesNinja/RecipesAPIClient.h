//
//  RecipesAPIClient.h
//  RecipesNinja
//
//  Created by Gard Sandholt on 13/03/14.
//  Copyright (c) 2014 GaSa Media. All rights reserved.
//

#import "AFRESTClient.h"

@interface RecipesAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (RecipesAPIClient *)sharedClient;

@end
