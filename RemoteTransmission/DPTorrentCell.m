//
//  DPTorrentCell.m
//  RemoteTransmission
//
//  Created by user on 5/10/14.
//  Copyright (c) 2014 dongo0223. All rights reserved.
//

#import "DPTorrentCell.h"

@implementation DPTorrentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateForTorrent:(BPTorrent *)torrent {
    self.torrentNameLabel.text = [torrent name];
    
    if([torrent isActive]){
        self.torrentStatusLabel.text = @"ACTIVE";
    } else if ([torrent isStopped]){
        self.torrentStatusLabel.text = @"STOPPED";
    } else {
        self.torrentStatusLabel.text = @"UNKNOWN";
    }
    
    
    if (torrent.errorMessage.length != 0) {
        self.torrentStatusStringLabel.text = torrent.errorMessage;
        self.torrentStatusStringLabel.textColor = [UIColor redColor];
    } else {
        //NSNumber *percentage = [NSNumber numberWithFloat:(torrent.totalSizeValue - torrent.leftUntilDoneValue) / torrent.totalSizeValue];
        NSMutableString *stats = [NSMutableString stringWithFormat:@"%@%%",torrent.percentDone];
        [stats appendFormat:@" Ratio: %.2f", torrent.ratio];
        if (torrent.uploadRate > 0) {
            [stats appendFormat:@" ▲ %.2f KB/s", torrent.uploadRate];
        }
        if (torrent.downloadRate > 0) {
            [stats appendFormat:@" ▼ %.2f KB/s", torrent.downloadRate];
        }
        self.torrentStatusStringLabel.text = stats;
    }
}

@end
