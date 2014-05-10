//
//  DPTorrentCell.m
//  RemoteTransmission
//
//  Created by user on 5/10/14.
//  Copyright (c) 2014 dongo0223. All rights reserved.
//

#import "DPTorrentCell.h"
#import "DPTransmissionEngine.h"
@implementation DPTorrentCell

BPTorrent *_torrent;

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
    _torrent = torrent;
}


- (IBAction)actionTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(torrentCellDidTapActionButton:)]) {
        [self.delegate torrentCellDidTapActionButton:self];
    }
}

-(IBAction)changeStatus:(id)sender{
    if([self.torrentStatusLabel.text isEqualToString:@"STOPPED"]){
        NSLog(@"Call resume for id(%@)", _torrent.id);
        [[DPTransmissionEngine sharedEngine] resumeTorrent:_torrent completion:^{
            NSLog(@"Resume Success!");
        } error:^(NSError *error) {
            NSLog(@"Resume Failed!");
        }];
    } else if ([self.torrentStatusLabel.text isEqualToString:@"ACTIVE"]){
        NSLog(@"Call pause for id(%@)", _torrent.id);
        [[DPTransmissionEngine sharedEngine] pauseTorrent:_torrent completion:^{
            NSLog(@"Pause Success!");
        } error:^(NSError *error) {
            NSLog(@"Pause Failed!");
        }];
    }

}

@end
