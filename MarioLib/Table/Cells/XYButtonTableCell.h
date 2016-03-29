//
//  XYButtonTableCell.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYTableCell.h"
#import "XYSelectorObject.h"

/**
 This class represents a cell work as a button in XYBaseUITableViewController
 */
@interface XYButtonTableCell : XYTableCell
{
    @protected
    XYSelectorObject* _onClickSelector;
}
/**
 Logic for button clicked
 */
@property (nonatomic, readonly) XYSelectorObject*  onClickSelector;

/**
 A flag for whether logic in onClick event is executing
 This has to be set by user himself in onClickedSelector, the value won't be filled by library
 
 Example onClickSelector:
  
 -(void)btnClicked{
     if (btn.onClicklogicInProgress) {
          NSLog(@"Logic already triggered");
         return;
     }
     NSLog(@"Execute logic");
     btn.onClicklogicInProgress = YES;
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         sleep(5);
         dispatch_async(dispatch_get_main_queue(), ^{
             btn.onClicklogicInProgress = NO;
         });
     });
 }
 
 */
@property (nonatomic) BOOL onClicklogicInProgress;

/**
  Logic for button clicked
 */
-(void)addTarget:(id)target action:(SEL) selector;
@end
