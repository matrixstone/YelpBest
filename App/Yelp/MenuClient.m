//
//  MenuClient.m
//  Yelp
//
//  Created by Xu He on 3/8/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "MenuClient.h"
#import "AFNetworking.h"

@interface MenuClient()

@property (nonatomic, strong) NSString *baseAPI;

@end

@implementation MenuClient

-(id)init{
    self=[super init];
    if (self) {
//        self.baseAPI=@"http://10.73.212.155:8080/recipes/";
//        self.baseAPI=@"http://10.87.145.159:8080/recipes/";
        self.baseAPI=@"http://172.21.167.158:8080/recipes/";
    }
    return self;
}

-(void)getMenu:(NSString *)resturantName{
    NSString *API=[self.baseAPI stringByAppendingString:resturantName];
    NSURL *url=[NSURL URLWithString:API];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
//    NSLog(@"URL: %@", url);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success
//        NSData *data=(NSData *)responseObject;
//        NSLog(@"success");
        NSDictionary *result=(NSDictionary *)responseObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuJson" object:result];
//        [[NSNotificationCenter defaultCenter]
//        NSLog(@"%@", result);
//        return result;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
        NSLog(@"Fail to find resturant %@", url);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuJson" object:nil];
    }];
    [operation start];

}

-(void)updateMenu:(NSString *)resturantName with:(NSString *) dish name:(NSString *)up param:(NSString *)value{
    NSString *restAPI=[@"http://172.21.167.158:8080/update/" stringByAppendingString:resturantName];
    NSString *dishAPI=[[restAPI stringByAppendingString:@"/"] stringByAppendingString:dish];
    NSString *upAPI=[[dishAPI stringByAppendingString:@"/"] stringByAppendingString:up];
    NSString *finalAPI=[[upAPI stringByAppendingString:@"/"] stringByAppendingString:value];
    
    finalAPI=[finalAPI stringByReplacingOccurrencesOfString: @" " withString:@"%20"];
//    finalAPI=[finalAPI stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *aaurl=[NSURL URLWithString:finalAPI];
//    NSLog(@"final api: %@", finalAPI);
//     NSLog(@"aaaURL: %@", aaurl);
    NSURLRequest *aarequest = [NSURLRequest requestWithURL:aaurl];
    
    // 2
   
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:aarequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success
        //        NSData *data=(NSData *)responseObject;
        //        NSLog(@"success");
//        NSDictionary *result=(NSDictionary *)responseObject;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuJson" object:result];
                NSLog(@"Update SUccess");
        //        return result;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
        NSLog(@"Fail to update ");
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"menuJson" object:nil];
    }];
    [operation start];

}


@end
