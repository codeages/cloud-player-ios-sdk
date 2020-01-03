//
//  ESJWTTokenTool.m
//  ESqiqiuyunPlayerSDK_Example
//
//  Created by aaayi on 2019/10/30.
//  Copyright © 2019 ayia. All rights reserved.
//

#import "ESJWTTokenTool.h"
#import <JWT/JWT.h>

@implementation ESJWTTokenTool
+ (NSString *)JWTTokenWithPlayload:(NSString *)resNo previewTime:(NSTimeInterval)previewTime headResNo:(NSString * _Nullable)headResNo isPlayAudio:(BOOL)playAudio{
    NSString *jti = [NSString stringWithFormat:@"%dsssss%dssssssss%d", arc4random() % 10, arc4random() % 10, arc4random() % 10];
    NSTimeInterval exp = [NSDate distantFuture].timeIntervalSince1970 +  (arc4random() % 100);
        NSDictionary *playload = @{
                @"no": resNo ? : @"",
                @"jti": jti,
                @"preview":@(previewTime),
                @"exp": @(exp),
                @"playAudio": playAudio ? @"1" : @"0",
                @"head": headResNo?:@"",
                @"times": @(100),
//                @"native":@"1"
        };
        return [self JWTTokenWithPlayload:playload];
}

+ (NSString *)JWTTokenWithPlayload:(NSDictionary *)playload {
    return [self JWTTokenWithPlayload:playload secret:SCHOOL_SECRET_KEY];
}

+ (NSString *)JWTTokenWithPlayload:(NSDictionary *)playload secret:(NSString *)secret{
    NSDictionary *header = @{ @"alg": @"HS256",
                              @"typ": @"JWT" };
    id<JWTAlgorithm> algorithm = [JWTAlgorithmFactory algorithmByName:@"HS256"];
    NSString *token =  [JWTBuilder encodePayload:playload].headers(header).secret(secret).algorithm(algorithm).encode;
    return token;
}

+ (NSString *)JWTTokenWithResNo:(NSString *)resNo {
    return [self JWTTokenWithResNo:resNo playAudio:@"0"];
}

+ (NSString *)JWTTokenWithResNo:(NSString *)resNo playAudio:(NSString *)playAudio {
    NSString *jti = [NSString stringWithFormat:@"%dsssss%dssssssss%d", arc4random() % 10, arc4random() % 10, arc4random() % 10];
    NSTimeInterval exp = [NSDate distantFuture].timeIntervalSince1970 +  (arc4random() % 100);
    NSDictionary *payload = @{
            @"no": resNo ? : @"",
            @"jti": jti,
//            @"preview":@(10),
            @"exp": @(exp),
            @"playAudio": playAudio ? : @"0",
//            @"head":@"7b83f8d71ecb4a9dbc85e09bce4d121f",
            @"times": @(100)
    };
    NSDictionary *header = @{ @"alg": @"HS256",
                              @"typ": @"JWT" };
    NSString *secret = @"wyOV9rew98ClmpuklnT1Y80omjc7ZLel";
//    NSString *secret = @"M0sZ2S5gCVql7AkRJiKMnEMoYXxGRbwE";
    id<JWTAlgorithm> algorithm = [JWTAlgorithmFactory algorithmByName:@"HS256"];
    NSString *token =  [JWTBuilder encodePayload:payload].headers(header).secret(secret).algorithm(algorithm).encode;
    return token;
}



@end
