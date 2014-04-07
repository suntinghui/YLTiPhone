//
//  AnnouncementListViewController.m
//  YLTiPhone
//
//  Created by xushuang on 13-12-11.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AnnouncementListViewController.h"
#import "AnnouncementModel.h"
#import "AnnouncementCell.h"
#import "DateUtil.h"

#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 240.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface AnnouncementListViewController ()

@end

@implementation AnnouncementListViewController

@synthesize announcementList = _announcementList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
     announcementList:(NSMutableArray *)announcementList
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _announcementList = announcementList;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"公 告";
    self.hasTopView = YES;
    
    [self requestAction];
}

- (void)requestAction
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[[AppDataCenter sharedAppDataCenter] getValueWithKey:@"__PHONENUM"] forKey:@"tel"];
    //公告查询 089004
    [[Transfer sharedTransfer] startTransfer:@"089004" fskCmd:nil paramDic:dic];
}

-(void)refreshTabelView
{
    if (!self.announcementList || [self.announcementList count] == 0) {
        [self.myTableView setHidden:YES];
        UIImageView *emptyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyImage.png"]];
        [emptyView setFrame:CGRectMake(97, 180, 126, 80)];
        [self.view addSubview:emptyView];
    }else {
        if (self.myTableView == nil) {
            self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, VIEWHEIGHT + 20) style:UITableViewStyleGrouped];
            self.myTableView.delegate = self;
            self.myTableView.dataSource = self;
            [self.myTableView setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:self.myTableView];
        }
    }
    
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.announcementList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil)
    {
        cell = [[AnnouncementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.announcementList && [self.announcementList count] != 0)
    {
        AnnouncementModel *model = [self.announcementList objectAtIndex:indexPath.section];
        cell.titleLabel.text = [NSString stringWithFormat:@">>>%@",model.notice_title];
        cell.contentLabel.text = model.notice_content;
        cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@",[DateUtil formatDateString:model.notice_date],[DateUtil formatTimeString:model.notice_time]];
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [model.notice_content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        cell.contentLabel.frame = CGRectMake(10, 3, 300, size.height);
        
        cell.dateLabel.frame = CGRectMake(150, size.height-30, 130, 30);
    }
    return cell;
}

//动态判断cell高度
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnouncementModel *model = [self.announcementList objectAtIndex:indexPath.section];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [model.notice_content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//    [cell setFrame:CGRectMake(90, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2)-30, MAX(size.height, 44.0f))];
    CGFloat height = MAX(size.height, 44.0f);
    return height;
}

@end
