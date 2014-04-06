//
//  ChongZhengCell.m
//  POS2iPhone
//
//  Created by jia liao on 1/17/13.
//  Copyright (c) 2013 RYX. All rights reserved.
//

#import "ChongZhengCell.h"

@implementation ChongZhengCell

@synthesize typeLabel = _typeLabel;
@synthesize amountLabel = _amountLabel;
@synthesize countLabel = _countLabel;
@synthesize stateLabel = _stateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *tmpTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 70, 21)];
        [tmpTime setText:@"交易类型:"];
        [tmpTime setTextAlignment:NSTextAlignmentLeft];
        [self setLabelStyle:tmpTime];
        [self addSubview:tmpTime];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 13, 220, 21)];
        [self.typeLabel setTextAlignment:NSTextAlignmentRight];
        [self.typeLabel setText:@"消费"];
        [self setLabelStyle:self.typeLabel];
        [self addSubview:self.typeLabel];
        
        UILabel *tmpAmount = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 70, 21)];
        [tmpAmount setTextAlignment:NSTextAlignmentLeft];
        [tmpAmount setText:@"交易金额:"];
        [self setLabelStyle:tmpAmount];
        [self addSubview:tmpAmount];
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 42, 220, 21)];
        [self.amountLabel setTextAlignment:NSTextAlignmentRight];
        [self.amountLabel setText:@"100.00"];
        [self setLabelStyle:self.amountLabel];
        [self addSubview:self.amountLabel];
        
        
        UILabel *tmpCount = [[UILabel alloc] initWithFrame:CGRectMake(10, 71, 70, 21)];
        [tmpCount setTextAlignment:NSTextAlignmentLeft];
        [tmpCount setText:@"交易次数:"];
        [self setLabelStyle:tmpCount];
        [self addSubview:tmpCount];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 71, 220, 21)];
        [self.countLabel setTextAlignment:NSTextAlignmentRight];
        [self.countLabel setText:@"3 次"];
        [self setLabelStyle:self.countLabel];
        [self addSubview:self.countLabel];
        
        UILabel *tmpState = [[UILabel alloc] initWithFrame:CGRectMake(10, 101, 70, 21)];
        [tmpState setTextAlignment:NSTextAlignmentLeft];
        [tmpState setText:@"交易状态:"];
        [self setLabelStyle:tmpState];
        [self addSubview:tmpState];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 101, 220, 21)];
        [self.stateLabel setTextAlignment:NSTextAlignmentRight];
        [self.stateLabel setText:@"成功"];
        [self setLabelStyle:self.stateLabel];
        [self addSubview:self.stateLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setLabelStyle:(UILabel*)label
{
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
}


@end
