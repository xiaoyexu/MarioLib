//
//  XYSelectionTableCell.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYRollableTableCell.h"

/**
 This class represents a selection option field wrapped in table cell
 */
@interface XYSelectionTableCell : XYRollableTableCell

/**
 Whether to show selection list by accessory button
 Default NO
 */
@property (nonatomic) BOOL triggerByAccessoryButton;

/**
 Whether to show popover selection list when embeded in XYTableCell
 Default NO and only work on iPad
 */
@property (nonatomic, getter = isPopOverOptionView) BOOL popOverOptionView;
@end

