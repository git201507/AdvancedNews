//
//  DropDownListView.m
//  DropDownDemo
//

#import "DropDownListView.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))
#define MaxCountDisplayTableCell 8

@implementation DropDownListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        currentExtendSection = -1;
        self.dropDownDataSource = datasource;
        self.dropDownDelegate = delegate;
//        [self.mTableView setBounces:NO];
        
        NSInteger sectionNum =0;
        if ([self.dropDownDataSource respondsToSelector:@selector(numberOfSections)] )
        {
            sectionNum = [self.dropDownDataSource numberOfSections];
        }
        
        if (sectionNum == 0)
        {
            self = nil;
        }
        
        //初始化默认显示view
        CGFloat sectionWidth = (1.0 * (frame.size.width) / sectionNum);
        for (int i = 0; i < sectionNum; i++)
        {
            UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(sectionWidth*i, 1, sectionWidth, frame.size.height-2)];
            sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
            [sectionBtn addTarget:self action:@selector(sectionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            NSString *sectionBtnTitle = @"--";
            if ([self.dropDownDataSource respondsToSelector:@selector(titleInSection:index:)])
            {
                sectionBtnTitle = [self.dropDownDataSource titleInSection:i index:[self.dropDownDataSource defaultShowSection:i]];
            }
            UIColor *color = [UIColor blackColor];
            if ([self.dropDownDataSource respondsToSelector:@selector(titleInSection:index:)])
            {
                sectionBtnTitle = [self.dropDownDataSource titleInSection:i index:[self.dropDownDataSource defaultShowSection:i]];
            }
            if ([self.dropDownDataSource respondsToSelector:@selector(defaultTitleColor)])
            {
                color = [self.dropDownDataSource defaultTitleColor];
            }
            [sectionBtn  setTitle:sectionBtnTitle forState:UIControlStateNormal];
            [sectionBtn setTitleColor:color forState:UIControlStateNormal];
            sectionBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            if ([self.dropDownDataSource respondsToSelector:@selector(defaultTitleFont)])
            {
                sectionBtn.titleLabel.font = [self.dropDownDataSource defaultTitleFont];
            }
            sectionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//            sectionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [self addSubview:sectionBtn];
            
            
            UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(sectionWidth * i + (sectionWidth - 20), 7, 16, 16)];
            NSLog(@"%f",self.frame.size.height);
            [sectionBtnIv setImage:[UIImage imageNamed:@"arrow_nav_dn"]];
            [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
            sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
            
            [self addSubview: sectionBtnIv];
            
            if ((i < sectionNum) && (i != 0))
            {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth * i, frame.size.height / 4, 1, frame.size.height / 2)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:lineView];
            }
            
        }
    }
    return self;
}

-(void)sectionBtnTouch:(UIButton *)btn
{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    if (currentExtendSection == section) {
        [self hideExtendedChooseView];
    }else{
        currentExtendSection = section;
        [self showChooseListViewInSection:currentExtendSection choosedIndex:[self.dropDownDataSource defaultShowSection:currentExtendSection]];
    }
}

-(void)sectionBtnTouch:(UIButton *)btn displayView:(UIView *)objView
{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    if (currentExtendSection == section) {
        [self hideExtendedChooseView];
        [objView setHidden:YES];
    }else{
        currentExtendSection = section;
        [self showChooseListViewInSection:currentExtendSection choosedIndex:[self.dropDownDataSource defaultShowSection:currentExtendSection]];
        [objView setHidden:NO];
    }
}

- (void)setTitle:(NSString *)title inSection:(NSInteger) section
{
    UIButton *btn = (id)[self viewWithTag:SECTION_BTN_TAG_BEGIN + section];
    [btn setTitle:title forState:UIControlStateNormal];
}

- (void)setCellColor:(UIColor *)backgroundColor
{
    _colorForCell = backgroundColor;
}

- (void)setTitleColor:(UIColor *)color inSection:(NSInteger) section
{
    UIButton *btn = (id)[self viewWithTag:SECTION_BTN_TAG_BEGIN + section];
    [btn setTitleColor:color forState:UIControlStateNormal];
}

- (BOOL)isShow
{
    if (currentExtendSection == -1)
    {
        return NO;
    }
    return YES;
}
-  (void)hideExtendedChooseView
{
    if (currentExtendSection != -1)
    {
        currentExtendSection = -1;
        CGRect rect = self.mTableView.frame;
        rect.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableBaseView.alpha = 1.0f;
            self.mTableView.alpha = 1.0f;
            
            self.mTableBaseView.alpha = 0.2f;
            self.mTableView.alpha = 0.2;
            
            self.mTableView.frame = rect;
        }completion:^(BOOL finished) {
            [self.mTableView removeFromSuperview];
            [self.mTableBaseView removeFromSuperview];
        }];
    }
}

-(void)showChooseListViewInSection:(NSInteger)section choosedIndex:(NSInteger)index
{
    long i = [self.dropDownDataSource numberOfRowsInSection:section] * 35;
    i = (i < (35 * MaxCountDisplayTableCell) ) ? i : (35 * MaxCountDisplayTableCell);
    //add by w.shuo
    if (!self.mTableView)
    {
        self.mTableBaseView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height , self.frame.size.width, self.mSuperView.frame.size.height - self.frame.origin.y - self.frame.size.height)];
        self.mTableBaseView.backgroundColor = [UIColor /*colorWithWhite:0.0f alpha:0.5*/ clearColor];
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.mTableBaseView addGestureRecognizer:bgTap];
        
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, i) style:UITableViewStylePlain];
        NSLog(@"%f",self.frame.origin.x);
        NSLog(@"%f",self.frame.origin.y);
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        [self.mTableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.mTableView.layer setBorderWidth:1];
        [self.mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        
    }
    
    //修改tableview的frame
    int sectionWidth = (self.frame.size.width)/[self.dropDownDataSource numberOfSections];
    CGRect rect = self.mTableView.frame;
//    rect.origin.x = sectionWidth * section + 15;
    rect.size.width = sectionWidth;
    rect.size.height = 0;
    self.mTableView.frame = rect;
    [self.mSuperView addSubview:self.mTableBaseView];
    [self.mSuperView addSubview:self.mTableView];
    
    //动画设置位置
    rect .size.height = i;
    [UIView animateWithDuration:0.3 animations:^{
        self.mTableBaseView.alpha = 0.2;
        self.mTableView.alpha = 0.2;
        
        self.mTableBaseView.alpha = 1.0;
        self.mTableView.alpha = 1.0;
        self.mTableView.frame =  rect;
    }];
    [self.mTableView reloadData];
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self hideExtendedChooseView];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect frame = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, frame);
    CGContextSaveGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dropDownDelegate respondsToSelector:@selector(chooseAtSection:index:)])
    {
        NSString *chooseCellTitle = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row];
        
        UIButton *currentSectionBtn = (UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN + currentExtendSection];
        [currentSectionBtn setTitle:chooseCellTitle forState:UIControlStateNormal];
        
        [self.dropDownDelegate chooseAtSection:currentExtendSection index:indexPath.row];
        [self hideExtendedChooseView];
    }
}

#pragma mark -- UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSInteger i = [self.dropDownDataSource numberOfRowsInSection:currentExtendSection];
    // modify by w.shuo for 自定义时间crash ios8.0
    NSInteger i = [self.dropDownDataSource numberOfRowsInSection:section];
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView setBounces:NO];
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *titleStr = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row];
    NSArray *array = [titleStr componentsSeparatedByString:@","];
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"DropDownListView" owner:self options:nil];
    cell = [nibViews objectAtIndex:0];
    if ([array count] > 0)
    {
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:10001];
        nameLabel.text = [array objectAtIndex:0];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [nameLabel setTextColor:[UIColor colorWithRed:104/255.0f green:104/255.0f blue:104/255.0f alpha:1]];
        if (_colorForCell)
        {
            [nameLabel setTextColor:[UIColor whiteColor]];
        }
    }
    if ([array count] > 1)
    {
        UILabel *cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, cell.frame.size.width - 90, cell.frame.size.height)];
        cardLabel.text = [array objectAtIndex:1];
        cardLabel.font = [UIFont systemFontOfSize:12];
        cardLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [cardLabel setTextColor:[UIColor colorWithRed:104/255.0f green:104/255.0f blue:104/255.0f alpha:1]];
        [cell addSubview:cardLabel];
    }
//    cell.textLabel.text = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row];
//    cell.textLabel.font = [UIFont systemFontOfSize:12];

    if (_colorForCell) {
//        UIImageView * bgImage = (UIImageView *) [cell viewWithTag:0];
//        [bgImage setBackgroundColor:_colorForCell];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[self imageWithColor:_colorForCell]];
    }
    else
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bor_bottom"]];
    }
    return cell;
}

@end
