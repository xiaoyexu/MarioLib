//
//  UIDesighHeader.h
//  UIDesign
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#ifndef UIDesign_UIDesighHeader_h
#define UIDesign_UIDesighHeader_h

typedef enum {
    XYReusableCellDefault,
    XYReusableCellBackgroundView,
} XYReusableCell;

typedef enum {
    XYUITableViewStyleNone,
    XYUITableViewStyleEditable, // provide option to switch from editing mode to recapture mode
    XYUITableViewStyleReadonly, // editing not possible
    XYUITableViewStyleOptionList, // Only for selection
} XYUITableViewStyle;

typedef enum {
    XYViewLevelHeader,
    XYViewLevelWorkArea,
    XYViewLevelFooter,
} XYViewLevel;

typedef enum {
    XYViewStatusReadyToExecute,
    XYViewStatusReleaseToExecute,
    XYViewStatusExecuting,
    XYViewStatusFinished,
} XYViewStatus;

typedef enum {
    XYViewDisplayModeTop = 1,
    XYViewDisplayModeBottom = 2,
    XYViewDisplayModeLeft = 4,
    XYViewDisplayModeRight = 8,
} XYViewDisplayMode;

typedef enum{
    XYAdvFieldTypeText,
    XYAdvFieldTypeDate,
} XYAdvFieldType;

typedef enum{
    XYBPSearchModeMDF,
    XYBPSearchModeCRMICSystem,
} XYBPSearchMode;

typedef enum{
    XYBackendLandscapeUnknown = 0,
    XYBackendLandscapePostbox,
    XYBackendLandscapeIC,
    XYBackendLandscapeBC,
    XYBackendLandscapeGateway,
    XYBackendLandscapeSUP,
    XYBackendLandscapeSUPR,
} XYBackendLandscape;

typedef enum{
    XYServerTypeDevelopment = 0, // X
    XYServerTypeVerification,    // V
    XYServerTypeTesting,         // T
    XYServerTypeBugfix,          // D
    XYServerTypeProduction,      // P
    XYServerTypeDemo = 99
} XYServerType;

typedef enum {
    XYBubbleCellStyleDefault = 0,
    XYBubbleCellStyleUI5,
} XYBubbleCellStyle;

typedef enum {
    XYAlertViewStyleDefault = 0,
    XYAlertViewStyleUI5Standard,
    XYAlertViewStyleUI5Light
} XYAlertViewStyle;

typedef enum {
    XYConnectorModeGateway = 0,
    XYConnectorModeSUP,
} XYConnectorMode;

typedef enum {
    XYLogonStyleMDF = 0,
    XYLogonStyleCustomized,
    XYLogonStyleNo,
} XYLogonStyle;

typedef enum {
    XYRequestMethodGet,
    XYRequestMethodPost,
    XYRequestMethodHead,
    XYRequestMethodPut,
    XYRequestMethodDelete,
    XYRequestMethodTrace,
    XYRequestMethodOptions,
    XYRequestMethodConnect,
    XYRequestMethodPatch,
} XYRequestMethod;

typedef enum {
    XYMessageStageDemo,
    XYMessageStageDevelopment,
    XYMessageStageProduction,
} XYMessageStage;

// Other const
#define XYWelcomeViewControllerDismissNotification @"__WELCOMEVIEWCONTROLLER_DISMISSED__"
#define skinStyleKey         @"skinStyle"


#endif
