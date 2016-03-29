//
//  XYSelectOptionViewController.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/11/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYSelectOptionViewController.h"

@interface XYSelectOptionViewController ()

@end

@implementation XYSelectOptionViewController
{
    XYSelectionTableCell* _signCell;
    XYSelectionTableCell* _operatorCell;
    XYTableCell* _lowValueCell;
    XYTableCell* _highValueCell;
}
@synthesize signDictionary = _signDictionary;
@synthesize operatorDictionary = _operatorDictionary;
@synthesize lowValueCell = _lowValueCell;
@synthesize highValueCell = _highValueCell;
@synthesize advField = _advField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self loadAdvFieldValue];
    if (self.navigationController != nil) {
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem = backButton;
        UIBarButtonItem* clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearFields)];
        self.navigationItem.rightBarButtonItem = clearButton;
        self.tableView.editing = NO;
        okBtn.visible = NO;
    } else {
        okBtn.visible = YES;
    }
    [self.tableView reloadData];
}

-(void)loadAdvFieldValue{
    XYSelectOptionField* sof =((XYSelectOptionField*)_advField);
    
    NSString* title = ((XYInputTextViewView*)_advField.view).label.text;
    
//    if ([_advField.view isKindOfClass:[XYInputTextFieldView class]]) {
//        title = ((XYInputTextFieldView*)_advField.view).label.text;
//    } else if ([_advField.view isKindOfClass:[XYInputTextViewView class]]) {
//        title = ((XYInputTextViewView*)_advField.view).label.text;
//    }
    
    [XYUtility setTitle:title inNavigationItem:self.navigationItem];
    
    CGFloat ratio = 0.3;
    
    _signDictionary = sof.signDictionary;
    
//    if (_signDictionary == nil) {
//        _signDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Include",@"I",@"Exclude",@"E", nil];
//    }
    
	_signCell = [XYTableCellFactory cellOfSelection:@"sign" label:@"Sign" ratio:ratio dictionaryOptions:_signDictionary];
    _signCell.field.value = @"I";
    [self.tableDelegate.container addXYTableCell:_signCell Level:XYViewLevelWorkArea section:0];
    
//    if (_operatorDictionary == nil) {
//        _operatorDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Between",@"BT",@"Contain",@"CP", @"Equals",@"EQ",@"Greater equal than",@"GE",@"Greater than",@"GT",@"Less equal than",@"LE",@"Less than",@"LT",@"Not between",@"NB",@"Not equal",@"NE",@"Not contain",@"NP",nil];
//    }
    _operatorDictionary = sof.operatorDictionary;
    
    _operatorCell = [XYTableCellFactory cellOfSelection:@"operator" label:@"Operator" ratio:ratio dictionaryOptions:_operatorDictionary];
    _operatorCell.field.value = @"EQ";
    [self.tableDelegate.container addXYTableCell:_operatorCell Level:XYViewLevelWorkArea section:0];
    
    if (_lowValueCell == nil) {
        if (sof.advFieldType == XYAdvFieldTypeDate) {
            _lowValueCell = [XYTableCellFactory cellOfDatePicker:@"lowValue" label:@"Lower val." ratio:ratio mode:sof.datePickMode valueFormat:nil];
        } else {
            _lowValueCell = [XYTableCellFactory cellOfInputField:@"lowValue" label:@"Lower val." ratio:ratio placeHolder:sof.lowValuePlaceholder keyboardType:sof.lowValueKeyboardType];
        }
        
    }
    
    [self.tableDelegate.container addXYTableCell:_lowValueCell Level:XYViewLevelWorkArea section:0];
    
    if (_highValueCell == nil) {
        if (sof.advFieldType == XYAdvFieldTypeDate) {
            _highValueCell = [XYTableCellFactory cellOfDatePicker:@"highValue" label:@"Upper val." ratio:ratio mode:sof.datePickMode valueFormat:nil];
        
        } else {
            _highValueCell = [XYTableCellFactory cellOfInputField:@"highValue" label:@"Upper val." ratio:ratio placeHolder:sof.highValuePlaceholder keyboardType:sof.highValueKeyboardType];
        }
        
    }
    [self.tableDelegate.container addXYTableCell:_highValueCell Level:XYViewLevelWorkArea section:0];
    
    okBtn = [XYTableCellFactory cellOfButton:@"okBtn" label:@"Ok"];
    okBtn.visible = NO;
    [self.tableDelegate.container addXYTableCell:okBtn Level:XYViewLevelWorkArea section:1];
    
    if (sof.fieldSelectionOption.selectOptions != nil && sof.fieldSelectionOption.selectOptions.count > 0) {
        XYSelectOption* so = [[sof.fieldSelectionOption.selectOptions objectEnumerator] nextObject];
        _signCell.field.value = so.sign;
        _operatorCell.field.value = so.option;
        _lowValueCell.field.value = so.lowValue;
        _highValueCell.field.value = so.highValue;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onSelectXYTableCell:(XYTableCell *)field atIndexPath:(NSIndexPath *)indexPath{
    if ([field.name isEqualToString:@"okBtn"]) {
        [self backAction];
    }
}

-(XYSelectOption*)fillSelectOption:(XYAdvFieldType) type{
    XYSelectOption* so = [XYSelectOption new];
    so.sign = _signCell.field.value;
    so.option = _operatorCell.field.value;
    if (type == XYAdvFieldTypeDate) {
        // For date type,
        XYSelectOptionField* sf = (XYSelectOptionField*)self.advField;
        if (![_lowValueCell.field.value isEqualToString:@""]) {
            sf.dateFrom = ((XYDatePickerField*)_lowValueCell.field).date;
        } else {
            sf.dateFrom = nil;
        }
        if (![_highValueCell.field.value isEqualToString:@""]) {
            sf.dateTo = ((XYDatePickerField*)_highValueCell.field).date;
        } else {
            sf.dateTo = nil;
        }
    } 
    so.lowValue = _lowValueCell.field.value;
    so.highValue = _highValueCell.field.value;

    return so;
}

-(void)backAction{
    XYSelectOptionField* sf = (XYSelectOptionField*)self.advField;
    XYSelectOption* so = [self fillSelectOption:sf.advFieldType];
    if (![self validateSelectOption:so]) {
        return;
    }
    [sf.fieldSelectionOption setSingleSelectOption:so];
    [sf renderFieldView];
    if (sf.selectionCompletedSelector != nil) {
        sf.selectionCompletedSelector.object = sf;
        [sf.selectionCompletedSelector performSelector];
    }
    
    UIViewController* v = nil;
    if (self.navigationController != nil) {
        v = [self.navigationController popViewControllerAnimated:YES];
    }
    // If v is nil, no more view avialble in navigation controller, dismiss the view or popover view
    if (v == nil) {
        if  ((self.popOverController != nil && self.popOverController.isPopoverVisible) || self.advField.isPopOverOptionView == YES) {
            [self.popOverController dismissPopoverAnimated:YES];
            return;
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)clearFields{
    _signCell.field.value = @"";
    _operatorCell.field.value = @"";
    _lowValueCell.field.value = @"";
    _highValueCell.field.value = @"";
    [self backAction];
}

-(BOOL)validateSelectOption:(XYSelectOption*)so{
    // Check only for BT option
    if ([so.option isEqualToString:@"EQ"]) {
        // Remove the high value
        so.highValue = @"";
        _highValueCell.field.value = @"";
    }

    if ([so.option isEqualToString:@"BT"]) {
        XYSelectOptionField* sf = (XYSelectOptionField*)self.advField;
        if (sf.advFieldType == XYAdvFieldTypeDate) {
            NSComparisonResult r = [((XYDatePickerField*)_lowValueCell.field).date compare:((XYDatePickerField*)_highValueCell.field).date];
            if (r == NSOrderedDescending) {
                XYUIAlertView* alert = [[XYUIAlertView alloc] initWithTitle:@"Wrong date order" message:@"The upper value of datetime should be later or equal than the lower one" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
        }
    }
    
    return YES;
}
@end
