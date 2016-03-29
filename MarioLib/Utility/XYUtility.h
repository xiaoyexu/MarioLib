//
//  XYUtility.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/4/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDesighHeader.h"
#import "objc/runtime.h"
#import "XYFieldSelectOption.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
//#import "SDMODataEntry.h"
#import "XYSkinManager.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "XYRequest.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/utsname.h>

@interface XYUtility : NSObject
/**
 Mapping properties into dictionary object
 */
+(NSDictionary*)objectToDictionary:(id)obj;

/**
 Mapping dictionary object into object properties
 Proper classname is needed
 */
+(id)dictionaryToObject:(NSDictionary*) dict forClass:(Class) objClass;

/**
 Check if a string exist in an array
 */
+(BOOL)isString:(NSString*) str inArray:(NSArray*)array;

/**
 Return match string list of given regular expression
 This method will return all matched string part
 The express can be ".*(abc.*).*", string matched in group (abc...) will be saved in return list
 */
+(NSArray*)matchStringListOfString:(NSString*)str matchRegularExpression:(NSString*)regStr;

/**
 Convert standard text into html string
 */
+(NSString*)textToHtml:(NSString*)string;

/**
 Convert html string into standard text
 */
+(NSString*)htmlToText:(NSString*)string;

/**
 Separate notes log text into NSArray by note category
 notesText is note log string
 noteTypes is the note type array, you have to provide all possbile note type name
 
 The return array contains dictionary object which below keys
 noteType
 noteDate
 noteTime
 noteUserID
 noteUsername
 noteText
 */
+(NSArray*)parseNotes:(NSString*)notesText noteTypes:(NSArray*)types lineSeparator:(NSString*) sep;

/**
 Return a dictionary, the key is note type, the value is an array of dictionary object of each note
 */
+(NSDictionary*)parseNotesByCategory:(NSString*)notesText noteTypes:(NSArray*)types lineSeparator:(NSString*) sep;

/**
 Parse date string from source format to target format
 */
+(NSString*)convertDateFormatter:(NSString*)sourceFormatter targetFormatter:(NSString*)targetFormatter dateString:(NSString*)dateString;

/**
 Parse NSDate to NSString object
 */
+(NSString*)dateToString:(NSString *)formatter date:(NSDate *)date;

/**
 Parse NSString object to NSDate
 e.g.
 [XYUtility stringToDate:@"yyyy-MM-dd'T00:00:00' 'PT'HH'H'mm'M'ss'S'" dateString:dateStr]
 */
+(NSDate*)stringToDate:(NSString*)formatter dateString:(NSString*)dateStr;

/**
 Return number string without leading zeros
 */
+(NSString*)removeLeadingZeros:(NSString*)srcStr;

/**
 Return number string with leading zeros
 */
+(NSString*)fillLeadingZeros:(NSString*)srcStr fullLength:(NSUInteger)length;

/**
 Return query string for gateway
 This method will parse multiple selection
 E.g
 name eq 'A'
 name eq 'B'
 Into
 (name eq 'A' and name eq 'B')
 */
+(NSString*)gatewayQueryStringFromFieldSelectionOption:(XYFieldSelectOption*)fso;

/**
 Return atom query string for a single SelectOption for gateway
 This method parse field Property I EQ A B to gateway foramt
 E.g.
 date I BT A B -> date ge 'A' or date le 'B'
 property EQ A -> property eq 'A'
 */
+(NSString*)parseProperty:(NSString*)property withSingleSelectOption:(XYSelectOption*)so;

/**
 Parsing query string for gateway
 E.g.
 For selection key 'Name' value 'Tom|Jerry', parse it to
 (Name eq 'Tom' or Name eq 'Jerry')
 */
+(NSString*)parseProperty:(NSString *)property operator:(NSString*)op value:(NSString*)value separator:(NSString*)sep;

/**
 Parsing query string
 @param property Field or property name. E.g. "Name"
 @param op Operator. E.g. "eq"
 @param value String value. E.g. "Car,Bus"
 @param sep Separator value. E.g. ","
 @param format Format for property operator value group. E.g. "%@ %@ '%@'". The order is defined in order property, operator, value.
 @param rop Relationship operator of 2 pair. E.g. " or " in "Name eq 'abc' or Name eq 'xyz'"
 @param fFormat Format for final return string. E.g. @"(%@)".
 */
+(NSString*)parseProperty:(NSString *)property operator:(NSString *)op value:(NSString *)value separator:(NSString *)sep format:(NSString*)format relationshipOperator:(NSString*) rop finalFormat:(NSString*)fFormat;

/**
 Check whether a NSString is nil or blank
 */
+(BOOL)isBlank:(NSString*)field;

/**
 Create UIColor by RGBA added up from 2 UIColor
 */
+(UIColor*)addColor:(UIColor*)color toColor:(UIColor*)target;

/**
 Create UIColor by minus RGBA value from UIColor by another
 */
+(UIColor*)minusColor:(UIColor*)color fromColor:(UIColor*)target;

/**
 Return the size of text
 */
+(CGSize)sizeOfText:(NSString*)text withFont:(UIFont*) font constrainedSize:(CGSize)constrainedSize;

/**
 Check whether connect to network
 */
+(BOOL)isConnectedToNetwork;

/**
 Return backend url landscape
 */
+(XYBackendLandscape)landscapeOfDomain:(NSString*) domain;

/**
 Check if target string matches regular expression
 */
+(BOOL)isString:(NSString*) str matchRegularExpression:(NSString*)regStr;

/**
  Return full url path of a given service
  For Gateway
  https://<gateway>/sap/opu/odata/sap/<service name>
  For SUP
  https://<SUP>/<service name>
 
 */
+(NSString*)fullURLPathOfService:(NSString*)service onDomain:(NSString*)domain;

/**
  Return the server based on type and landscape
 // Unkown   // Postbox  //IC        //BC        //Gateway   //SUP
 {@"",       wcd_server, icx_server, bcd_server, pgx_server, supx_server}, //X
 {@"",       wcq_server, icv_server, bcv_server, pgv_server, supv_server}, //V
 {@"",       wct_server, ict_server, bct_server, pgt_server, supt_server}, //T
 {@"",       wcm_server, icd_server, bcm_server, pgd_server, supd_server}, //D
 {@"",       postbox_server, icp_server, bc_server, pgp_server, supp_server}, //P

 */
+(NSString*)serverOfType:(XYServerType)type inLandscape:(XYBackendLandscape) landscape;

/**
 Generate UUID e.g. 5D38C01E-8841-4A07-9080-E94BEAB37DEE
 */
+(NSString*)generateUUID;

/**
 Get inline link entries by expand name from SDMODataEntry
 */
//+(NSArray*)getODataInlineLinkEntryiesFrom:(SDMODataEntry*)entry ByExpandName:(NSString*)expandName;

/**
 Return a view of XY Logo
 */
+(UIView*)sapLogoWithFrame:(CGRect)frame withRMark:(BOOL)rMark;

/**
 Return SAP blue
 */
+(UIColor*)sapBlueColor;

/**
 Return SAP dark blue
 */
+(UIColor*)sapDarkBlueColor;

/**
 Return SAP sky light blue
 */
+(UIColor*)sapSkyLightBlueColor;

/**
 Return SAP light blue
 */
+(UIColor*)sapLightBlueColor;

+(UIColor*)sapMessageTextLightGrayColor;

+(UIColor*)iOS6messageAppBackgroundColor;
/**
 Set title in navigation item
 Font and color taken from XYSkinManager
 navigationBarTitleFont and navigationBarTitleColor
 */
+(void)setTitle:(NSString *)title inNavigationItem:(UINavigationItem*)navigationItem;

/**
 Return a view of UI5 standard background
 */
+(UIView*)sapUI5BackgroundViewWithFrame:(CGRect)frame;

/**
 Return a view of UI5 Indicator icon "C"
 */
+(UIView*)sapUI5ActivityIndicatorIconWithFrame:(CGRect)frame iconColor:(UIColor*)color backgroundColor:(UIColor*)bgc;

/**
 Return main screen size
 */
+(CGSize)currentScreenSize;

/**
 Blue gradient layer
 */
+(CAGradientLayer*)blueGradientLayer;

/**
 Red gradient layer
 */
+(CAGradientLayer*)redGradientLayer;

/**
 Green gradient layer
 */
+(CAGradientLayer*)greenGradientLayer;

/**
 Orange gradient layer
 */
+(CAGradientLayer*)orangeGradientLayer;

+(UIView*)mainWindowView;

/**
 Get WIFI SSID info
 */
+(id)fetchSSIDInfo;

/**
 Check host reachablity
 */
+(BOOL)checkReachableForHost:(NSString*)host;

/**
 Return the identity summary
 */
+(NSString*)identitySummary:(SecIdentityRef)identity;

/**
 Initialize identity by data
 */
+(SecIdentityRef)identityWithData:(NSData*)data usingPassphrase:(NSString*)passphrase;

/**
 Return macaddress
 */
+(NSString*)macaddress;

/**
 Return unique device name
 */
+(NSString*)uniqueDeviceName;

/**
 Return unique device identifier
 */
+(NSString*)uniqueDeviceIdentifier;

/**
 Return unique global device name
 */
+(NSString*)uniqueGlobalDeviceName;

/**
 Return unique global device identifier
 */
+(NSString*)uniqueGlobalDeviceIdentifier;

/**
 Return md5 string;
 */
+(NSString*)stringFromMD5:(NSString*)md5string;

/**
 Check version number e.g. 1.1 is older than 1.1.2
 */
+(BOOL)isVersion:(NSString*)version olderThan:(NSString*)newVersion;

/**
 Check if MDF App installed
 */
+(BOOL)isMDFAppInstalled:(NSString*)appid;

/**
 Return NSString value of http request method
 */
+(NSString*)convertMethod:(XYRequestMethod)method;

/**
 Parse url with NSDictionary parameters
 */
+(NSURL*)parseURL:(NSURL*)url withQuery:(NSDictionary*)parameters;

/**
 Concatenate NSDictionary parameter into url format
 */
+(NSString*)concatenateQuery:(NSDictionary*)parameters;
/**
 Split a url parameter into NSDictionary
 */
+(NSDictionary*)splitQuery:(NSString*)query;

/**
 Encrypt string by MD5
 */
+(NSString*)stringEncryptedByMD5:(NSString *)str;

+(NSString*)encrypt:(NSString*)plainText key:(NSString*)key initVect:(NSString*)iv;
+(NSString*)decrypt:(NSString*)encryptText key:(NSString*)key initVect:(NSString*)iv;;

+(NSString*)deviceString;

//+(NSString*)urlQueryStringFromParametersWithEncoding:(NSDictionary*)parameters encoding:(NSStringEncoding) stringEncoding;

+(UIColor*)randomColor;

+(NSString*)appVersion;
@end
