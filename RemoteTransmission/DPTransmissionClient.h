//
//  DPTransmissionClient.h
//  RemoteTransmission
//
//  Created by user on 5/9/14.
//  Copyright (c) 2014 dongo0223. All rights reserved.
//
typedef void(^DPPlainBlock)(void);
typedef void(^DPErrorBlock)(NSError *error);
typedef void(^DPTorrentsBlock)(NSArray *torrents);

@interface DPTransmissionClient : NSObject

@property (nonatomic, assign, readonly, getter = isConnected) BOOL connected;

- (NSOperation *) connectCompletion:(DPPlainBlock)completionBlock error:(DPErrorBlock)errorBlock;
- (void)disconnect;
- (NSOperation *) retrieveTorrentsCompletion:(DPTorrentsBlock)completionBlock error:(DPErrorBlock)errorBlock;

@end
