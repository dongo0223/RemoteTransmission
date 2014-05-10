//
//  DPTransmissionEngine.h
//  RemoteTransmission
//
//  Created by user on 5/10/14.
//  Copyright (c) 2014 dongo0223. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPTransmissionClient.h"
#import "BPTorrent.h"

@interface DPTransmissionEngine : NSObject
@property (nonatomic, strong) DPTransmissionClient *client;
@property (nonatomic, assign) NSTimeInterval updateInterval;
- (void)resumeTorrent:(BPTorrent *)torrent completion:(DPPlainBlock)completionBlock error:(DPErrorBlock)errorBlock;
- (void)pauseTorrent:(BPTorrent *)torrent completion:(DPPlainBlock)completionBlock error:(DPErrorBlock)errorBlock;

+ (instancetype)sharedEngine;
- (void)startUpdates;
- (void)stopUpdates;
@end
