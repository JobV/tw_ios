//
//  TWAPIManager.m
//  therewhere
//
//  Created by Marcelo Lebre on 27/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWAPIManager.h"
static NSString *twAPI_ip = @"http://192.168.1.68:3000";

@implementation TWAPIManager
+(NSString*)twAPI_ip {return twAPI_ip;}
@end