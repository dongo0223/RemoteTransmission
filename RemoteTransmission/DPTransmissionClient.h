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
typedef void(^DPTorrentBlock)(NSDictionary *torrent);

@interface DPTransmissionClient : NSObject

@property (nonatomic, assign, readonly, getter = isConnected) BOOL connected;

- (NSOperation *) connectCompletion:(DPPlainBlock)completionBlock error:(DPErrorBlock)errorBlock;
- (NSOperation *) connectToURL:(NSString*)url Completion:(DPPlainBlock)completionBlock error:(DPErrorBlock)errorBlock;
- (void)disconnect;
- (NSOperation *) retrieveTorrentsCompletion:(DPTorrentsBlock)completionBlock error:(DPErrorBlock)errorBlock;
- (NSOperation *)retrieveTorrent:(NSInteger)identifier completion:(DPTorrentBlock)completionBlock error:(DPErrorBlock)errorBlock;
- (NSOperation *)startTorrent:(NSInteger)torrentId completion:(DPPlainBlock)completionBlock error:(DPErrorBlock)errorBlock;
- (NSOperation *)stopTorrent:(NSInteger)torrentId completion:(DPPlainBlock)completionBlock error:(DPErrorBlock)errorBlock;
//- (NSOperation *)removeTorrent:(NSInteger)torrentId deleteData:(BOOL)deleteData completion:(DPPlainBlock)completionBlock error:(DPErrorBlock)errorBlock;

//- (NSOperation *)addTorrentFromURL:(NSURL *)url completion:(DPPlainBlock)completionBlock error:(DPErrorBlock)errorBlock;
@end
