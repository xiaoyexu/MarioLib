//
//  XYSelectionField.m
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYSelectionField.h"

@implementation XYSelectionField
{
    UIViewController* vc;
    XYSelectionListViewController* pvc;
    UIPopoverController* pc;
}
@synthesize isSingleSelection = _isSingleSelection;
@synthesize selection = _selection;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize textViewDelegate = _textViewDelegate;
@synthesize popOverTextViewDelegate = _popOvertextViewDelegate;
@synthesize minHeight = _minHeight;
@synthesize maxHeight = _maxHeight;
@synthesize selectionItemDeletable = _selectionItemDeletable;
@synthesize selectionItemDeletedSelector = _selectionItemDeletedSelector;
@synthesize dataSource = _dataSource;

-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r{
    if (self = [super init]) {
        XYInputTextViewView* view = [[XYInputTextViewView alloc] initWithFrame:f andRatio:r];
        _minHeight = view.textView.frame.size.height;
        view.label.text = label;
        _view = view;
        _name = name;
        _selectedIndexPath = [NSMutableSet new];
        [self setPopOverOptionView:NO];
    }
    return self;
}



-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString*) label ratio:(float) r singleSelection:(BOOL)singleSelection selectionArray:(NSArray*) selection selectedIndexPaths:(NSSet*) indexSet{
    if (self = [super init]) {
        XYInputTextViewView* view = [[XYInputTextViewView alloc] initWithFrame:f andRatio:r];
        _minHeight = view.textView.frame.size.height;
        view.label.text = label;
        _view = view;
        _name = name;
        [self setPopOverOptionView:NO];
        _selectedIndexPath = [NSMutableSet setWithSet:indexSet];
        _isSingleSelection = singleSelection;
        // wrap option to XYSelectionItemField
        [self setSelectionByArray:selection];
    }
    return self;
}

-(id)initWithName:(NSString *)name frame:(CGRect)f label:(NSString *)label ratio:(float)r singleSelection:(BOOL)singleSelection selectionDictionary:(NSDictionary *)selection selectedIndexPaths:(NSSet*) indexSet{
    if (self = [super init]) {
        XYInputTextViewView* view = [[XYInputTextViewView alloc] initWithFrame:f andRatio:r];
        _minHeight = view.textView.frame.size.height;
        view.label.text = label;
        _view = view;
        _name = name;
        [self setPopOverOptionView:NO];
        _selectedIndexPath = [NSMutableSet setWithSet:indexSet];
        _isSingleSelection = singleSelection;
        [self setSelectionByDictionary:selection];
    }
    return self;
}

-(void)renderField{
    
}

-(XYInputTextViewView*)view{
    return (XYInputTextViewView*)_view;
}

-(void)setValue:(NSString *)value{
    _value = value;
    // When set the value, find related index number and add to _selectedIndexPath
    if (_selectedIndexPath == nil) {
        _selectedIndexPath = [NSMutableSet new];
    }
    
    // Get the latest selection
    NSArray* selection = self.selection;
    
    if (self.isSingleSelection) {
        [_selectedIndexPath removeAllObjects];
        for (XYSelectionItemField* sif in selection) {
            if ([sif.name isEqualToString:_value]) {
                [_selectedIndexPath addObject:[NSIndexPath indexPathForRow:[selection indexOfObject:sif] inSection:0]];
            }
        }
    } else {
        NSArray* selectedValueList = [_value componentsSeparatedByString:@"#"];
        for (NSString* selectedValue in selectedValueList) {
            for (XYSelectionItemField* sif in selection) {
                if ([sif.name isEqualToString:selectedValue]) {
                    [_selectedIndexPath addObject:[NSIndexPath indexPathForRow:[selection indexOfObject:sif] inSection:0]];
                }
            }
        }
    }
    [self renderFieldView];
}

-(NSString*)value{
    return _value;
    //return [self selectedStringValue];
}

-(void)clearValue{
    _selectedIndexPath = [NSMutableSet new];
    [self renderFieldView];
}

-(void)resignFirstResponder{
    [((XYInputTextViewView*)_view).textView resignFirstResponder];
}

-(void)renderFieldView{
    // Concatenating text selected
    NSString* displayText = @"";
    NSString* displayValue = @"";
    
    XYSelectionItemField* sif;
    
    NSInteger countOfSelectedOption = _selectedIndexPath.count;
    NSInteger* currentRow = 0;
    
    NSArray* selection = _selection;
    
    if (selection != nil && selection.count != 0) {
        for (NSIndexPath* index in _selectedIndexPath) {
            @try {
                sif = [selection objectAtIndex:index.row];
            }
            @catch (NSException *exception) {
                XYUIAlertView* alert = [[XYUIAlertView alloc] initWithTitle:@"Error" message:@"The item you selected is not available now" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                continue;
            }
            if (currentRow > 0) {
                displayText = [NSString stringWithFormat:@"%@\n%@",displayText,sif.value];
                displayValue = [NSString stringWithFormat:@"%@#%@",displayValue,sif.name];
            } else {
                displayText = sif.value;
                displayValue = sif.name;
            }
            currentRow++;
        }
    }
    
        //set value & text
    _value = displayValue;
    ((XYInputTextViewView*)_view).textView.text = displayText;
    
    // Adjust textview to display all item
    CGRect newFrame = self.view.frame;
    CGSize contentSize =
    ((XYInputTextViewView*)self.view).textView.contentSize;

    if (countOfSelectedOption > 0 && contentSize.height > newFrame.size.height) {
        newFrame.size.height = contentSize.height + _view.viewAtBottom.bounds.size.height;
    } else {
        newFrame.size.height = _minHeight;
    }
    [((XYInputTextViewView*)self.view) setFrame:newFrame];
}

-(void)setSelected:(NSIndexPath *)indexPath, ...{
    [self selection];
    self.selectedIndexPath = [NSMutableSet new];
    if (indexPath != nil) {
        [self.selectedIndexPath addObject:indexPath];
        va_list args;
        va_start(args, indexPath);
        NSIndexPath* indexPathItem;
        while((indexPathItem = va_arg(args,NSIndexPath*))){
            [self.selectedIndexPath addObject:indexPathItem];
        }
        va_end(args);
    }
    [self renderFieldView];
}

-(void)unsetSelected:(NSIndexPath *)indexPath, ...{
    [self selection];
    if (self.selectedIndexPath == nil || self.selectedIndexPath.count == 0) {
        return;
    }
    if (indexPath != nil) {
        [self.selectedIndexPath removeObject:indexPath];
        va_list args;
        va_start(args, indexPath);
        NSIndexPath* indexPathItem;
        while((indexPathItem = va_arg(args,NSIndexPath*))){
            [self.selectedIndexPath removeObject:indexPathItem];
        }
        va_end(args);
    }
    [self renderFieldView];
}

-(UIViewController*)advFieldViewController{
    
    XYTableContainer* container = [XYTableContainer new];
    NSMutableArray* selectionItemCellArray = [NSMutableArray new];
    for (XYSelectionItemField* field in self.selection) {
        XYSelectionItemTableCell* sitc = [[XYSelectionItemTableCell alloc] initWithXYField:field];
        sitc.text = field.value;
        if (_selectionItemDeletable) {
            sitc.editable = YES;
        }
        [selectionItemCellArray addObject:sitc];
    }
    
    [container addXYTableCellArray:selectionItemCellArray];
    
    XYSelectionListViewController* listViewController = [[XYSelectionListViewController alloc] initWithStyle:UITableViewStyleGrouped andTableContainer:container xyStyle:XYUITableViewStyleOptionList cellStyle:UITableViewCellStyleDefault andTitle:@"Please Select..."];
    if (_selectionItemDeletable) {
        listViewController.tableDelegate.enableSwipeToDelete = YES;
    }
    
    listViewController.advField = self;
    return listViewController;
}

-(void)setSelectionByArray:(NSArray*)selectionArray{
    NSMutableArray* innerOptions = [NSMutableArray new];
    XYSelectionItemField* selectionItemField;
    NSString* key;
    NSString* value;
    for (id obj in selectionArray) {
        if ([obj isKindOfClass:[XYSelectionItemField class]]) {
            [innerOptions addObject:obj];
            continue;
        }
        
        if ([obj isKindOfClass:[XYLabelValue class]]) {
            value = ((XYLabelValue*)obj).label;
            key = ((XYLabelValue*)obj).value;
        } else {
            value = [obj description];
            key = [obj description];
        }
        // name of field is key
        // value of field is text to displaye
        selectionItemField = [[XYSelectionItemField alloc] initWithName:key];
        selectionItemField.value = value;
        [innerOptions addObject:selectionItemField];
    }
    _selection = innerOptions;
}
-(void)setSelectionByDictionary:(NSDictionary*)selectionDictionary{
    // wrap option to XYSelectionItemField
    NSMutableArray* innerOptions = [NSMutableArray new];

    [selectionDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString* k = key;
        NSString* v = obj;
        XYSelectionItemField* selectionItemField = [[XYSelectionItemField alloc] initWithName:k];
        selectionItemField.value = v;
        [innerOptions addObject:selectionItemField];
    }];

    _selection = innerOptions;
}

// Add selector for item deleted
-(void)addSelectionDeletedTarget:(id)target action:(SEL) selector{
    _selectionItemDeletedSelector = [[XYSelectorObject alloc] initWithSEL:selector target:target];
}

/**
 A tracky issue here, use _selection in other method within this class except for setValue.
 This is because if dataSource protocol is provided, between 2 self.selection call, the data size may differs, E.g. return 6 for first time and 5 for the second and result in error in renderFieldView method.
 For setValue method, refresh the _selection before setting.
 */

-(NSArray*)selection{
    if (self.dataSource == nil) {
        // If no data source, return _selection
        return _selection;
    } else {
        // If data source protocol is found, used data returned by protocol
        NSMutableArray* innerOptions = [NSMutableArray new];
        XYSelectionItemField* selectionItemField;
        NSString* key;
        NSString* value;
        
        NSArray* selectionArray = [self.dataSource dataSourceOfXYSelectionField:self];
        
        for (id obj in selectionArray) {
            if ([obj isKindOfClass:[XYSelectionItemField class]]) {
                [innerOptions addObject:obj];
                continue;
            }
            
            if ([obj isKindOfClass:[XYLabelValue class]]) {
                value = ((XYLabelValue*)obj).label;
                key = ((XYLabelValue*)obj).value;
            } else {
                value = [obj description];
                key = [obj description];
            }
            // name of field is key
            // value of field is text to displaye
            selectionItemField = [[XYSelectionItemField alloc] initWithName:key];
            selectionItemField.value = value;
            [innerOptions addObject:selectionItemField];
        }
        _selection = innerOptions;
        return innerOptions;
    }
}
@end

