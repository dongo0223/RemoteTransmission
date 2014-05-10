//
//  DPTorrentCell.h
//  RemoteTransmission
//
//  Created by user on 5/10/14.
//  Copyright (c) 2014 dongo0223. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPTorrent.h"

@interface DPTorrentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *torrentNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *torrentStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *torrentStatusStringLabel;

- (void)updateForTorrent:(BPTorrent *)torrent;

@end
