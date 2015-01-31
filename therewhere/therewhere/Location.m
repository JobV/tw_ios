//
//  Location.m
//  therewhere
//
//  Created by Marcelo Lebre on 27/12/14.
//  Copyright (c) 2014 therewhereinc. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import <RestKit/RestKit.h>

#import "Location.h"
#import "TWAPIManager.h"
static NSString *created_date;
@implementation Location{
//    RKObjectMapping *setLocationResponseMapping;
//    NSIndexSet *statusCodes;
//    RKResponseDescriptor *setLocationResponseDescriptor;
//    RKObjectMapping *setLocationRequestMapping;
//    RKRequestDescriptor *setLocationRequestDescriptor;
//    RKObjectManager *rkmanager;
//    SetLocationRequest *setLocationRequest;
//    NSDateFormatter *dateFormat;
//    NSDate *date;
//    NSString *restPath ;

}

//-(id)init {
//    if ( self = [super init] ) {
//        restPath = @"/api/v1/users";
//        statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
//        
//        rkmanager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:[TWAPIManager twAPI_ip]]];
//        
//        dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
//    }
//    return self;
////
//}
//- (NSDate *) setLocation: (CLLocationCoordinate2D) coordinate userID:(int)userID{
//    
//    
//    setLocationResponseMapping = [RKObjectMapping mappingForClass:[SetLocationResponse class]];
//    [setLocationResponseMapping addAttributeMappingsFromDictionary:@{
//                                                          @"id":            @"locationID",
//                                                          @"longlat":       @"longlat",
//                                                          @"user_id":       @"userID",
//                                                          @"created_at":    @"created_at",
//                                                          @"updated_at":    @"updated_at"
//                                                          }];
//    
//    setLocationResponseDescriptor = [RKResponseDescriptor
//                                     responseDescriptorWithMapping:setLocationResponseMapping
//                                     method:RKRequestMethodAny
//                                     pathPattern:nil
//                                     keyPath:nil
//                                     statusCodes:statusCodes];
//    
//    setLocationRequestMapping = [RKObjectMapping requestMapping];
//    [setLocationRequestMapping addAttributeMappingsFromDictionary:@{
//                                                         @"userID": @"id",
//                                                         @"x":      @"x",
//                                                         @"y":      @"y",
//                                                         @"z":      @"z",
//                                                         @"m":      @"m"
//                                                         }];
//    
//    setLocationRequestDescriptor = [RKRequestDescriptor
//                                    requestDescriptorWithMapping:setLocationRequestMapping
//                                    objectClass:[SetLocationRequest class]
//                                    rootKeyPath:nil
//                                    method:RKRequestMethodAny];
//    
//    [rkmanager addRequestDescriptor:setLocationRequestDescriptor];
//    [rkmanager addResponseDescriptor:setLocationResponseDescriptor];
//    
//    setLocationRequest = [SetLocationRequest new];
//    setLocationRequest.userID = userID;
//    setLocationRequest.x = [[NSNumber numberWithDouble:coordinate.longitude] stringValue];
//    setLocationRequest.y = [[NSNumber numberWithDouble:coordinate.latitude] stringValue];;
//
//    NSString *requestURL = [[[[[TWAPIManager twAPI_ip]
//                               stringByAppendingString: restPath]
//                              stringByAppendingString: @"/"]
//                             stringByAppendingString: [@(userID) stringValue]]
//                            stringByAppendingString:@"/location"];
//    // POST to create
//    [rkmanager postObject:setLocationRequest path:requestURL
//               parameters:nil
//                  success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
//                      SetLocationResponse *locationResponse = [result firstObject];
//                      created_date = locationResponse.created_at;
//                      //NSLog(@"id: %d", locationResponse.userID);
//                  }
//                  failure:nil];
//    date = [dateFormat dateFromString:created_date];
//    
//    [rkmanager removeRequestDescriptor:setLocationRequestDescriptor];
//    [rkmanager removeResponseDescriptor: setLocationResponseDescriptor];
//    return date;
//}

//- (CLLocationCoordinate2D ) getLocation: (int) userID{
////    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[GetLocationResponse class]];
////    [mapping addAttributeMappingsFromDictionary:@{
////                                                  @"x":         @"lon",
////                                                  @"y":         @"lat",
////                                                  @"z":         @"altitude",
////                                                  @"m":         @"m"
////                                                  }];
////    
////    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
////                                                responseDescriptorWithMapping:mapping
////                                                method:RKRequestMethodAny
////                                                pathPattern:nil
////                                                keyPath:nil
////                                                statusCodes:statusCodes];
////    
////    NSString *requestURL = [[[[[TWAPIManager twAPI_ip]
////                              stringByAppendingString: restPath]
////                              stringByAppendingString: @"/"]
////                              stringByAppendingString: [@(userID) stringValue]]
////                              stringByAppendingString:@"/location"];
////    
////    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
////    
////    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc]
////                                           initWithRequest:request
////                                           responseDescriptors:@[responseDescriptor]];
////    
////    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
////        locationResponse = [result firstObject];
////    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
////        NSLog(@"Failed with error: %@", [error localizedDescription]);
////    }];
////    
////    [operation start];
////   
////    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([locationResponse.lat doubleValue], [locationResponse.lon doubleValue]);
////    
////    return coordinate;
////}
@end