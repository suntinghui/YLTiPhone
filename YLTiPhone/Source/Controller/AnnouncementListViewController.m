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
#define TITLE_FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH 240.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface AnnouncementListViewController (){
    NSIndexPath *selectedCellIndexPath;
}

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
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize titlesize = [model.notice_title sizeWithFont:[UIFont systemFontOfSize:TITLE_FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"%f",titlesize.height);
        cell.titleLabel.frame = CGRectMake(10+ios7_x, 5, 280, titlesize.height);
        if (selectedCellIndexPath != nil&&[selectedCellIndexPath compare:indexPath] == NSOrderedSame) {
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.notice_title];
            cell.contentLabel.text = model.notice_content;
            CGSize size = [model.notice_content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            cell.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.contentLabel.numberOfLines = 0;
            cell.contentLabel.frame = CGRectMake(10+ios7_x, 35, 275, size.height);
            
            cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@",[DateUtil formatDateString:model.notice_date],[DateUtil formatTimeString:model.notice_time]];
            cell.dateLabel.frame = CGRectMake(140, size.height+titlesize.height, 150, 30);
        }
        else{
            cell.titleLabel.text = [NSString stringWithFormat:@"<<<%@",model.notice_title];
            cell.contentLabel.text = model.notice_content;
            cell.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            cell.contentLabel.numberOfLines = 3;
            cell.contentLabel.frame = CGRectMake(10+ios7_x, 35, 275, 90);
            
            cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@",[DateUtil formatDateString:model.notice_date],[DateUtil formatTimeString:model.notice_time]];
            cell.dateLabel.frame = CGRectMake(140, 90+titlesize.height, 150, 30);
        }
    }
    return cell;
}

//动态判断cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnouncementModel *model = [self.announcementList objectAtIndex:indexPath.section];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);

    CGSize titlesize = [model.notice_title sizeWithFont:[UIFont systemFontOfSize:TITLE_FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//    [cell setFrame:CGRectMake(90, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2)-30, MAX(size.height, 44.0f))];
    if (selectedCellIndexPath != nil&&[selectedCellIndexPath compare:indexPath] == NSOrderedSame) {
        CGSize size = [model.notice_content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height = MAX(size.height+titlesize.height+30, 44.0f);
        return height;
    }
    CGFloat height = MAX(titlesize.height+90+30, 44.0f);
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    selectedCellIndexPath = indexPath;
    
    // Forces the table view to callheightForRowAtIndexPath
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationNone];
}

@end
