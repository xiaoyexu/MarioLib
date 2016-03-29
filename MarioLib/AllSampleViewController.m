//
//  AllSampleViewController.m
//  MarioLib
//
//  Created by Xu, Xiaoye on 1/23/15.
//  Copyright (c) 2015 Xu, Xiaoye. All rights reserved.
//

#import "AllSampleViewController.h"

@interface AllSampleViewController ()

@end

@implementation AllSampleViewController
{
    XYActivityIndicatorBarView* _processbarView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [XYUtility setTitle:@"Examples" inNavigationItem:self.navigationItem];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    XYTableCell* inputField = [XYTableCellFactory cellOfInputField:@"input1" label:@"Input1" ratio:0.3];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfInputField:@"input2" label:@"Input2" ratio:0.3 placeHolder:@"Enter here"];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfInputField:@"input3" label:@"Input3" ratio:0.3 placeHolder:@"Keyboard numpad" keyboardType:UIKeyboardTypeDecimalPad];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfTextViewField:@"textView1" label:@"Text View1" ratio:0.3 placeHolder:@"Placeholder and keyboard type" keyboardType:UIKeyboardTypeASCIICapable];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfTextViewField:@"textView2" label:@"Text View2" ratio:0.3 placeHolder:@"with heigh changing" keyboardType:UIKeyboardTypeAlphabet minHeight:100 maxHeigh:300];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfTextViewFieldUnfixed:@"textView3" label:@"Text View3" ratio:0.3 placeHolder:@"Not editable" keyboardType:UIKeyboardTypeAlphabet];
    inputField.field.value = @"All text will be displayed here, no matter how long it is, and table cell height will be changed automatically.\nThis is a example with multiple lines";
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfPicker:@"picker1" label:@"Pick" ratio:0.3 options:@"Option 1",@"value1",@"Option 2",@"value2",nil];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfDatePicker:@"picker2" label:@"Date" ratio:0.3];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfDatePicker:@"picker2" label:@"Pick 2" ratio:0.3 mode:UIDatePickerModeDateAndTime];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfDatePicker:@"picker3" label:@"Pick 3" ratio:0.3 mode:UIDatePickerModeTime];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfDatePicker:@"picker4" label:@"Pick 4" ratio:0.3 mode:UIDatePickerModeCountDownTimer];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfDatePicker:@"picker5" label:@"Pick 5" ratio:0.3 mode:UIDatePickerModeDateAndTime valueFormat:@"yyyy MM dd HH mm ss"];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfSelection:@"selection1" label:@"Selection" ratio:0.3 arrayOptions:@[@"Selection1",@"s1",@"Selection2",@"s2"]];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    XYButtonTableCell* button = (XYButtonTableCell*)[XYTableCellFactory cellOfButton:@"ltp" label:@"Long time process"];
    [button addTarget:self action:@selector(doSomething)];
    [self.tableDelegate.container addXYTableCell:button];
    
    XYButtonTableCell* button2 = (XYButtonTableCell*)[XYTableCellFactory cellOfButton:@"ltp2" label:@"with updater"];
    [button2 addTarget:self action:@selector(doSomething2)];
    [self.tableDelegate.container addXYTableCell:button2];
    
    XYUISegmentedControl* sc = [[XYUISegmentedControl alloc] initWithItems:@[@"Option1",@"Option2",@"Option3"]];
    sc.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    sc.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    sc.selectedTitleFont = [UIFont systemFontOfSize:20];
    sc.selectedFontColor = [UIColor redColor];
    sc.unSelectedFontColor = [UIColor greenColor];
    sc.tintColor = [UIColor clearColor];
    [sc renderView];
//    sc.backgroundColor = [UIColor purpleColor];
    
    XYTableCell* segControl = [[XYTableCell alloc] initWithView:sc];
    [self.tableDelegate.container addXYTableCell:segControl];
    
    NSMutableArray* covers = [NSMutableArray new];
    for (int i = 0; i< 4; i++) {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        v.backgroundColor = [XYUtility randomColor];
        [covers addObject:v];
    }
    
    XYBaseView* bView = [[XYBaseView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    XYPagedView* pagedView = [[XYPagedView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200)/2, 0, 200, 200) covers:covers];
    [bView addSubview:pagedView];
//    pagedView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    XYTableCell* pagedViewCell = [[XYTableCell alloc] initWithView:bView];
    pagedViewCell.selectable = NO;
    pagedViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.tableDelegate.container addXYTableCell:pagedViewCell];
    
    
    NSMutableArray* imageList = [NSMutableArray new];
    for (int i = 0; i< 10; i++) {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        v.backgroundColor = [XYUtility randomColor];
        [imageList addObject:v];
    }
    XYImageListView* imageListView = [[XYImageListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    imageListView.imageList = imageList;
    [imageListView renderView];
    
//    bView = [[XYBaseView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
//    [bView addSubview:imageListView];
    
    XYTableCell* imageListCell = [[XYTableCell alloc] initWithView:imageListView];
    imageListCell.selectable = NO;
    imageListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.tableDelegate.container addXYTableCell:imageListCell];
    
    
    XYTableCell* toTableViewCell1 = [XYTableCellFactory cellOfButton:@"button1" label:@"Test XYBaseVc"];
    [self.tableDelegate.container addXYTableCell:toTableViewCell1];
    
    XYTableCell* toTableViewCell2 = [XYTableCellFactory cellOfClearButton:@"button2" label:@"Test BYBaseTableVc"];
    [self.tableDelegate.container addXYTableCell:toTableViewCell2];
    
    XYTableCell* processBarCell = [XYTableCellFactory cellOfClearButton:@"processBar" label:@"Process bar"];
    [self.tableDelegate.container addXYTableCell:processBarCell];
    
    _processbarView = [[XYActivityIndicatorBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 3)];
    [processBarCell.view addSubview:_processbarView];
    
    XYTableCell* helpCell = [XYTableCellFactory cellOfClearButton:@"help" label:@"Show help"];
    [self.tableDelegate.container addXYTableCell:helpCell];
    
//    XYTableCell* custHelpCell = [XYTableCellFactory cellOfClearButton:@"custHelp" label:@"Show Custimzed help"];
//    [self.tableDelegate.container addXYTableCell:custHelpCell];
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    v.backgroundColor = [UIColor lightGrayColor];
    cv = [[XYActivityIndicatorCircleView alloc] initWithFrame:CGRectMake(20, 10, 100, 100)];
//    cv.backgroundColor = [UIColor redColor];
    [v addSubview:cv];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 120, 200, 20)];
    [btn setTitle:@"Animation" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(circleViewTest) forControlEvents:UIControlEventTouchDown];
    [v addSubview:btn];
    
    XYTableCell* testCell = [[XYTableCell alloc] initWithView:v];
    [self.tableDelegate.container addXYTableCell:testCell];
    
    XYTableCell* toDragViewCell = [XYTableCellFactory cellOfButton:@"toDragView" label:@"Test DragView"];
    [self.tableDelegate.container addXYTableCell:toDragViewCell];
    
    [self.tableView reloadData];
}

-(void)circleViewTest{
    if (cv.isAnimating) {
        [cv stopAnimating];
    } else {
        [cv startAnimating];
    }
}

-(void)doSomething{
    self.busyProcessTitle = @"Please wait";
    [self performBusyProcess:^XYProcessResult *{
        sleep(2);
        return [XYProcessResult success];
    }];
}

-(void)doSomething2{
//    self.busyProcessTitle = @"Please wait";
    
    [self performBusyProcessWithUpdater:^XYProcessResult *(XYUIStatusUpdater *updater) {
//        [updater log:@"Step 1"];
        [updater progress:0.3];
        sleep(1);
//        [updater log:@"Step 2"];
        [updater progress:0.6];
        sleep(1);
//        [updater log:@"Step 3"];
        [updater progress:1];
        sleep(1);
        
        return [XYProcessResult success];
    }];
    
}

-(void)onSelectXYTableCell:(XYTableCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if ([cell.name isEqualToString:@"button1"]) {
        TestXYBaseUIViewController* vc = [TestXYBaseUIViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cell.name isEqualToString:@"button2"]) {
        TestXYBaseUITableViewController* vc = [TestXYBaseUITableViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([cell.name isEqualToString:@"processBar"]) {
        [_processbarView isAnimating] ? [_processbarView stopAnimating] :
        [_processbarView startAnimating];
    } else if ([cell.name isEqualToString:@"help"]) {
        [self showOnScreenHelpView];
    } else if ([cell.name isEqualToString:@"toDragView"]){
        [self toDragView];
    }
}

-(void)toDragView{
    TestDragControlVc* td = [TestDragControlVc new];
    [self.navigationController pushViewController:td animated:YES];
}


-(UIView*)addStatusHelpIndex:(NSUInteger)index onView:(UIView*)view{
    float y = index * 44;
    float x = 0;
    const float txtHeight = 70;
    float diff = 0.0;
    CGPoint cirStart = CGPointMake(25, 60);
    CGSize cirSize = CGSizeMake(15, 15);
    CGPoint lineStart = CGPointMake(31, 75);
    CGSize lineSize = CGSizeMake(2, 85);
    UIEdgeInsets txtViewEdge = UIEdgeInsetsMake(0, 10, 0, 10);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // iPad
        x = 320;
    }
    
    UIView* cir1 = [[UIView alloc] initWithFrame:CGRectMake(cirStart.x+x, cirStart.y + y, cirSize.width, cirSize.height)];
    cir1.backgroundColor = [XYUtility sapBlueColor];
    cir1.layer.cornerRadius = cirSize.width/2.0;
    [view addSubview:cir1];
    
//    UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.view.bounds];
//    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(cirStart.x + 20, cirStart.y -cirSize.height + y, self.view.bounds.size.width -cirStart.x -40, 44) cornerRadius:15] bezierPathByReversingPath]];
//    CAShapeLayer* maskLayer = [CAShapeLayer layer];
//    maskLayer.path = path.CGPath;
//    view.layer.mask = maskLayer;
    
    
    diff = lineStart.y + y + lineSize.height + txtHeight - (view.bounds.size.height - txtHeight);
    CGRect f = CGRectZero;
    if (diff > 0) {
        if (lineSize.height - diff > 0) {
            f = CGRectMake(lineStart.x+x, lineStart.y + y, lineSize.width, lineSize.height - diff);
        } else {
            f = CGRectMake(lineStart.x+x, lineStart.y + y - lineSize.height, lineSize.width, lineSize.height);
        }
        
    } else {
        f = CGRectMake(lineStart.x+x, lineStart.y + y, lineSize.width, lineSize.height);
    }
    
    UIView* line1 = [[UIView alloc] initWithFrame:f];
    line1.backgroundColor = [XYUtility sapBlueColor];
    [view addSubview:line1];
    
    if (diff > 0) {
        if (lineSize.height - diff > 0) {
            f = CGRectMake(txtViewEdge.left+x, line1.frame.origin.y + line1.frame.size.height, view.frame.size.width - txtViewEdge.left - txtViewEdge.right - x, txtHeight);
        } else {
            f = CGRectMake(txtViewEdge.left+x, line1.frame.origin.y - txtHeight, view.frame.size.width - txtViewEdge.left - txtViewEdge.right - x, txtHeight);
        }
    } else {
        f = CGRectMake(txtViewEdge.left+x, line1.frame.origin.y + line1.frame.size.height, view.frame.size.width - txtViewEdge.left - txtViewEdge.right - x, txtHeight);
    }
    
    UITextView* help1 = [[UITextView alloc] initWithFrame:f];
    help1.userInteractionEnabled = NO;
    help1.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    help1.layer.borderColor = [XYUtility sapBlueColor].CGColor;
    help1.layer.borderWidth = 1.0;
    help1.layer.cornerRadius = 5.0;
    switch (index) {
        case 0:{
            help1.text = @"Newly created CIM Escalation Request will be created with status \"New\" (automatically by system)";
        }
            break;
        case 1:{
            help1.text = @"CIM Escalation Request under processing or being followed up by CIM should be set as \"In process\"(by CIM agents)";
        }
            break;
        case 2:{
            help1.text = @"CIM Escalation Request handed over to other CIM shift should be set as \"Handover\"(by CIM agents)";
        }
            break;
        case 3:{
            help1.text = @"Any update to the existing CIM Escalation Request by requester will set its status to \"Action needed\"(automatically by system)";
        }
            break;
        case 4:{
            help1.text = @"CIM Escalation Request with no further follow up from CIM will be set as \"Closed\"(by CIM agents)";
        }
            break;
        case 5:{
            help1.text = @"New items";
        }
            break;
        case 6:{
            help1.text = @"2 items";
        }
            break;
        default:
            break;
    }
    
    help1.font = [UIFont systemFontOfSize:14];
    [view addSubview:help1];
    return view;
}

-(UIView*)returnHelpView{
    UIView* v = [super returnHelpView];
//    v.backgroundColor = [UIColor clearColor];
    
    NSMutableArray* views = [NSMutableArray new];
    for (int i =0; i<7; i++) {
        UIView* c1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, v.frame.size.width, v.frame.size.height-100)];
//        c1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        c1 = [self addStatusHelpIndex:i onView:c1];
        [views addObject:c1];
    }
    
    XYPagedView* pageView = [[XYPagedView alloc] initWithFrame:CGRectMake(0, 70, v.frame.size.width, v.frame.size.height-150) covers:views];
    
    pageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [pageView.pageController setCurrentPageIndicatorTintColor:[XYUtility sapBlueColor]];
    [v addSubview:pageView];
    
    return v;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
