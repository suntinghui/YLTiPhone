//
//  GatherMahagerCell.m
//  POS2iPhone
//
//  Created by jia liao on 1/17/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import "GatherManagerCell.h"

@implementation GatherManagerCell
@synthesize accountLabel = _accountLabel;
@synthesize nameLabel = _nameLabel;
@synthesize bankLabel = _bankLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *tmpAccount = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 68, 21)];
        [tmpAccount setText:@"卡    号:"];
        [self setLeftLabelStyle:tmpAccount];
        [self addSubview:tmpAccount];
        _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 8, 200, 21)];
        [_accountLabel setText:@"_accountLabel"];
        [self setRightLabelStyle:_accountLabel];
        [self addSubview:_accountLabel];
        
        UILabel *tmpName = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 68, 21)];
        [tmpName setText:@"姓    名:"];
        [self setLeftLabelStyle:tmpName];
        [self addSubview:tmpName];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, 200, 21)];
        [_nameLabel setText:@"_nameLabel"];
        [self setRightLabelStyle:_nameLabel];
        [self addSubview:_nameLabel];
        
        UILabel *tmpBank = [[UILabel alloc] initWithFrame:CGRectMake(20, 52, 68, 21)];
        [tmpBank setText:@"开户行:"];
        [self setLeftLabelStyle:tmpBank];
        [self addSubview:tmpBank];
        _bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 52, 200, 21)];
        [_bankLabel setText:@"_bankLabel"];
        [self setRightLabelStyle:_bankLabel];
        [self addSubview:_bankLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLeftLabelStyle:(UILabel*)label
{
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextAlignment:NSTextAlignmentLeft];
}

-(void)setRightLabelStyle:(UILabel*)label
{
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label setTextAlignment:NSTextAlignmentRight];
}
@end
