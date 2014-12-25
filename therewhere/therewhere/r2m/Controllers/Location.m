//
//  Location.m
//
//  File generated by Magnet rest2mobile 1.1 - Dec 25, 2014 2:39:41 PM
//  @See Also: http://developer.magnet.com
//
#import "Location.h"

@implementation Location

+ (NSDictionary *)metaData {

    NSMutableDictionary *controllerMetaData = [NSMutableDictionary dictionary];

    MMControllerMethod *method;
    //controller schema for interface Location

    //controller schema for controller method getLocation
    method = [MMControllerMethod new];
    method.name = @"getLocation";
    method.path = @"api/v1/location/{userID}";
    method.baseURL = [NSURL URLWithString:@"http://localhost:3000"];
    method.method = @"GET";
    method.consumes = [NSSet setWithObjects:@"application/json", nil];
    method.produces = [NSSet setWithObjects:@"application/json", nil];

    NSMutableArray *locationGetLocationParams = [NSMutableArray new];
    MMControllerParam *locationGetLocationUserID = [MMControllerParam new];
    locationGetLocationUserID.name = @"userID";
    locationGetLocationUserID.style = @"TEMPLATE";
    locationGetLocationUserID.type = @"NSString *";
    locationGetLocationUserID.optional = @NO;
    [locationGetLocationParams addObject:locationGetLocationUserID];

    MMControllerParam *locationGetLocationBody = [MMControllerParam new];
    locationGetLocationBody.name = @"body";
    locationGetLocationBody.style = @"PLAIN";
    locationGetLocationBody.type = @"GetLocationRequest *";
    locationGetLocationBody.optional = @YES;
    [locationGetLocationParams addObject:locationGetLocationBody];

    method.parameters = [locationGetLocationParams copy];
    method.returnType = @"_bean:LocationResult";
    [controllerMetaData setObject:method forKey:@"Location:getLocation"];

    //controller schema for controller method setLocation
    method = [MMControllerMethod new];
    method.name = @"setLocation";
    method.path = @"api/v1/location";
    method.baseURL = [NSURL URLWithString:@"http://localhost:3000"];
    method.method = @"POST";
    method.consumes = [NSSet setWithObjects:@"application/json", nil];
    method.produces = [NSSet setWithObjects:@"application/json", nil];

    NSMutableArray *locationSetLocationParams = [NSMutableArray new];
    MMControllerParam *locationSetLocationBody = [MMControllerParam new];
    locationSetLocationBody.name = @"body";
    locationSetLocationBody.style = @"PLAIN";
    locationSetLocationBody.type = @"SetLocationRequest *";
    locationSetLocationBody.optional = @YES;
    [locationSetLocationParams addObject:locationSetLocationBody];

    method.parameters = [locationSetLocationParams copy];
    method.returnType = @"_bean:SetLocationResult";
    [controllerMetaData setObject:method forKey:@"Location:setLocation"];


    return [controllerMetaData copy];
}

@end
