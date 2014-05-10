//
//  DPTorrentCell.h
//  RemoteTransmission
//
//  Created by user on 5/10/14.
//  Copyright (c) 2014 dongo0223. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPTorrent.h"

@protocol DPTorrentCellDelegate;
@interface DPTorrentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *torrentNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *torrentStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *torrentStatusStringLabel;
@property (nonatomic, weak) id<DPTorrentCellDelegate> delegate;

- (IBAction)actionTapped:(id)sender;
- (void)updateForTorrent:(BPTorrent *)torrent;

@end

@protocol DPTorrentCellDelegate <NSObject>

@optional
- (void)torrentCellDidTapActionButton:(DPTorrentCell *)cell;

@end