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
        self.baseAPI=@"http://127.0.0.1:8080/recipes/";
    }
    return self;
}

-(void)getMenu:(NSString *)resturantName{
    NSString *API=[self.baseAPI stringByAppendingString:resturantName];
    NSURL *url=[NSURL URLWithString:API];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    NSLog(@"URL: %@", url);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success
//        NSData *data=(NSData *)responseObject;
        NSLog(@"success");
        NSDictionary *result=(NSDictionary *)responseObject;
        NSLog(@"%@", result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
        NSLog(@"Fail to access Menu API in MenuClinet.m");
    }];
    
    [operation start];
    
}


@end
