//
//  XYTableCellFactory.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYInputTextField.h"
#import "XYInputTextViewField.h"
#import "XYSelectionField.h"
#import "XYSelectionTableCell.h"
#import "XYRollableTableCell.h"
#import "XYDatePickerField.h"
#import "XYButtonTableCell.h"
#import "XYDummyTableCell.h"
#import "XYSelectOptionField.h"
#import "XYDynaSearchField.h"
#import "XYDynaSearchFieldDelegate.h"
#import "XYValueHelpTableCell.h"
#import "XYPickerField.h"
#import "XYSelectionFieldDataSource.h"
#import "XYSkinManager.h"
#import "XYDynaSearchSelectionField.h"
#import "XYAdvSearchField.h"
#import "XYAdvSearchFieldDelegate.h"

/**
 This class is used for creating XYTableCells
 All methods are static
 */
@interface XYTableCellFactory : NSObject

/**
 Create a XYTableCell by cell identifier without customized cell
 */
+(XYTableCell*)defaultCellOfIdentifier:(NSString*)identifier;

/**
 Create a XYTableCell by cell identifier with customized cell
 */
+(XYTableCell*)cellOfIdentifier:(NSString*)identifier;

/**
 Create a Special XYDummyTableCell by cell identifier with customized cell
 */
+(XYDummyTableCell*)cellOfDummyIdentifier:(NSString*)identifier;

//+(XYTableCell*)cellOfInputField:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder keyboardType:(UIKeyboardType)keyboardType layout:(XYFieldViewLayout) layout;

/**
 Create text field/view cell by ratio
 */
+(XYTableCell*)cellOfInputField:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder keyboardType:(UIKeyboardType)keyboardType;

/**
 Create text field/view cell by ratio
 */
+(XYTableCell*)cellOfInputField:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder;

/**
 Create text field/view cell by ratio
 */
+(XYTableCell*)cellOfInputField:(NSString*)name label:(NSString*)label ratio:(float)r;

/**
  Create a label field, it is a readonly XYInputTextField
 */
+(XYTableCell*)cellOfLabel:(NSString*)name label:(NSString*)label ratio:(float)r value:(NSString*) v;


/**
 Create a normal text view field
 */
+(XYRollableTableCell*)cellOfTextViewField:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder keyboardType:(UIKeyboardType)keyboardType;

/**
 Create anormal text view field with min height, max height
 */
+(XYRollableTableCell*)cellOfTextViewField:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder keyboardType:(UIKeyboardType)keyboardType minHeight:(CGFloat)min maxHeigh:(CGFloat)max;

/**
  Create a readonly text view field, the height of field will be automatcally adjusted based on content of value
*/
+(XYRollableTableCell*)cellOfTextViewFieldUnfixed:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder keyboardType:(UIKeyboardType)keyboardType;

/**
  Create a Bubble cell
 */
+(XYBubbleTableCell*)cellOfBubbleTextView:(NSString*)text fromself:(BOOL)fromself timestamp:(NSDate*)timestamp;


/** 
 Create a text view field, none-editable, selectable, with a arrow point to the right side
 */
+(XYTableCell*)cellOfClickableBriefTextView:(NSString*)name label:(NSString*)label ratio:(float)r placeHolder:(NSString*)placeHolder keyboardType:(UIKeyboardType)keyboardType;

/**
 Create a picker field
 */
+(XYTableCell*)cellOfPicker:(NSString*)name label:(NSString*)label ratio:(float)r options:(NSString*)option, ...;

/**
 Create a date picker - date only
 */
+(XYTableCell*)cellOfDatePicker:(NSString*)name label:(NSString*)label ratio:(float)r;

/**
 Create a date picker with mode option
 */
+(XYTableCell*)cellOfDatePicker:(NSString*)name label:(NSString*)label ratio:(float)r mode:(UIDatePickerMode)m;

/**
 Create a date picker with mode option and value formatter
 */
+(XYTableCell*)cellOfDatePicker:(NSString*)name label:(NSString*)label ratio:(float)r mode:(UIDatePickerMode)m valueFormat:(NSString*)format;

/**
 Create a selection field with NSArray as options
 */
+(XYSelectionTableCell*)cellOfSelection:(NSString*)name label:(NSString*)label ratio:(float)r arrayOptions:(NSArray*) options;

/**
 Create a selection field with NSDictionary as options
 */
+(XYSelectionTableCell*)cellOfSelection:(NSString*)name label:(NSString*)label ratio:(float)r dictionaryOptions:(NSDictionary*) options;

/**
 Create a selection field with list options
 */
+(XYSelectionTableCell*)cellOfSelection:(NSString*)name label:(NSString*)label ratio:(float)r options:(NSString*) option,... NS_REQUIRES_NIL_TERMINATION;

/**
 Create a selection field by datasource delegate
 */
+(XYSelectionTableCell*)cellOfSelection:(NSString*)name label:(NSString*)label ratio:(float)r dataSource:(id<XYSelectionFieldDataSource>)dataSource;

/**
 Create a search selection field with NSArray as options
 */
+(XYSelectionTableCell*)cellOfDynaSearchSelectionField:(NSString*)name label:(NSString*)label ratio:(float)r arrayOptions:(NSArray*) options;

/**
 Create a search selection field with NSDictionary as options
 */
+(XYSelectionTableCell*)cellOfDynaSearchSelectionField:(NSString*)name label:(NSString*)label ratio:(float)r dictionaryOptions:(NSDictionary*) options;

/**
 Create a search selection field with list options
 @param option label and value pair
 */
+(XYSelectionTableCell*)cellOfDynaSearchSelectionField:(NSString*)name label:(NSString*)label ratio:(float)r options:(NSString*) option,... NS_REQUIRES_NIL_TERMINATION;


/**
 Create an advanced search field, with quick search bar and search fields
 */
+(XYSelectionTableCell*)cellOfAdvancedSearchField:(NSString*)name label:(NSString*)label ratio:(float)r  delegate:(id<XYAdvSearchFieldDelegate>)delegate;

/**
 Create an advanced search field, with quick search bar and search fields
 */
+(XYSelectionTableCell*)cellOfAdvancedSearchField:(NSString*)name label:(NSString*)label ratio:(float)r placeholder:(NSString*) placeholder delegate:(id<XYAdvSearchFieldDelegate>)delegate;
/**
 Create a button cell, golden text color and darkgray cell background
 */
+(XYButtonTableCell*)cellOfButton:(NSString*)name label:(NSString*) label;

/**
 Create a clear button cell, default black text color and gray background color same as normal XYTableCell
 Color controlled by XYSkinManager
 */
+(XYButtonTableCell*)cellOfClearButton:(NSString*)name label:(NSString*) label;

/**
 Create a table cell can be expanded
 */
+(XYExpandableTableCell*)cellOfExpandableView:(UIView*) v name:(NSString*) name minHeight:(NSUInteger) min maxHeight:(NSUInteger) max;

/**
 Create a  advance field that provide operator selection
 */
+(XYSelectionTableCell*)cellOfSelectOptionField:(NSString*)name label:(NSString*)label ratio:(float)r;

/**
 Create a advance field that provide operator selection
 */
+(XYSelectionTableCell*)cellOfSelectOptionField:(NSString*)name label:(NSString*)label ratio:(float)r lowValuePlaceHolder:(NSString*)lplaceHolder lowValueKeyboardType:(UIKeyboardType)lkeyboardType highValuePlaceHolder:(NSString*)hplaceHolder highValueKeyboardType:(UIKeyboardType)hkeyboardType signDict:(NSDictionary*)signDict optionDict:(NSDictionary*)optionDict;

/**
 Create a advance field that provide operator selection
 */
+(XYSelectionTableCell*)cellOfSelectOptionDateField:(NSString*)name label:(NSString*)label ratio:(float)r mode:(UIDatePickerMode)m dateValueFormat:(NSString*) dvf signDict:(NSDictionary*)signDict optionDict:(NSDictionary*)optionDict;

/**
 Create a dynamic search field
 */
+(XYSelectionTableCell*)cellOfDynaSearchField:(NSString*)name label:(NSString*)label ratio:(float)r delegate:(id<XYDynaSearchFieldDelegate>) delegate;

/**
 Create a dynamic search field with placeholder for search bar
 */
+(XYSelectionTableCell*)cellOfDynaSearchField:(NSString*)name label:(NSString*)label ratio:(float)r placeholder:(NSString*) placeholder delegate:(id<XYDynaSearchFieldDelegate>) delegate;

//// TBD

//// A advance field that provide operator selection
//+(XYValueHelpTableCell*)cellOfValueHelpField:(NSString*)name label:(NSString*)label ratio:(float)r;
//
//// A advance field that provide operator selection
//+(XYValueHelpTableCell*)cellOfValueHelpField:(NSString*)name label:(NSString*)label ratio:(float)r lowValuePlaceHolder:(NSString*)lplaceHolder lowValueKeyboardType:(UIKeyboardType)lkeyboardType highValuePlaceHolder:(NSString*)hplaceHolder highValueKeyboardType:(UIKeyboardType)hkeyboardType signDict:(NSDictionary*)signDict optionDict:(NSDictionary*)optionDict;
//
//// A advance field that provide operator selection
//+(XYValueHelpTableCell*)cellOfValueHelpDateField:(NSString*)name label:(NSString*)label ratio:(float)r mode:(UIDatePickerMode)m dateValueFormat:(NSString*) dvf signDict:(NSDictionary*)signDict optionDict:(NSDictionary*)optionDict;

/**
 Create a dynamic search field
 */
+(XYValueHelpTableCell*)cellOfVHDynaSearchField:(NSString*)name label:(NSString*)label ratio:(float)r delegate:(id<XYDynaSearchFieldDelegate>) delegate;

/**
 Create a dynamic search field
 */
+(XYValueHelpTableCell*)cellOfVHDynaSearchField:(NSString*)name label:(NSString*)label ratio:(float)r delegate:(id<XYDynaSearchFieldDelegate>) delegate singleLine:(BOOL)sl;

@end
