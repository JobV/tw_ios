//
//  UserResult.m
//
//  File generated by Magnet rest2mobile 1.1 - Dec 25, 2014 2:15:34 PM
//  @See Also: http://developer.magnet.com
//
#import "UserResult.h"


@implementation UserResult

+ (NSDictionary *)attributeMappings {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:@{
        @"magnetId" : @"id",
    }];
    [dictionary addEntriesFromDictionary:[super attributeMappings]];
    return [dictionary copy];
}

+ (NSDictionary *)listAttributeTypes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:@{
    }];
    [dictionary addEntriesFromDictionary:[super listAttributeTypes]];
    return [dictionary copy];
}

@end