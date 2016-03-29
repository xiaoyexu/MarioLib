//
//  XYTableCellFactory.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYTableCellFactory.h"

@implementation XYTableCellFactory

+(XYTableCell*)defaultCellOfIdentifier:(NSString*)identifier{
    XYTableCell* tableCell = [[XYTableCell alloc] initWithView:nil];
    tableCell.cellIdentifier = identifier;
    tableCell.customizedCellForRow = NO;
    tableCell.name = @"";
    return tableCell;
}


+(XYTableCell*)cellOfIdentifier:(NSString*)identifier{
    XYTableCell* tableCell = [[XYTableCell alloc] initWithView:nil];
    tableCell.cellIdentifier = identifier;
    tableCell.customizedCellForRow = YES;
    tableCell.name = @"";
    return tableCell;
}

+(XYDummyTableCell*)cellOfDummyIdentifier:(NSString*)identifier{
    XYDummyTableCell* tableCell = [[XYDummyTableCell alloc] initWithView:nil];
    tableCell.cellIdentifier = identifier;
    tableCell.customizedCellForRow = YES;
    tableCell.name = @"";
    return tableCell;
}

//+(XYTableCell*)cellOfInputField:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder keyboardType:(UIKeyboardType)keyboardType layout:(XYFieldViewLayout) layout{
//    CGFloat height;
//    switch (layout) {
//        case XYFieldViewLayoutLabelAtLeftTextAtRight:
//            height = 44;
//            break;
//        case XYFieldViewLayoutLabelAtTopTextAtBottom:
//            height = 88;
//        default:
//            break;
//    }
//    
//    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
//    
//    r = r > 1 ? 1 : r;
//    
//    XYInputTextField* textField = [[XYInputTextField alloc] initWithName:name frame:f label:label ratio:r];
//    
//    ((XYInputTextFieldView*)textField.view).layout = layout;
//    ((XYInputTextFieldView*)textField.view).textField.placeholder = placeHolder;
//    ((XYInputTextFieldView*)textField.view).textField.keyboardType = keyboardType;
//    
//    XYTableCell* tableCell = [[XYTableCell alloc] initWithXYField:textField];
//    tableCell.name = name;
//    
//    if (r == 1) {
//        ((XYInputTextFieldView*)textField.view).rightViewEnabled = NO;
//        ((XYInputTextFieldView*)textField.view).label.textAlignment = UITextAlignmentLeft;
//    } else {
//        
//    }
//    
//    return tableCell;
//}


+(XYTableCell*)cellOfInputField:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder keyboardType:(UIKeyboardType)keyboardType{
//    return [XYTableCellFactory cellOfInputField:name label:label ratio:r placeHolder:placeHolder keyboardType:keyboardType layout:XYFieldViewLayoutLabelAtLeftTextAtRight];
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    
    r = r > 1 ? 1 : r;
    
    XYInputTextField* textField = [[XYInputTextField alloc] initWithName:name frame:f label:label ratio:r];
    
//    ((XYInputTextFieldView*)textField.view).layout = layout;
    ((XYInputTextFieldView*)textField.view).textField.placeholder = placeHolder;
    ((XYInputTextFieldView*)textField.view).textField.keyboardType = keyboardType;
    
    XYTableCell* tableCell = [[XYTableCell alloc] initWithXYField:textField];
    tableCell.name = name;
    
    if (r == 1) {
        ((XYInputTextFieldView*)textField.view).textContainerView = nil;
        ((XYInputTextFieldView*)textField.view).label.textAlignment = NSTextAlignmentLeft;
    } else {
        
    }
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableCell;
}

+(XYTableCell*)cellOfInputField:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder{
    return [XYTableCellFactory cellOfInputField:name label:label ratio:r placeHolder:placeHolder keyboardType:UIKeyboardTypeDefault];
}

// create text field/view cell by ratio
+(XYTableCell*)cellOfInputField:(NSString*)name label:(NSString*)label ratio:(float)r{
    return [XYTableCellFactory cellOfInputField:name label:label ratio:r placeHolder:@""];
}

+(XYTableCell*)cellOfLabel:(NSString*)name label:(NSString*)label ratio:(float)r value:(NSString*) v{
    XYTableCell* cell = [XYTableCellFactory cellOfInputField:name label:label ratio:r];
    cell.editable = NO;
    cell.field.value = v;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+(XYRollableTableCell*)cellOfTextViewField:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder keyboardType:(UIKeyboardType)keyboardType{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
    XYInputTextViewField* textViewField = [[XYInputTextViewField alloc] initWithName:name frame:f label:label ratio:r];
    XYUITextViewDelegate* delegate = [XYUITextViewDelegate new];
    XYRollableTableCell* tableCell = [[XYRollableTableCell alloc] initWithXYField:textViewField];
    tableCell.minHeight = 150;
    tableCell.maxHeight = 230;
    delegate.rollTableCell = tableCell;
    textViewField.textViewDelegate = delegate;
    tableCell.name = name;
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableCell;
}

+(XYRollableTableCell*)cellOfTextViewField:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder keyboardType:(UIKeyboardType)keyboardType minHeight:(CGFloat)min maxHeigh:(CGFloat)max{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, min);
    XYInputTextViewField* textViewField = [[XYInputTextViewField alloc] initWithName:name frame:f label:label ratio:r];
    XYUITextViewDelegate* delegate = [XYUITextViewDelegate new];
    XYRollableTableCell* tableCell = [[XYRollableTableCell alloc] initWithXYField:textViewField];
    tableCell.minHeight = min;
    tableCell.maxHeight = max;
    delegate.rollTableCell = tableCell;
    textViewField.textViewDelegate = delegate;
    tableCell.name = name;
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableCell;
}

+(XYRollableTableCell*)cellOfTextViewFieldUnfixed:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder keyboardType:(UIKeyboardType)keyboardType{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYInputTextViewField* textViewField = [[XYInputTextViewField alloc] initWithName:name frame:f label:label ratio:r];
    ((XYInputTextViewView*)textViewField.view).stickToTextView = YES;
    ((XYInputTextViewView*)textViewField.view).viewAtCenter.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    XYUITextViewDelegate* delegate = [XYUITextViewDelegate new];
    XYRollableTableCell* tableCell = [[XYRollableTableCell alloc] initWithXYField:textViewField];
    tableCell.minHeight = 44;
    tableCell.maxHeight = 9999;
    delegate.rollTableCell = tableCell;
    textViewField.textViewDelegate = delegate;
    tableCell.name = name;
    tableCell.field.editable = NO;
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableCell;
}

+(XYBubbleTableCell*)cellOfBubbleTextView:(NSString*)text fromself:(BOOL)fromself timestamp:(NSDate*)timestamp{
    XYBubbleTableCell* bCell = [XYBubbleTableCell new];
    bCell.text = text;
    bCell.fromself = fromself;
    bCell.timestamp = timestamp;
    bCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return bCell;
}

+(XYTableCell*)cellOfClickableBriefTextView:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder keyboardType:(UIKeyboardType)keyboardType{
    
    XYTableCell* cell = [XYTableCellFactory cellOfTextViewField:name label:label ratio:r placeHolder:placeHolder keyboardType:keyboardType];
    cell.field.editable = NO;
    cell.selectable = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+(XYSelectionTableCell*)cellOfSelection:(NSString*)name label:(NSString*)label ratio:(float)r arrayOptions:(NSArray*) options{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYSelectionField* selField = [[XYSelectionField alloc] initWithName:name frame:f label:label ratio:r singleSelection:YES selectionArray:options selectedIndexPaths:nil];
    XYSelectionTableCell* selCell = [[XYSelectionTableCell alloc] initWithXYField:selField];
    selField.textViewDelegate = [XYUITextViewDelegate new];
    selField.textViewDelegate.rollTableCell = selCell;
    ((XYInputTextViewView*)selField.view).textView.delegate = selField.textViewDelegate;
    ((XYInputTextViewView*)selField.view).stickToTextView = YES;
    selField.minHeight = 44;
    selCell.minHeight = selField.minHeight;
    selCell.name = name;
    selCell.selectable = YES;
    selCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    selCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return selCell;
}

+(XYSelectionTableCell*)cellOfSelection:(NSString*)name label:(NSString*)label ratio:(float)r dictionaryOptions:(NSDictionary*) options{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYSelectionField* selField = [[XYSelectionField alloc] initWithName:name frame:f label:label ratio:r singleSelection:YES selectionDictionary:options selectedIndexPaths:nil];
    XYSelectionTableCell* selCell = [[XYSelectionTableCell alloc] initWithXYField:selField];
    selField.textViewDelegate = [XYUITextViewDelegate new];
    selField.textViewDelegate.rollTableCell = selCell;
    ((XYInputTextViewView*)selField.view).textView.delegate = selField.textViewDelegate;
    ((XYInputTextViewView*)selField.view).stickToTextView = YES;
    selField.minHeight = 44;
    selCell.minHeight = selField.minHeight;
    selCell.name = name;
    selCell.selectable = YES;
    selCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    selCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return selCell;
}

+(XYSelectionTableCell*)cellOfSelection:(NSString *)name label:(NSString *)label ratio:(float)r options:(NSString *)option, ... NS_REQUIRES_NIL_TERMINATION{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    
    NSMutableArray* optionArr = [NSMutableArray new];
    if (option != nil) {
        va_list args;
        va_start(args, option);
        NSString* optionItem;
        XYLabelValue* lv;
        
        lv = [XYLabelValue new];
        lv.label = option;
        int i = 1;
        while((optionItem = va_arg(args,NSString*))){
            if (i % 2 == 0){
                lv = [XYLabelValue new];
                lv.label = optionItem;
            } else {
                lv.value = optionItem;
                [optionArr addObject:lv];
            }
            i++;
        }
        va_end(args);
    }
    
    XYSelectionField* selField = [[XYSelectionField alloc] initWithName:name frame:f label:label ratio:r singleSelection:YES selectionArray:optionArr selectedIndexPaths:nil];
    XYSelectionTableCell* selCell = [[XYSelectionTableCell alloc] initWithXYField:selField];
    selField.textViewDelegate = [XYUITextViewDelegate new];
    selField.textViewDelegate.rollTableCell = selCell;
    ((XYInputTextViewView*)selField.view).textView.delegate = selField.textViewDelegate;
    ((XYInputTextViewView*)selField.view).stickToTextView = YES;
    selField.minHeight = 44;
    selCell.minHeight = selField.minHeight;
    selCell.name = name;
    selCell.selectable = YES;
    selCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    selCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return selCell;
}


+(XYSelectionTableCell*)cellOfSelection:(NSString*)name label:(NSString*)label ratio:(float)r dataSource:(id<XYSelectionFieldDataSource>)dataSource{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);

    XYSelectionField* selField = [[XYSelectionField alloc] initWithName:name frame:f label:label ratio:r];
    selField.isSingleSelection = YES;
    selField.dataSource = dataSource;
    XYSelectionTableCell* selCell = [[XYSelectionTableCell alloc] initWithXYField:selField];
    selField.textViewDelegate = [XYUITextViewDelegate new];
    selField.textViewDelegate.rollTableCell = selCell;
    ((XYInputTextViewView*)selField.view).textView.delegate = selField.textViewDelegate;
    ((XYInputTextViewView*)selField.view).stickToTextView = YES;
    selField.minHeight = 44;
    selCell.minHeight = selField.minHeight;
    selCell.name = name;
    selCell.selectable = YES;
    selCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    selCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return selCell;
}

+(XYSelectionTableCell*)cellOfDynaSearchSelectionField:(NSString*)name label:(NSString*)label ratio:(float)r arrayOptions:(NSArray*) options{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYDynaSearchSelectionField* selDynaField = [[XYDynaSearchSelectionField alloc] initWithName:name frame:f label:label ratio:r];
    selDynaField.placeholder = @"Quick search";
    [selDynaField setSelectionByArray:options];
    XYSelectionTableCell* selAdvCell = [[XYSelectionTableCell alloc] initWithXYField:selDynaField];
    selDynaField.textViewDelegate = [XYUITextViewDelegate new];
    selDynaField.textViewDelegate.rollTableCell = selAdvCell;
    ((XYInputTextViewView*)selDynaField.view).textView.delegate = selDynaField.textViewDelegate;
    ((XYInputTextViewView*)selDynaField.view).stickToTextView = YES;
    selDynaField.editable = NO;
    selDynaField.minHeight = 44;
    selAdvCell.minHeight = selDynaField.minHeight;
    selAdvCell.name = name;
    selAdvCell.selectable = YES;
    selAdvCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    selAdvCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return selAdvCell;
}


+(XYSelectionTableCell*)cellOfDynaSearchSelectionField:(NSString*)name label:(NSString*)label ratio:(float)r dictionaryOptions:(NSDictionary*) options{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYDynaSearchSelectionField* selDynaField = [[XYDynaSearchSelectionField alloc] initWithName:name frame:f label:label ratio:r];
    selDynaField.placeholder = @"Quick search";
    [selDynaField setSelectionByDictionary:options];
    XYSelectionTableCell* selAdvCell = [[XYSelectionTableCell alloc] initWithXYField:selDynaField];
    selDynaField.textViewDelegate = [XYUITextViewDelegate new];
    selDynaField.textViewDelegate.rollTableCell = selAdvCell;
    ((XYInputTextViewView*)selDynaField.view).textView.delegate = selDynaField.textViewDelegate;
    ((XYInputTextViewView*)selDynaField.view).stickToTextView = YES;
    selDynaField.editable = NO;
    selDynaField.minHeight = 44;
    selAdvCell.minHeight = selDynaField.minHeight;
    selAdvCell.name = name;
    selAdvCell.selectable = YES;
    selAdvCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    selAdvCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return selAdvCell;
}


+(XYSelectionTableCell*)cellOfDynaSearchSelectionField:(NSString*)name label:(NSString*)label ratio:(float)r options:(NSString*) option,... NS_REQUIRES_NIL_TERMINATION{
   
    NSMutableArray* optionArr = [NSMutableArray new];
    if (option != nil) {
        va_list args;
        va_start(args, option);
        NSString* optionItem;
        XYLabelValue* lv;
        
        lv = [XYLabelValue new];
        lv.label = option;
        int i = 1;
        while((optionItem = va_arg(args,NSString*))){
            if (i % 2 == 0){
                lv = [XYLabelValue new];
                lv.label = optionItem;
            } else {
                lv.value = optionItem;
                [optionArr addObject:lv];
            }
            i++;
        }
        va_end(args);
    }
    
    return [XYTableCellFactory cellOfDynaSearchSelectionField:name label:label ratio:r arrayOptions:optionArr];
}

+(XYSelectionTableCell*)cellOfAdvancedSearchField:(NSString*)name label:(NSString*)label ratio:(float)r  delegate:(id<XYAdvSearchFieldDelegate>)delegate{
    return [XYTableCellFactory cellOfAdvancedSearchField:name label:label ratio:r placeholder:nil delegate:delegate];
}

+(XYSelectionTableCell*)cellOfAdvancedSearchField:(NSString*)name label:(NSString*)label ratio:(float)r placeholder:(NSString*) placeholder delegate:(id<XYAdvSearchFieldDelegate>)delegate{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYAdvSearchField* XYAdvField = [[XYAdvSearchField alloc] initWithName:name frame:f label:label ratio:r delegate:delegate];
    XYAdvField.placeholder = placeholder;
    XYSelectionTableCell* selAdvCell = [[XYSelectionTableCell alloc] initWithXYField:XYAdvField];
    XYAdvField.textViewDelegate = [XYUITextViewDelegate new];
    XYAdvField.textViewDelegate.rollTableCell = selAdvCell;
    ((XYInputTextViewView*)XYAdvField.view).textView.delegate = XYAdvField.textViewDelegate;
    ((XYInputTextViewView*)XYAdvField.view).stickToTextView = YES;
    XYAdvField.editable = NO;
    XYAdvField.minHeight = 44;
    selAdvCell.minHeight = XYAdvField.minHeight;
    selAdvCell.name = name;
    selAdvCell.selectable = YES;
    selAdvCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    selAdvCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return selAdvCell;
}

+(XYTableCell*)cellOfPicker:(NSString *)name label:(NSString *)label ratio:(float)r options:(NSString *)option, ...{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYPickerField* pickField = [[XYPickerField alloc] initWithName:name frame:f label:label ratio:r];
    
    NSMutableArray* optionArr = [NSMutableArray new];
    if (option != nil) {
        va_list args;
        va_start(args, option);
        NSString* optionItem;
        XYLabelValue* lv;
        
        lv = [XYLabelValue new];
        lv.label = option;
        int i = 1;
        while((optionItem = va_arg(args,NSString*))){
            if (i % 2 == 0){
                lv = [XYLabelValue new];
                lv.label = optionItem;
            } else {
                lv.value = optionItem;
                [optionArr addObject:lv];
            }
            i++;
        }
        va_end(args);
    }
    pickField.pickList = optionArr;
    XYTableCell* tableFeild = [[XYTableCell alloc] initWithXYField:pickField];
    tableFeild.name = name;
    tableFeild.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableFeild;
}


+(XYTableCell*)cellOfDatePicker:(NSString*)name label:(NSString*)label ratio:(float)r{
    return [XYTableCellFactory cellOfDatePicker:name label:label ratio:r mode:UIDatePickerModeDate valueFormat:nil];
}

+(XYTableCell*)cellOfDatePicker:(NSString*)name label:(NSString*)label ratio:(float)r mode:(UIDatePickerMode)m{
    return [XYTableCellFactory cellOfDatePicker:name label:label ratio:r mode:m valueFormat:nil];
}

+(XYTableCell*)cellOfDatePicker:(NSString*)name label:(NSString*)label ratio:(float)r mode:(UIDatePickerMode)m valueFormat:(NSString*)format{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYDatePickerField* dateField = [[XYDatePickerField alloc] initWithName:name frame:f label:label ratio:r];
    dateField.datePickerMode = m;
    dateField.valueDateFormat = format;
    XYTableCell* tableFeild = [[XYTableCell alloc] initWithXYField:dateField];
    tableFeild.name = name;
    tableFeild.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableFeild;
}

+(XYButtonTableCell*)cellOfButton:(NSString*)name label:(NSString*) label{
    XYButtonTableCell* btn = [XYButtonTableCell cellWithName:name view:nil];
    btn.text = label;
    btn.height = 44;
    btn.editable = NO;
    ((UILabel*)btn.view).textColor = [XYSkinManager instance].xyButtonTableCellTextColor;
    btn.backgroundColor = [XYSkinManager instance].xyButtonTableCellBackgroundColor;
    return btn;
}

+(XYButtonTableCell*)cellOfClearButton:(NSString*)name label:(NSString*) label{
    XYButtonTableCell* btn = [XYTableCellFactory cellOfButton:name label:label];
    ((UILabel*)btn.view).textColor = [XYSkinManager instance].xyClearButtonTableCellTextColor;
    btn.backgroundColor = [XYSkinManager instance].xyClearButtonTableCellBackgroundColor;
    return btn;
}

+(XYExpandableTableCell*)cellOfExpandableView:(UIView*) v name:(NSString*) name minHeight:(NSUInteger) min maxHeight:(NSUInteger) max{
    XYExpandableTableCell* tableCell = [[XYExpandableTableCell alloc] initWithView:v];
    tableCell.name = name;
    tableCell.minHeight = min;
    tableCell.maxHeight = max;
    return tableCell;
}

+(XYSelectionTableCell*)cellOfSelectOptionField:(NSString*)name label:(NSString*)label ratio:(float)r{
    return [XYTableCellFactory cellOfSelectOptionField:name label:label ratio:r lowValuePlaceHolder:@"" lowValueKeyboardType:UIKeyboardTypeDefault highValuePlaceHolder:@"" highValueKeyboardType:UIKeyboardTypeDefault signDict:nil optionDict:nil];
}

+(XYSelectionTableCell*)cellOfSelectOptionField:(NSString*)name label:(NSString*)label ratio:(float)r lowValuePlaceHolder:(NSString*)lplaceHolder lowValueKeyboardType:(UIKeyboardType)lkeyboardType highValuePlaceHolder:(NSString*)hplaceHolder highValueKeyboardType:(UIKeyboardType)hkeyboardType signDict:(NSDictionary*)signDict optionDict:(NSDictionary*)optionDict{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYSelectOptionField* selOptField = [[XYSelectOptionField alloc] initWithName:name frame:f label:label ratio:r];
    if (signDict != nil) {
        selOptField.signDictionary = signDict;
    } else {
        // Default sign
        selOptField.signDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Include",@"I",@"Exclude",@"E", nil];
    }
    
    if (optionDict != nil) {
        selOptField.operatorDictionary = optionDict;
    } else {
        // Default option
        selOptField.operatorDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Between",@"BT",@"Contain",@"CP", @"Equals",@"EQ",@"Greater equal than",@"GE",@"Greater than",@"GT",@"Less equal than",@"LE",@"Less than",@"LT",@"Not between",@"NB",@"Not equal",@"NE",@"Not contain",@"NP",nil];
    }
    
    selOptField.lowValuePlaceholder = lplaceHolder;
    selOptField.lowValueKeyboardType = lkeyboardType;
    selOptField.highValuePlaceholder = hplaceHolder;
    selOptField.highValueKeyboardType = hkeyboardType;
    XYSelectionTableCell* selOptCell = [[XYSelectionTableCell alloc] initWithXYField:selOptField];
    selOptField.textViewDelegate = [XYUITextViewDelegate new];
    selOptField.textViewDelegate.rollTableCell = selOptCell;
    ((XYInputTextViewView*)selOptField.view).textView.delegate = selOptField.textViewDelegate;
    ((XYInputTextViewView*)selOptField.view).stickToTextView = YES;
    selOptField.editable = NO;
    selOptField.minHeight = 44;
    selOptCell.minHeight = selOptField.minHeight;
    selOptCell.name = name;
    selOptCell.selectable = YES;
    selOptCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return selOptCell;

}

+(XYSelectionTableCell*)cellOfSelectOptionDateField:(NSString*)name label:(NSString*)label ratio:(float)r mode:(UIDatePickerMode)m dateValueFormat:(NSString*) dvf signDict:(NSDictionary*)signDict optionDict:(NSDictionary*)optionDict{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYSelectOptionField* selOptField = [[XYSelectOptionField alloc] initWithName:name frame:f label:label ratio:r];
   
    if (signDict != nil) {
        selOptField.signDictionary = signDict;
    } else {
        // Default sign
        selOptField.signDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Include",@"I",@"Exclude",@"E", nil];
        
    }
    if (optionDict != nil) {
        selOptField.operatorDictionary = optionDict;
    } else {
        // Default option
        selOptField.operatorDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Between",@"BT", @"Equals",@"EQ",@"Greater equal than",@"GE",@"Greater than",@"GT",@"Less equal than",@"LE",@"Less than",@"LT",@"Not between",@"NB",@"Not equal",@"NE",nil];
    }
    selOptField.dateValueFormat = dvf;
    XYSelectionTableCell* selOptCell = [[XYSelectionTableCell alloc] initWithXYField:selOptField];
    selOptField.textViewDelegate = [XYUITextViewDelegate new];
    selOptField.textViewDelegate.rollTableCell = selOptCell;
    ((XYInputTextViewView*)selOptField.view).textView.delegate = selOptField.textViewDelegate;
    ((XYInputTextViewView*)selOptField.view).stickToTextView = YES;
    selOptField.editable = NO;
    selOptField.minHeight = 44;
    selOptField.advFieldType = XYAdvFieldTypeDate;
    selOptField.datePickMode = m;
    selOptCell.minHeight = selOptField.minHeight;
    selOptCell.name = name;
    selOptCell.selectable = YES;
    selOptCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return selOptCell;
}

+(XYSelectionTableCell*)cellOfDynaSearchField:(NSString*)name label:(NSString*)label ratio:(float)r delegate:(id<XYDynaSearchFieldDelegate>) delegate{
    return [XYTableCellFactory cellOfDynaSearchField:name label:label ratio:r placeholder:@"" delegate:delegate];
}

+(XYSelectionTableCell*)cellOfDynaSearchField:(NSString*)name label:(NSString*)label ratio:(float)r placeholder:(NSString*) placeholder delegate:(id<XYDynaSearchFieldDelegate>) delegate{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYDynaSearchField* selDynaField = [[XYDynaSearchField alloc] initWithName:name frame:f label:label ratio:r delegate:delegate];
    selDynaField.placeholder = placeholder;
    XYSelectionTableCell* selAdvCell = [[XYSelectionTableCell alloc] initWithXYField:selDynaField];
    selDynaField.textViewDelegate = [XYUITextViewDelegate new];
    selDynaField.textViewDelegate.rollTableCell = selAdvCell;
    ((XYInputTextViewView*)selDynaField.view).textView.delegate = selDynaField.textViewDelegate;
    ((XYInputTextViewView*)selDynaField.view).stickToTextView = YES;
    selDynaField.editable = NO;
    selDynaField.minHeight = 44;
    selAdvCell.minHeight = selDynaField.minHeight;
    selAdvCell.name = name;
    selAdvCell.selectable = YES;
    selAdvCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return selAdvCell;

}


//

// A advance field that provide operator selection
+(XYValueHelpTableCell*)cellOfValueHelpField:(NSString*)name label:(NSString*)label ratio:(float)r{
    return [XYTableCellFactory cellOfValueHelpField:name label:label ratio:r lowValuePlaceHolder:@"" lowValueKeyboardType:UIKeyboardTypeDefault highValuePlaceHolder:@"" highValueKeyboardType:UIKeyboardTypeDefault signDict:nil optionDict:nil];
}

// A advance field that provide operator selection
+(XYValueHelpTableCell*)cellOfValueHelpField:(NSString*)name label:(NSString*)label ratio:(float)r lowValuePlaceHolder:(NSString*)lplaceHolder lowValueKeyboardType:(UIKeyboardType)lkeyboardType highValuePlaceHolder:(NSString*)hplaceHolder highValueKeyboardType:(UIKeyboardType)hkeyboardType signDict:(NSDictionary*)signDict optionDict:(NSDictionary*)optionDict{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYSelectOptionField* selOptField = [[XYSelectOptionField alloc] initWithName:name frame:f label:label ratio:r];
    if (signDict != nil) {
        selOptField.signDictionary = signDict;
    } else {
        // Default sign
        selOptField.signDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Include",@"I",@"Exclude",@"E", nil];
    }
    
    if (optionDict != nil) {
        selOptField.operatorDictionary = optionDict;
    } else {
        // Default option
        selOptField.operatorDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Between",@"BT",@"Contain",@"CP", @"Equals",@"EQ",@"Greater equal than",@"GE",@"Greater than",@"GT",@"Less equal than",@"LE",@"Less than",@"LT",@"Not between",@"NB",@"Not equal",@"NE",@"Not contain",@"NP",nil];
    }
    
    selOptField.lowValuePlaceholder = lplaceHolder;
    selOptField.lowValueKeyboardType = lkeyboardType;
    selOptField.highValuePlaceholder = hplaceHolder;
    selOptField.highValueKeyboardType = hkeyboardType;
    XYValueHelpTableCell* selOptCell = [[XYValueHelpTableCell alloc] initWithXYField:selOptField];
    selOptField.textViewDelegate = [XYUITextViewDelegate new];
    selOptField.textViewDelegate.rollTableCell = selOptCell;
    ((XYInputTextViewView*)selOptField.view).textView.delegate = selOptField.textViewDelegate;
    ((XYInputTextViewView*)selOptField.view).stickToTextView = YES;
    selOptField.editable = YES;
    ((XYInputTextViewView*)selOptField.view).userInteractionEnabled = YES;
    selOptField.minHeight = 44;
    selOptCell.minHeight = selOptField.minHeight;
    selOptCell.name = name;
    selOptCell.selectable = NO;
    selOptCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return selOptCell;
}

// A advance field that provide operator selection
+(XYValueHelpTableCell*)cellOfValueHelpDateField:(NSString*)name label:(NSString*)label ratio:(float)r mode:(UIDatePickerMode)m dateValueFormat:(NSString*) dvf signDict:(NSDictionary*)signDict optionDict:(NSDictionary*)optionDict{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYSelectOptionField* selOptField = [[XYSelectOptionField alloc] initWithName:name frame:f label:label ratio:r];
    
    if (signDict != nil) {
        selOptField.signDictionary = signDict;
    } else {
        // Default sign
        selOptField.signDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Include",@"I",@"Exclude",@"E", nil];
        
    }
    if (optionDict != nil) {
        selOptField.operatorDictionary = optionDict;
    } else {
        // Default option
        selOptField.operatorDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Between",@"BT", @"Equals",@"EQ",@"Greater equal than",@"GE",@"Greater than",@"GT",@"Less equal than",@"LE",@"Less than",@"LT",@"Not between",@"NB",@"Not equal",@"NE",nil];
    }
    selOptField.dateValueFormat = dvf;
    XYValueHelpTableCell* selOptCell = [[XYValueHelpTableCell alloc] initWithXYField:selOptField];
    selOptField.textViewDelegate = [XYUITextViewDelegate new];
    selOptField.textViewDelegate.rollTableCell = selOptCell;
    ((XYInputTextViewView*)selOptField.view).textView.delegate = selOptField.textViewDelegate;
    ((XYInputTextViewView*)selOptField.view).stickToTextView = YES;
    selOptField.editable = YES;
    ((XYInputTextViewView*)selOptField.view).userInteractionEnabled = YES;
    selOptField.minHeight = 44;
    selOptField.advFieldType = XYAdvFieldTypeDate;
    selOptField.datePickMode = m;
    selOptCell.minHeight = selOptField.minHeight;
    selOptCell.name = name;
    selOptCell.selectable = NO;
    selOptCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return selOptCell;
}

// A dynamic search field
+(XYValueHelpTableCell*)cellOfVHDynaSearchField:(NSString*)name label:(NSString*)label ratio:(float)r delegate:(id<XYDynaSearchFieldDelegate>) delegate{
    return [XYTableCellFactory cellOfVHDynaSearchField:name label:label ratio:r delegate:delegate singleLine:NO];
}

+(XYValueHelpTableCell*)cellOfVHDynaSearchField:(NSString*)name label:(NSString*)label ratio:(float)r delegate:(id<XYDynaSearchFieldDelegate>) delegate singleLine:(BOOL)sl{
    CGRect f = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    XYDynaSearchField* selDynaField = [[XYDynaSearchField alloc] initWithName:name frame:f label:label ratio:r delegate:delegate];
    XYValueHelpTableCell* selAdvCell = [[XYValueHelpTableCell alloc] initWithXYField:selDynaField];
    selDynaField.textViewDelegate = [XYUITextViewDelegate new];
    selDynaField.textViewDelegate.noLineBreaker = sl;
    selDynaField.textViewDelegate.rollTableCell = selAdvCell;
    ((XYInputTextViewView*)selDynaField.view).textView.delegate = selDynaField.textViewDelegate;
    ((XYInputTextViewView*)selDynaField.view).stickToTextView = YES;
    selDynaField.editable = YES;
    ((XYInputTextViewView*)selDynaField.view).userInteractionEnabled = YES;
    selDynaField.minHeight = 44;
    selAdvCell.minHeight = selDynaField.minHeight;
    selAdvCell.name = name;
    selAdvCell.selectable = NO;
    selAdvCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return selAdvCell;
}
@end
