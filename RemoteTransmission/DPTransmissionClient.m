//
//  DPTransmissionClient.m
//  RemoteTransmission
//
//  Created by user on 5/9/14.
//  Copyright (c) 2014 dongo0223. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "DPTransmissionClient.h"

NSString * const cTransmissionSessionIdHeader = @"X-Transmission-Session-Id";

@interface DPTransmissionClient()
@property (nonatomic, copy) NSString *sessionId;

@end

AFHTTPRequestOperationManager *manager;

@implementation DPTransmissionClient

- (void)setSessionId:(NSString *)sessionId {

    [[manager requestSerializer] setValue:sessionId forHTTPHeaderField:cTransmissionSessionIdHeader];
    
}

- (NSString *)sessionId {
    return [[[manager requestSerializer] HTTPRequestHeaders] valueForKey:cTransmissionSessionIdHeader];
}

- (BOOL)isConnected {
    return (self.sessionId != nil);
}

- (NSOperation *) connectCompletion:(DPPlainBlock)completionBlock error:(DPErrorBlock)errorBlock{
    
    manager = [[AFHTTPRequestOperationManager alloc]
                       initWithBaseURL:
                          [NSURL URLWithString:@"http://192.192.192.145:9091/transmission/rpc"]
            ];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFHTTPRequestOperation *requestOperation;
    
    requestOperation = [manager POST:@"" parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.sessionId = [operation.response.allHeaderFields objectForKey:cTransmissionSessionIdHeader];
            NSLog(@"SessionId: %@", self.sessionId);
            if (completionBlock != nil) {
                completionBlock();
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (operation.response.statusCode == 409) {
                self.sessionId = [operation.response.allHeaderFields objectForKey:cTransmissionSessionIdHeader];
                NSLog(@"SessionId: %@", self.sessionId);
                if (completionBlock != nil) {
                    completionBlock();
                }
                return;
            }
            
            NSLog(@"ERROR: %@", error);
            if (errorBlock != nil) {
                errorBlock(error);
            }
        }
    ];
    
    
    return requestOperation;
}

- (void)disconnect {
    self.sessionId = nil;
}

- (NSOperation *) retrieveTorrentsCompletion:(DPTorrentsBlock)completionBlock error:(DPErrorBlock)errorBlock{
    AFHTTPRequestOperation *requestOperation;
    NSDictionary *params = @{
                             @"method" : @"torrent-get",
                             @"arguments" : @{ @"fields" :
                                                        @[ @"id",
                                                           @"name",
                                                           @"status",
                                                           @"totalSize",
                                                           @"uploadRatio",
                                                           @"leftUntilDone",
                                                           @"percentDone",
                                                           @"recheckProgress",
                                                           @"desiredAvailable",
                                                           @"isFinished",
                                                           @"error",
                                                           @"errorString",
                                                           @"rateDownload",
                                                           @"rateUpload",
                                                           @"magenetLink",
                                                           @"addedDate" ]
                                               }
                             };
    
    requestOperation = [manager POST:@"" parameters:params
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response %@", responseObject);
            NSArray *dicts = [[responseObject objectForKey:@"arguments"] objectForKey:@"torrents"];
            if (completionBlock != nil) {
                completionBlock(dicts);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            if (errorBlock != nil) {
                errorBlock(error);
            }
        }
        ];
    return requestOperation;
}

@end
