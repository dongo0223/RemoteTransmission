//
//  DPTransmissionEngine.m
//  RemoteTransmission
//
//  Created by user on 5/10/14.
//  Copyright (c) 2014 dongo0223. All rights reserved.
//

#import "DPTransmissionEngine.h"
#import <MagicalRecord+Setup.h>
#import <SVProgressHUD.h>

static void *kvoContext = &kvoContext;

@interface DPTransmissionEngine ()

@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) NSMutableArray *queuedTransferURLs;

@end

@implementation DPTransmissionEngine

- (void)setClient:(DPTransmissionClient *)client {
    if (_client == client) {
        return;
    }
    
    [_client removeObserver:self forKeyPath:@"connected" context:kvoContext];
    [self willChangeValueForKey:@"client"];
    _client = client;
    [self didChangeValueForKey:@"client"];
    [_client addObserver:self forKeyPath:@"connected" options:0 context:kvoContext];
    
    [BPTorrent MR_truncateAll];
}

+ (instancetype)sharedEngine {
    static DPTransmissionEngine *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DPTransmissionEngine alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _updateInterval = 10.0;
    //_queuedTransferURLs = [NSMutableArray array];
    
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    return self;
}

- (void)startUpdates {
    [self stopUpdates];
    [self update];
}

- (void)stopUpdates {
    [self.updateTimer invalidate];
}

- (void)update {
    __weak DPTransmissionEngine *weakSelf = self;
    [self.client retrieveTorrentsCompletion:^(NSArray *torrents) {
        [weakSelf applyTorrentUpdates:torrents];
        
        weakSelf.updateTimer = [NSTimer scheduledTimerWithTimeInterval:weakSelf.updateInterval
                                                                target:weakSelf
                                                              selector:@selector(update)
                                                              userInfo:nil
                                                               repeats:NO];
    } error:^(NSError *error) {
        NSLog(@"Update error: %@", error);
        if ([error.domain isEqualToString:NSURLErrorDomain]) {
            weakSelf.client = nil;
        }
    }];
}

- (void)applyTorrentUpdates:(NSArray *)torrents {
    for (NSDictionary *torrentDict in torrents) {
        // TODO: If a torrent is removed by the desktop client, it will not be removed from core data.
        // Since this array is all the known torrents, we may as well truncate any torrents in core data that are not in this array.
        
        NSString *identifier = [torrentDict objectForKey:BPTorrentAttributes.id];
        BPTorrent *torrent = [BPTorrent MR_findFirstByAttribute:BPTorrentAttributes.id
                                                      withValue:identifier];
        if (torrent == nil) {
            torrent = [BPTorrent torrentFromDictionary:torrentDict];
        } else {
            [torrent updateFromDictionary:torrentDict];
        }
    }
    NSError *error = nil;
    if (![[NSManagedObjectContext MR_contextForCurrentThread] save:&error]) {
        NSLog(@"Update save error: %@", error);
    }
}

- (void)resumeTorrent:(BPTorrent *)torrent completion:(DPPlainBlock)completionBlock error:(DPErrorBlock)errorBlock {
    [self.client startTorrent:torrent.idValue completion:^{
        [_client retrieveTorrent:torrent.idValue completion:^(NSDictionary *torrentDict) {
            [torrent updateFromDictionary:torrentDict];
            [[NSManagedObjectContext MR_contextForCurrentThread] save:nil];
            
            if (completionBlock != nil) {
                completionBlock();
            }
        } error:errorBlock];
    } error:errorBlock];
}

- (void)pauseTorrent:(BPTorrent *)torrent completion:(DPPlainBlock)completionBlock error:(DPErrorBlock)errorBlock {
    [self.client stopTorrent:torrent.idValue completion:^{
        [_client retrieveTorrent:torrent.idValue completion:^(NSDictionary *torrentDict) {
            [torrent updateFromDictionary:torrentDict];
            [[NSManagedObjectContext MR_contextForCurrentThread] save:nil];
            
            if (completionBlock != nil) {
                completionBlock();
            }
        } error:errorBlock];
    } error:errorBlock];
}

@end
