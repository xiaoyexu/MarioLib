//
//  XYUtility.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 7/4/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYUtility.h"

@implementation XYUtility

+(NSDictionary*)objectToDictionary:(id)obj{
    NSMutableDictionary* dictionary = [NSMutableDictionary new];
    Class cls = [obj class];
    unsigned int ivarsCnt = 0;
    objc_property_t *properties = class_copyPropertyList(cls,&ivarsCnt);
    for (int i = 0 ; i < ivarsCnt ; i++) {
        objc_property_t property = properties[i];
        const char* propname = property_getName(property);
        if (propname) {
            NSString* propertyName = [NSString stringWithUTF8String:propname];
            NSString* propertyValue = [obj valueForKey:propertyName];
            if (propertyName != nil && propertyValue != nil) {
                [dictionary setObject:propertyValue forKey:propertyName];
            }
            
        }
        
    }
    return dictionary;
}

+(id)dictionaryToObject:(NSDictionary*) dict forClass:(Class) objClass{
    id obj = [objClass new];
    BOOL valuePopluated = NO;
    NSEnumerator* enu = dict.keyEnumerator;
    NSString* key;
    NSString* value;
    while ((key = enu.nextObject)) {
        value = [dict objectForKey:key];
        if (value == nil) {
            value = @"";
        }
        SEL setSelector = [self setSelectorOfProperty:key];
        if ([obj respondsToSelector:setSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [obj performSelector:setSelector withObject:value];
#pragma clang diagnostic pop
            valuePopluated = YES;
        }
    }
    if (valuePopluated) {
        return obj;
    } else {
        return nil;
    }
}

+(SEL)setSelectorOfProperty:(NSString*)name{
    NSString* initLetter = [name substringToIndex:1];
    NSString* restName = [name substringFromIndex:1];
    NSString* setName = [NSString stringWithFormat:@"set%@%@:",[initLetter uppercaseString],restName];
    return NSSelectorFromString(setName);
}


/*
 E.g. Note response from server as:
 @"Exit Criteria\\n"
 "05.06.2013          07:33:06            I068191\\n"
 "Xiaoye Xu\\n"
 "\\n"
 "Here is exit criteria\\n"
 "...\\n"
 "...\\n"
 "...\\n"
 "end\\n"
 "____________________\\n"
 "Customer and Engagement\\n"
 "05.06.2013          07:32:45            I068191\\n"
 "Xiaoye Xu\\n"
 "\\n"
 "Here is management description\\n"
 "...\\n"
 "...\\n"
 "...\\n"
 "end\\n"
 "____________________\\n"
 "Description\\n"
 "05.06.2013          07:32:11            I068191\\n"
 "Xiaoye Xu\\n"
 "\\n"
 "Here is cross issue detail description\\n"
 "...\\n"
 "...\\n"
 "...\\n"
 "end\\n"
 
 The array returned as:
 
 <__NSArrayM 0xa40b8f0>(
 {
 noteDate = "05.06.2013";
 noteText = "Here is exit criteria\n...\n...\n...\nend\n";
 noteTime = "07:33:06";
 noteType = "Exit Criteria";
 noteUserID = I068191;
 noteUsername = "Xiaoye Xu";
 },
 {
 noteDate = "05.06.2013";
 noteText = "Here is management description\n...\n...\n...\nend\n";
 noteTime = "07:32:45";
 noteType = "Customer and Engagement";
 noteUserID = I068191;
 noteUsername = "Xiaoye Xu";
 },
 {
 noteDate = "05.06.2013";
 noteText = "Here is cross issue detail description\n...\n...\n...\nend\n";
 noteTime = "07:32:11";
 noteType = Description;
 noteUserID = I068191;
 noteUsername = "Xiaoye Xu";
 }
 )
 */

+(NSArray*)parseNotes:(NSString*)notesText noteTypes:(NSArray*)types lineSeparator:(NSString*) sep{
    NSMutableArray* result = [NSMutableArray new];
    int status = -1;
    static const int NOTES_TYPE_READ = 0;
    static const int NOTES_DATETIME_READ = 1;
    static const int NOTES_NAME_READ = 2;
    static const int NOTES_TEXT_READ = 3;
    static const int NOTES_SEPLINE_READ = 4;
    
    int inline_status = -1;
    static const int NOTES_DATE_READ = 0;
    static const int NOTES_TIME_READ = 1;
    static const int NOTES_UID_READ = 2;
    
    NSString* type = @"";
    NSString* date = @"";
    NSString* time = @"";
    NSString* userid = @"";
    NSString* username = @"";
    NSString* noteText = @"";
    NSString* sepLine = @"";
    NSArray* lines = [notesText componentsSeparatedByString:sep];
    for (NSString* line in lines) {
        //        if ( status == -1 && ([line isEqualToString:@"Description"] || [line isEqualToString:@"Note"] )) {
        if ( status == -1 && [self isString:line inArray:types]) {
            status = NOTES_TYPE_READ;
            type = line;
        } else if (status == NOTES_TYPE_READ) {
            NSArray* tempLines = [line componentsSeparatedByString:@" "];
            inline_status = -1;
            for (NSString* line in tempLines) {
                if (line != nil && ![line isEqualToString:@""]) {
                    if (inline_status == -1) {
                        date = line;
                        inline_status = NOTES_DATE_READ;
                    } else if (inline_status == NOTES_DATE_READ) {
                        time = line;
                        inline_status = NOTES_TIME_READ;
                    } else if (inline_status == NOTES_TIME_READ) {
                        userid = line;
                        inline_status = NOTES_UID_READ;
                        status = NOTES_DATETIME_READ;
                    }
                }
            }
        } else if (status == NOTES_DATETIME_READ){
            username = line;
            status = NOTES_NAME_READ;
        } else if (status == NOTES_NAME_READ || status == NOTES_TEXT_READ){
            if ([line isEqualToString:@""]) {
                continue;
            }
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[_]+$" options:NSRegularExpressionCaseInsensitive error:&error];
            NSInteger n = [regex numberOfMatchesInString:line options:0 range:NSMakeRange(0, line.length)];
            if (n != 0) {
                status = NOTES_SEPLINE_READ;
                
                NSMutableDictionary* dictLine = [NSMutableDictionary new];
                [dictLine setValue:type forKey:@"noteType"];
                [dictLine setValue:date forKey:@"noteDate"];
                [dictLine setValue:time forKey:@"noteTime"];
                [dictLine setValue:userid forKey:@"noteUserID"];
                [dictLine setValue:username forKey:@"noteUsername"];
                [dictLine setValue:noteText forKey:@"noteText"];
                [result addObject:dictLine];
                status = -1;
                type = @"";
                date = @"";
                time = @"";
                userid = @"";
                username = @"";
                noteText = @"";
                sepLine = @"";
                
            } else {
                if (status == NOTES_TEXT_READ) {
                    noteText = [noteText stringByAppendingString:@"\n"];
                }
                noteText = [noteText stringByAppendingString:line];
                status = NOTES_TEXT_READ;
            }
        }
    }
    if (status == NOTES_TEXT_READ) {
        NSMutableDictionary* dictLine = [NSMutableDictionary new];
        [dictLine setValue:type forKey:@"noteType"];
        [dictLine setValue:date forKey:@"noteDate"];
        [dictLine setValue:time forKey:@"noteTime"];
        [dictLine setValue:userid forKey:@"noteUserID"];
        [dictLine setValue:username forKey:@"noteUsername"];
        [dictLine setValue:noteText forKey:@"noteText"];
        [result addObject:dictLine];
        status = -1;
    }
    
    return result;
}

+(BOOL)isString:(NSString*) str inArray:(NSArray*)array{
    for (NSString* obj in array) {
        if ([str isEqualToString:obj]) {
            return YES;
        }
    }
    return NO;
}

+(NSString*)textToHtml:(NSString*)string {
    string = [string stringByReplacingOccurrencesOfString:@"&"  withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"<"  withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">"  withString:@"&gt;"];
    string = [string stringByReplacingOccurrencesOfString:@"""" withString:@"&quot;"];
    string = [string stringByReplacingOccurrencesOfString:@"'"  withString:@"&#039;"];
    //string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    return string;
}

+(NSString*)htmlToText:(NSString*)string {
    string = [string stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
    string = [string stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"&#13;" withString:@"\n"];
    return string;
}

/*
 Return dictionary, struture as below
 {
 "Customer and Engagement" =     (
 {
 noteDate = "05.06.2013";
 noteText = "Here is management description\n...\n...\n...\nend\n";
 noteTime = "07:32:45";
 noteType = "Customer and Engagement";
 noteUserID = I068191;
 noteUsername = "Xiaoye Xu";
 },
 {
 noteDate = "01.06.2013";
 noteText = "Here is old management description\n...\n...\n...\nend\n";
 noteTime = "01:32:11";
 noteType = "Customer and Engagement";
 noteUserID = I068099;
 noteUsername = "Han Wang";
 }
 );
 Description =     (
 {
 noteDate = "05.06.2013";
 noteText = "Here is cross issue detail description\n...\n...\n...\nend\n";
 noteTime = "07:32:11";
 noteType = Description;
 noteUserID = I068191;
 noteUsername = "Xiaoye Xu";
 }
 );
 "Exit Criteria" =     (
 {
 noteDate = "05.06.2013";
 noteText = "Here is exit criteria\n...\n...\n...\nend\n";
 noteTime = "07:33:06";
 noteType = "Exit Criteria";
 noteUserID = I068191;
 noteUsername = "Xiaoye Xu";
 },
 {
 noteDate = "01.05.2013";
 noteText = "Here is old cross issue exit criteria\n...\n...\n...\nend\n";
 noteTime = "02:14:28";
 noteType = "Exit Criteria";
 noteUserID = I012345;
 noteUsername = Someone;
 }
 );
 }
 */
+(NSDictionary*)parseNotesByCategory:(NSString*)notesText noteTypes:(NSArray*)types lineSeparator:(NSString*) sep{
    NSArray* noteArray = [self parseNotes:notesText noteTypes:types lineSeparator:sep];
    NSMutableDictionary* result = [NSMutableDictionary new];
    
    for (NSDictionary* note in noteArray) {
        NSString* noteType = [note objectForKey:@"noteType"];
        
        NSMutableArray* noteArr = [result objectForKey:noteType];
        if (noteArr == nil) {
            noteArr = [NSMutableArray new];
            [result setValue:noteArr forKey:noteType];
        }
        [noteArr addObject:note];
    }
    return result;
}

+(NSString*)convertDateFormatter:(NSString*)sourceFormatter targetFormatter:(NSString*)targetFormatter dateString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:sourceFormatter];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:targetFormatter];
    return[dateFormatter stringFromDate:date];
}

+(NSString*)dateToString:(NSString *)formatter date:(NSDate *)date{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+(NSDate*)stringToDate:(NSString*)formatter dateString:(NSString*)dateStr{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateStr];
}

+(NSString*)removeLeadingZeros:(NSString*)srcStr{
    @try {
        NSInteger n = [srcStr integerValue];
        return [NSString stringWithFormat:@"%d",n];
    }
    @catch (NSException *exception) {
        return srcStr;
    }
    
}

+(NSString*)fillLeadingZeros:(NSString*)srcStr fullLength:(NSUInteger)length{
    if (srcStr == nil) {
        return srcStr;
    }
    if (srcStr.length >= length) {
        return srcStr;
    }
    NSNumberFormatter* nf = [NSNumberFormatter new];
    nf.paddingCharacter = @"0";
    nf.minimumIntegerDigits = length;
    nf.paddingPosition = NSNumberFormatterPadBeforePrefix;
    return [nf stringFromNumber:[NSNumber numberWithUnsignedLongLong:[srcStr longLongValue]]];
}

+(NSString*)gatewayQueryStringFromFieldSelectionOption:(XYFieldSelectOption*)fso{
    NSString* result = @"";
    NSString* atomQueryStr = @"";
    NSUInteger currentRow = 0;
    for (XYSelectOption* so in fso.selectOptions) {
        atomQueryStr = [XYUtility parseProperty:fso.property withSingleSelectOption:so];
        if (currentRow > 0) {
            result = [NSString stringWithFormat:@"%@ and (%@)",result,atomQueryStr];
        } else {
            result = [NSString stringWithFormat:@"(%@)",atomQueryStr];
        }
        currentRow++;
    }
    return result;
}

+(NSString*)parseProperty:(NSString*)property withSingleSelectOption:(XYSelectOption*)so{
    NSString* result;
    if ([so.option isEqualToString:@"BT"]) {
        result = [NSString stringWithFormat:@"%@ ge '%@' or %@ le '%@'",property,so.lowValue,property,so.highValue];
    } else if ([so.option isEqualToString:@"NB"]) {
        
    } else {
        result = [NSString stringWithFormat:@"%@ %@ '%@'",property,so.option.lowercaseString,so.lowValue];
    }
    return result;
    
}

+(NSString*)parseProperty:(NSString *)property operator:(NSString*)op value:(NSString*)value separator:(NSString*)sep{
    return [XYUtility parseProperty:property operator:op value:value separator:sep format:@"%@ %@ '%@'" relationshipOperator:@" or " finalFormat:@"(%@)"];
}

+(NSString*)parseProperty:(NSString *)property operator:(NSString *)op value:(NSString *)value separator:(NSString *)sep format:(NSString*)format relationshipOperator:(NSString*) rop finalFormat:(NSString*)fFormat{
    
    NSArray* valueList = [value componentsSeparatedByString:sep];
    NSString* result = @"";
    if (valueList.count == 1) {
        result = [NSString stringWithFormat:format,property, op, value];
    } else {
        int i = 0;
        
        for (NSString* v in valueList) {
            NSString* s = [NSString stringWithFormat:format,property,op,v];
            if (i == 0) {
                result = s;
            } else {
                result = [NSString stringWithFormat:@"%@%@%@",result,rop,s];
            }
            i++;
        }
        result = [NSString stringWithFormat:fFormat, result];
        return result;
    }
    return result;
}


+(BOOL)isBlank:(NSString*)field{
    return field == nil ? YES : field.length == 0 ? YES : NO;
}

+(UIColor*)addColor:(UIColor*)color toColor:(UIColor*)target{
    CGFloat cr,cg,cb,ca,tr,tg,tb,ta,fr,fg,fb,fa;
    [color getRed:&cr green:&cg blue:&cb alpha:&ca];
    [target getRed:&tr green:&tg blue:&tb alpha:&ta];
    fr = cr + tr;
    fg = cg + tg;
    fb = cb + tb;
    fa = ca + ta;
    return [UIColor colorWithRed:fr green:fg blue:fb alpha:fa];
}

+(UIColor*)minusColor:(UIColor*)color fromColor:(UIColor*)target{
    CGFloat cr,cg,cb,ca,tr,tg,tb,ta,fr,fg,fb,fa;
    [color getRed:&cr green:&cg blue:&cb alpha:&ca];
    [target getRed:&tr green:&tg blue:&tb alpha:&ta];
    fr = tr - cr;
    fg = tg - cg;
    fb = tb - cb;
    fa = ta - ca;
    return [UIColor colorWithRed:fr green:fg blue:fb alpha:fa];
}

+(CGSize)sizeOfText:(NSString*)text withFont:(UIFont*) font constrainedSize:(CGSize)constrainedSize{
    
    if (text == nil || font == nil) {
        return CGSizeZero;
    }
    
    CTFontRef ref = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    
    NSMutableDictionary *attrDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge id)ref, (NSString *)kCTFontAttributeName, nil];
    
    NSAttributedString* s = [[NSAttributedString alloc] initWithString:text attributes:attrDictionary];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)s);
    
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [text length]), NULL, constrainedSize, NULL);
    
    textSize.height = ceil(textSize.height);
    textSize.width = ceil(textSize.width);
    
    return textSize;
}

+(BOOL)isConnectedToNetwork{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}



+(XYBackendLandscape)landscapeOfDomain:(NSString*) domain{
    if ([XYUtility isString:domain matchRegularExpression:@"^(wc[dqmt]|postbox)\\.dmzwdf\\.sap\\.corp$"]) {
        return XYBackendLandscapePostbox;
    }
    if ([XYUtility isString:domain matchRegularExpression:@"^ic[xvdtp]\\.wdf\\.sap\\.corp$"]) {
        return XYBackendLandscapeIC;
    }
    if ([XYUtility isString:domain matchRegularExpression:@"^(bc[dvqmtps]main|support)\\.wdf\\.sap\\.corp$"]) {
        return XYBackendLandscapeBC;
    }
    if ([XYUtility isString:domain matchRegularExpression:@"^(pg[xvdtp]main)\\.wdf\\.sap\\.corp$"]) {
        return XYBackendLandscapeGateway;
    }
    if ([XYUtility isString:domain matchRegularExpression:@"^spwdfvm(1370|1660|1661|1638|1371)\\.dmzwdf\\.sap\\.corp$"]) {
        return XYBackendLandscapeSUP;
    }
    if ([XYUtility isString:domain matchRegularExpression:@"^msaprelaygateway(x|v|d|t)\\.dmzwdf\\.sap\\.corp$"] || [XYUtility isString:domain matchRegularExpression:@"^msaprelaygateway\\.co\\.sap\\.com$"]) {
        return XYBackendLandscapeSUPR;
    }
    return XYBackendLandscapeUnknown;
}

+(BOOL)isString:(NSString*) str matchRegularExpression:(NSString*)regStr{
    if ([XYUtility isBlank:str] || [XYUtility isBlank:regStr]) {
        return NO;
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSInteger n = [regex numberOfMatchesInString:str options:0 range:NSMakeRange(0, str.length)];
    return n != 0;
}

+(NSArray*)matchStringListOfString:(NSString*)str matchRegularExpression:(NSString*)regStr{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray* matchResult = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    NSMutableArray* strList = [NSMutableArray new];
    NSString* subStr;
    for (NSTextCheckingResult* cr in matchResult) {
        subStr = [str substringWithRange:cr.range];
        NSRange r1 = [cr rangeAtIndex:1];
        if (!NSEqualRanges(r1, NSMakeRange(NSNotFound, 0))) {
            subStr = [str substringWithRange:r1];
        }
        [strList addObject:subStr];
    }
    return strList;
}

+(NSString*)fullURLPathOfService:(NSString*)service onDomain:(NSString*)domain{
    
//    switch ([XYUtility landscapeOfDomain:domain]) {
//        case XYBackendLandscapeGateway:{
//            if ([service isEqualToString:@"ZS_ESCALATIONS"] || [service isEqualToString:@"ZS_AGS_DASHBOARDS_SRV"]) {
//                return [NSString stringWithFormat:@"https://%@/sap/opu/odata/sap/%@/",domain,service];
//            } if ([service isEqualToString:@"ZS_AGS_MDF"]) {
//                return [NSString stringWithFormat:@"https://%@/sap/opu/odata/svx/MDF_SRV/",domain];
//            } else {
//                return [NSString stringWithFormat:@"https://%@/%@/",domain,service];
//            }
//        }
//            
//            break;
//        case XYBackendLandscapeSUP:
//            return [NSString stringWithFormat:@"https://%@/%@/",domain,service];
//        case XYBackendLandscapeSUPR:{
//            if ([domain isEqualToString:suprx_server]) {
//                return [NSString stringWithFormat:@"https://%@/ias_relay_server/client/rs_client.dll/SUPRX/%@/",suprx_server,service];
//            }
//            if ([domain isEqualToString:suprv_server]) {
//                return [NSString stringWithFormat:@"https://%@/ias_relay_server/client/rs_client.dll/SUPRV/%@/",suprv_server,service];
//            }
//            if ([domain isEqualToString:suprd_server]) {
//                return [NSString stringWithFormat:@"https://%@/ias_relay_server/client/rs_client.dll/SUPRD/%@/",suprd_server,service];
//            }
//            if ([domain isEqualToString:suprt_server]) {
//                return [NSString stringWithFormat:@"https://%@/ias_relay_server/client/rs_client.dll/SUPRT/%@/",suprt_server,service];
//            }
//            if ([domain isEqualToString:suprp_server]) {
//                return [NSString stringWithFormat:@"https://%@/ias_relay_server/client/rs_client.dll/SUPRP/%@/",suprp_server,service];
//            }
//        }
//            
//        default:
//            return [NSString stringWithFormat:@"https://%@/%@/",domain,service];
//            break;
//    }
    return @"";
}

+(NSString*)serverOfType:(XYServerType)type inLandscape:(XYBackendLandscape) landscape{
    return @"";
//    if (type == XYServerTypeDemo) {
//        return @"";
//    }
//    
//    NSString* a[5][7] = {
//        
//        // Unkown   // Postbox  //IC        //BC        //Gateway   //SUP        //SUR
//        {@"",       wcd_server, icx_server, bcd_server, pgx_server, supx_server, suprx_server}, //X
//        {@"",       wcq_server, icv_server, bcv_server, pgv_server, supv_server, suprv_server}, //V
//        {@"",       wct_server, ict_server, bct_server, pgt_server, supt_server, suprt_server}, //T
//        {@"",       wcm_server, icd_server, bcm_server, pgd_server, supd_server, suprd_server},  //D
//        {@"",       postbox_server, icp_server, bc_server, pgp_server, supp_server,suprp_server}, //P
//        
//    };
//
//    return a[type][landscape];
}
                     
+(NSString*)generateUUID{
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    NSString* uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    return uuidString;
}

//+(NSArray*)getODataInlineLinkEntryiesFrom:(SDMODataEntry*)entry ByExpandName:(NSString*)expandName{
//    
//    NSDictionary* inlineLinks = entry.inlinedRelatedEntries;
//    NSEnumerator* enumerator = inlineLinks.keyEnumerator;
//    NSString* inlineLinkKey;
//    NSString* regex = [NSString stringWithFormat:@".*/%@$",expandName];
//    while ((inlineLinkKey = [enumerator nextObject]) != nil) {
//        if ([XYUtility isString:inlineLinkKey matchRegularExpression:regex]) {
//            return [entry getInlinedRelatedEntriesForRelatedLink:inlineLinkKey];
//        }
//    }
//    return nil;
//}

+(UIView*)sapLogoWithFrame:(CGRect)frame withRMark:(BOOL)rMark{
    
    if (frame.size.height*2 >= frame.size.width) {
        frame.size.width = frame.size.height*2;
    } else {
        frame.size.height = frame.size.width / 2.0f;
    }
    
    UIView* v = [[UIView alloc] initWithFrame:frame];
    
    // Background color and shape
    CAGradientLayer* gradient = [CAGradientLayer layer];
    gradient.frame = v.bounds;
    gradient.colors = @[
                        (id)[UIColor colorWithRed:45.0/255 green:180.0/255 blue:233.0/255 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:29.0/255 green:109.0/255 blue:200.0/255 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:38.0/255 green:97.0/255 blue:185.0/255 alpha:1].CGColor
                        ];
    
    [v.layer insertSublayer:gradient atIndex:0];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0.0f, 0.0f);
    
    CGPathAddLineToPoint(path, NULL, v.bounds.size.width , 0.0f);
    CGPathAddLineToPoint(path, NULL, v.bounds.size.width * 0.5f, v.bounds.size.height);
    CGPathAddLineToPoint(path, NULL, 0.0f, v.bounds.size.height);
    CGPathAddLineToPoint(path, NULL, 0.0f,0.0f);
    
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:path];
    [shapeLayer setFillColor:[UIColor whiteColor].CGColor];
    [shapeLayer setStrokeColor:[UIColor clearColor].CGColor];
    [shapeLayer setBounds:CGRectMake(0.0, 0.0, 70, 70)];
    [shapeLayer setAnchorPoint:CGPointMake(0, 0)];
    [shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    
    [gradient setMask:shapeLayer];
    
    // SAP logo letter
    path = CGPathCreateMutable();
    
    float wr = frame.size.width/512.0f;
    float hr = frame.size.height/256.0f;
    
    
    // Draw S
    CGPathMoveToPoint(path, NULL, (253.0f - 127.0f)*wr, (186.0f - 127.0f)*hr);
    
    CGPathAddCurveToPoint(path, NULL, (139 - 127.0f)*wr, (135 - 127.0f)*hr, (84 - 127.0f)*wr,(250 - 127.0f)*hr, (190 - 127.0f)*wr, (273 - 127.0f)*hr);
    
    CGPathAddCurveToPoint(path, NULL, (250 - 127.0f)*wr, (298 - 127.0f)*hr, (173 - 127.0f)*wr, (313 - 127.0f)*hr, (150 - 127.0f)*wr, (288 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (133 - 127.0f)*wr, (322 - 127.0f)*hr);
    CGPathAddCurveToPoint(path, NULL, (241 - 127.0f)*wr, (381 - 127.0f)*hr, (300 - 127.0f)*wr, (254 - 127.0f)*hr, (207 - 127.0f)*wr, (237 - 127.0f)*hr);
    CGPathAddCurveToPoint(path, NULL, (165 - 127.0f)*wr, (228 - 127.0f)*hr, (165 - 127.0f)*wr, (194 - 127.0f)*hr, (236 - 127.0f)*wr, (216 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (253 - 127.0f)*wr, (186 - 127.0f)*hr);
    
    
    // Draw A
    CGPathMoveToPoint(path, NULL, (293.0f - 127.0f)*wr, (175.0f - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (235 - 127.0f)*wr, (334 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (281 - 127.0f)*wr, (334 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (288 - 127.0f)*wr, (309 - 127.0f)*hr);
    
    CGPathAddArcToPoint(path, NULL, (315 - 127.0f)*wr, (318 - 127.0f)*hr, (342 - 127.0f)*wr, (309 - 127.0f)*hr, 80*hr);
    
    CGPathAddLineToPoint(path, NULL, (347 - 127.0f)*wr, (334 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (395 - 127.0f)*wr, (334 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (338 - 127.0f)*wr, (175 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (293 - 127.0f)*wr, (175 - 127.0f)*hr);
    
    CGPathMoveToPoint(path, NULL, (315 - 127.0f)*wr, (222 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (330 - 127.0f)*wr, (275 - 127.0f)*hr);
    CGPathAddArcToPoint(path, NULL, (315 - 127.0f)*wr, (279 - 127.0f)*hr, (300 - 127.0f)*wr, (275 - 127.0f)*hr, 60*hr);
    CGPathAddLineToPoint(path, NULL, (315 - 127.0f)*wr, (222 - 127.0f)*hr);
    
    // Draw P
    CGPathMoveToPoint(path, NULL, (381.0f - 127.0f)*wr, (175.0f - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (381 - 127.0f)*wr, (334 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (424 - 127.0f)*wr, (334 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (424 - 127.0f)*wr, (285 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (450 - 127.0f)*wr, (285 - 127.0f)*hr);
    
    CGPathAddCurveToPoint(path, NULL, (521 - 127.0f)*wr, (279 - 127.0f)*hr, (521 - 127.0f)*wr, (177 - 127.0f)*hr, (449 - 127.0f)*wr, (175 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (381 - 127.0f)*wr, (175 - 127.0f)*hr);
    
    CGPathMoveToPoint(path, NULL, (434 - 127.0f)*wr, (210 - 127.0f)*hr);
    CGPathAddCurveToPoint(path, NULL, (470 - 127.0f)*wr, (205 - 127.0f)*hr, (470 - 127.0f)*wr, (255 - 127.0f)*hr, (434 - 127.0f)*wr, (250 - 127.0f)*hr);
    
    CGPathAddLineToPoint(path, NULL, (424 - 127.0f)*wr, (250 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (424 - 127.0f)*wr, (210 - 127.0f)*hr);
    CGPathAddLineToPoint(path, NULL, (434 - 127.0f)*wr, (210 - 127.0f)*hr);
    
    // Draw Registered mark
    if (rMark) {
        CGRect f = CGRectMake(0, frame.size.height / 14.0f, frame.size.width * 4.0f/5.0f, frame.size.height);
        float fontSize = frame.size.height / 3.5f;
        
        UITextField* r = [[UITextField alloc] initWithFrame:f];
        r.text = @"®";
        r.font = [UIFont systemFontOfSize:fontSize];
        r.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        r.textAlignment = NSTextAlignmentRight;
        r.contentMode = UIViewContentModeBottomRight;
        [r setAdjustsFontSizeToFitWidth:YES];
        r.textColor = [UIColor colorWithRed:27.0/255 green:73.0/255 blue:173.0/255 alpha:0.9];
        [v addSubview:r];
    }
    
    shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:path];
    [shapeLayer setFillColor:[UIColor whiteColor].CGColor];
    [shapeLayer setStrokeColor:[UIColor whiteColor].CGColor];
    [shapeLayer setBounds:CGRectMake(0.0, 0.0, 70, 70)];
    [shapeLayer setAnchorPoint:CGPointMake(0, 0)];
    [shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    [v.layer addSublayer:shapeLayer];
    [v setNeedsDisplay];
    return v;
}

+(UIColor*)sapBlueColor{
    return [UIColor colorWithRed:0/255.0 green:157/255.0 blue:224/255.0 alpha:1];
}

+(UIColor*)sapDarkBlueColor{
    return [UIColor colorWithRed:0/255.0 green:156/255.0 blue:227/255.0 alpha:1];
}
+(UIColor*)sapSkyLightBlueColor{
    return [UIColor colorWithRed:244/255.0 green:249/255.0 blue:252/255.0 alpha:1];
}

+(UIColor*)sapLightBlueColor{
    return [UIColor colorWithRed:150/255.0 green:200/255.0 blue:210/255.0 alpha:1];
}

+(UIColor*)sapMessageTextLightGrayColor{
    return [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
}

+(UIColor*)iOS6messageAppBackgroundColor{
    return [UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1];
}

+(void)setTitle:(NSString *)title inNavigationItem:(UINavigationItem*)navigationItem{
    UIView* titleView = navigationItem.titleView;
    UILabel* titleLabel;
    if (titleView != nil && [titleView isKindOfClass:[UILabel class]]) {
        titleLabel = (UILabel*)titleView;
    } else {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        navigationItem.titleView = titleLabel;
    }
    titleLabel.font = [XYSkinManager instance].navigationBarTitleFont;
    titleLabel.textColor = [XYSkinManager instance].navigationBarTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.backgroundColor = [UIColor clearColor];
}

+(UIView*)sapUI5BackgroundViewWithFrame:(CGRect)frame{
    UIView* v = [[UIView alloc] initWithFrame:frame];
    v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // Background color and shape
    CAGradientLayer* gradient = [CAGradientLayer layer];
    
    CGSize s = CGSizeMake(frame.size.width+frame.size.height, frame.size.width+frame.size.height);
    float lineBorder = 6.0f;
    
    gradient.frame = CGRectMake(0, 0, s.width, s.height);
    
    gradient.colors = @[
                        (id)[XYUtility sapSkyLightBlueColor].CGColor,
                        (id)[XYUtility sapLightBlueColor].CGColor
                        ];
    
    [v.layer insertSublayer:gradient atIndex:0];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (int i = 0; i < s.height/lineBorder; i++) {
        CGPathMoveToPoint(path, NULL, 0, lineBorder*i);
        CGPathAddLineToPoint(path, NULL, lineBorder*i, 0);
    }
    
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    // Need to set to YES to avoid performance issue
    shapeLayer.shouldRasterize = YES;
    [shapeLayer setPath:path];
    [shapeLayer setFillColor:[UIColor whiteColor].CGColor];
    [shapeLayer setStrokeColor:[UIColor whiteColor].CGColor];
    [shapeLayer setBounds:gradient.frame];
    [shapeLayer setAnchorPoint:CGPointMake(0, 0)];
    [shapeLayer setPosition:CGPointMake(0.0f, 0.0f)];
    [v.layer addSublayer:shapeLayer];
    return v;
}

+(UIView*)sapUI5ActivityIndicatorIconWithFrame:(CGRect)frame iconColor:(UIColor*)color backgroundColor:(UIColor*)bgc{

    UIView* v = [[UIView alloc] initWithFrame:frame];
    v.alpha = 1;
    v.backgroundColor = [UIColor clearColor] ;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect b = CGRectZero;
    b.size = frame.size;

    float r = b.size.width/2.0;
    float r2 = r * 3/5.0;
    
    CGPathMoveToPoint(path, NULL, b.origin.x + r, b.origin.y);
    CGPathAddArcToPoint(path, NULL, b.origin.x + b.size.width, b.origin.y, b.origin.x + b.size.width, b.origin.y + r, r);
    CGPathAddArcToPoint(path, NULL, b.origin.x + b.size.width, b.origin.y + b.size.height, b.origin.x + r, b.origin.y + b.size.height, r);
    
    float x = ((2-sqrt(2))/2.0)*r;
    CGPoint p1 = CGPointMake(b.origin.x+2*x, b.origin.y+b.size.height);
    CGPoint p2 = CGPointMake(b.origin.x+x, b.origin.y+2*r-x);
    CGPathAddArcToPoint(path, NULL, p1.x, p1.y, p2.x, p2.y, r);
    
    x = sqrt(2)*(r-r2)/2.0;
    p2.x +=x;
    p2.y -=x;
    CGPathAddLineToPoint(path, NULL, p2.x, p2.y);
    
    x = ((2-sqrt(2))/2.0)*r2;
    p2.x +=x;
    p2.y +=x;
    
    p1 = CGPointMake(b.origin.x+r, b.origin.y+r+r2);
    
    CGPathAddArcToPoint(path, NULL, p2.x, p2.y, p1.x, p1.y, r2);
    
    p1.x += r2;
    
    p2 = p1;
    p2.y -= r2;
    CGPathAddArcToPoint(path, NULL, p1.x, p1.y, p2.x, p2.y, r2);
    
    p1 = p2;
    p1.y -= r2;
    p2.x = b.origin.x + r;
    p2.y = b.origin.y + (r-r2);
    
    CGPathAddArcToPoint(path, NULL, p1.x, p1.y, p2.x, p2.y, r2);
    
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:path];
    [shapeLayer setFillColor:color.CGColor];
    [shapeLayer setStrokeColor:color.CGColor];
    [shapeLayer setBounds:v.bounds];
    [shapeLayer setAnchorPoint:CGPointMake(0, 0)];
    [shapeLayer setPosition:CGPointMake(0, 0)];
    [v.layer addSublayer:shapeLayer];
    return v;
}

+(CGSize)currentScreenSize{
    CGSize s = [UIScreen mainScreen].bounds.size;
    UIApplication* application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(application.statusBarOrientation)) {
        s = CGSizeMake(s.height, s.width);
    }
//    if (!application.statusBarHidden) {
//        s.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
//    }
    return s;
}

+(CAGradientLayer*)blueGradientLayer{
    CAGradientLayer* gradient = [CAGradientLayer layer];
    
    //Blue
    gradient.colors = @[
                        (id)[UIColor colorWithRed:0/255.0 green:139/255.0 blue:217/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:0/255.0 green:121/255.0 blue:188/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:0/255.0 green:106/255.0 blue:166/255.0 alpha:1].CGColor
                        ];
    
    return gradient;
    
    
    
    

}
+(CAGradientLayer*)redGradientLayer{
    CAGradientLayer* gradient = [CAGradientLayer layer];
    // Red
    gradient.colors = @[
                        (id)[UIColor colorWithRed:226/255.0 green:27/255.0 blue:27/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:198/255.0 green:24/255.0 blue:24/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:181/255.0 green:22/255.0 blue:22/255.0 alpha:1].CGColor
                        ];
    return gradient;
}
+(CAGradientLayer*)greenGradientLayer{
    CAGradientLayer* gradient = [CAGradientLayer layer];
    // Green
    gradient.colors = @[
                        (id)[UIColor colorWithRed:0/255.0 green:145/255.0 blue:61/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:0/255.0 green:114/255.0 blue:48/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:0/255.0 green:95/255.0 blue:40/255.0 alpha:1].CGColor
                        ];
    return gradient;
}
+(CAGradientLayer*)orangeGradientLayer{
    CAGradientLayer* gradient = [CAGradientLayer layer];
    // Orange
    gradient.colors = @[
                        (id)[UIColor colorWithRed:234/255.0 green:81/255.0 blue:0/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:201/255.0 green:70/255.0 blue:0/255.0 alpha:1].CGColor,
                        (id)[UIColor colorWithRed:184/255.0 green:64/255.0 blue:0/255.0 alpha:1].CGColor
                        ];
    return gradient;
}

+(UIView*)mainWindowView{
    UIWindow* w = [[UIApplication sharedApplication] keyWindow];
    if (w.subviews.count > 0) {
        return [w.subviews objectAtIndex:0];
    } else {
        return w;
    }
}

+(NSString*)fetchSSIDInfo
{
    NSString* ssid = @"";
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if ([info isKindOfClass:[NSDictionary class]]) {
            ssid = [((NSDictionary*)info) objectForKey:@"SSID"];
        }
        if (info && [info count]) {
            break;
        }
    }
    return ssid;
}

+(BOOL)checkReachableForHost:(NSString*)host{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithName(NULL,[host cStringUsingEncoding:NSASCIIStringEncoding]);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}


+(NSString*)identitySummary:(SecIdentityRef)identity {
    SecCertificateRef certificate = NULL;
    if(SecIdentityCopyCertificate(identity,&certificate)==noErr&&certificate!=NULL) {
        CFStringRef certificateSummary = SecCertificateCopySubjectSummary(certificate);
        if(certificateSummary!=NULL) {
            NSString *summary = (__bridge NSString*)certificateSummary;
            CFRelease(certificateSummary);
            return summary;
        } else return nil;
    } else return nil;
}

+(SecIdentityRef)identityWithData:(NSData*)data usingPassphrase:(NSString*)passphrase {
    if (data == nil) {
        return nil;
    }
    const void *keys[]={kSecImportExportPassphrase},*values[]={(__bridge CFStringRef)passphrase};
    CFDictionaryRef options = CFDictionaryCreate(NULL,keys,values,1,NULL,NULL);
    CFArrayRef items = CFArrayCreate(NULL,0,0,NULL);
    OSStatus error = SecPKCS12Import((__bridge CFDataRef)data,options,&items);
    if(error!=noErr) { CFRelease(options); CFRelease(items); return NULL; }
    
    CFDictionaryRef identityAndTrust = CFArrayGetValueAtIndex(items,0);
    SecTrustRef trust = (SecTrustRef)CFDictionaryGetValue(identityAndTrust,kSecImportItemTrust);
    SecIdentityRef identity = (SecIdentityRef)CFDictionaryGetValue(identityAndTrust,kSecImportItemIdentity);
    CFRetain(trust); CFRetain(identity); CFRelease(options); CFRelease(items);
    
    /*SecTrustResultType result;
     if(SecTrustEvaluate(trust,&result)!=noErr||result==kSecTrustResultRecoverableTrustFailure) { CFRelease(trust); CFRelease(identity); return NULL; }*/
    
    CFRelease(trust);
    return identity;
}


+(NSString*)macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+(NSString*)uniqueDeviceName{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    if(!bundleIdentifier) bundleIdentifier = @"com.sap.ags.xy.mdf";
    return [NSString stringWithFormat:@"%@__%@",[XYUtility macaddress],bundleIdentifier];
}

+(NSString*)uniqueDeviceIdentifier{
    return [XYUtility stringFromMD5:[XYUtility uniqueDeviceName]];
}

+(NSString*)uniqueGlobalDeviceName{
    return [XYUtility macaddress];
}

+(NSString*)uniqueGlobalDeviceIdentifier{
    return [XYUtility stringFromMD5:[XYUtility uniqueGlobalDeviceName]];
}

+(NSString*)stringFromMD5:(NSString*)md5string{
    
    if(self == nil || [md5string length] == 0)
        return nil;
    
    const char *value = [md5string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+(BOOL)isVersion:(NSString*)version olderThan:(NSString*)newVersion{
    NSArray *newComponents = [newVersion componentsSeparatedByString:@"."],*components = [version componentsSeparatedByString:@"."];
    for(NSUInteger index=0;index<[newComponents count];index++) {
        if(index>=[components count]) return YES; //new 1.1.1 compared to this app 1.1
        NSInteger component = [[components objectAtIndex:index] integerValue],newComponent = [[newComponents objectAtIndex:index] integerValue];
        if(newComponent>component) return YES; //new 1.2 compared to this app 1.1
        else if(newComponent<component) return NO;  //new 1.0 compared to this app 1.1
    }
    return NO; //new 1.1 compared to this app 1.1, or new 1 compared to this app 1.1
}

+(BOOL)isMDFAppInstalled:(NSString*)appid{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:[@"mdf-%@://" stringByAppendingString:@"test"],[appid lowercaseString]]]];
}

+(NSString*)convertMethod:(XYRequestMethod)method {
    switch(method) {
        case XYRequestMethodGet:     return @"GET";
        case XYRequestMethodPost:    return @"POST";
        case XYRequestMethodHead:    return @"HEAD";
        case XYRequestMethodPut:     return @"PUT";
        case XYRequestMethodDelete:  return @"DELETE";
        case XYRequestMethodTrace:   return @"TRACE";
        case XYRequestMethodOptions: return @"OPTIONS";
        case XYRequestMethodConnect: return @"CONNECT";
        case XYRequestMethodPatch:   return @"PATCH";
        default: return nil;
    }
}

+(NSURL*)parseURL:(NSURL*)url withQuery:(NSDictionary*)parameters {
    NSString *query = [XYUtility concatenateQuery:parameters];
    NSURL* result = query?[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",[url absoluteString],[url query]?@"&":@"?",query]]:url;
    return result;
}

+(NSString*)concatenateQuery:(NSDictionary*)parameters {
    if(parameters == nil || [parameters count]==0) {
        return nil;
    }
    NSMutableString *query = [NSMutableString string];
    for(NSString *parameter in [parameters allKeys])
        [query appendFormat:@"&%@=%@",[parameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[[parameters valueForKey:parameter] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    return [query substringFromIndex:1];
}

+(NSDictionary*)splitQuery:(NSString*)query {
    if(query == nil||[query length]==0) {
        return nil;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    for(NSString *parameter in [query componentsSeparatedByString:@"&"]) {
        NSRange range = [parameter rangeOfString:@"="];
        if(range.location!=NSNotFound)
            [parameters setValue:[[parameter substringFromIndex:range.location+range.length] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] forKey:[[parameter substringToIndex:range.location] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        else [parameters setValue:[[NSString alloc] init] forKey:[parameter stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    }
    return parameters;
}

+(NSString*)stringEncryptedByMD5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *string = [NSString stringWithFormat:
                        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                        result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
                        ];
    return [string lowercaseString];
}


+(NSString*)encrypt:(NSString*)plainText key:(NSString *)key initVect:(NSString *)iv{
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@ --> %@",plainText, data);
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [iv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
//                       kCCOptionPKCS7Padding | kCCOptionECBMode,
//                       kCCOptionPKCS,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    NSString* tmp = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    NSLog(@"--> %@ enrypted string[%@]",myData, tmp);
    
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return result;
}


+(NSString*)decrypt:(NSString*)encryptText key:(NSString *)key initVect:(NSString *)iv{
    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString* tmp = [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
    NSLog(@"%@ base64 string[%@]",encryptData, tmp);
    
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [iv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
//                       kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    return result;
}

+(NSString*)deviceString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithFormat:@"%@[%@]",[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding],[UIDevice currentDevice].systemVersion ];
    
    //    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    //    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    //    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    //    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    //    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    //    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    //    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    //    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    //    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    //    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    //    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    //    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    //    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    //    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    //    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    //    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    //    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    //    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

//+(NSString*)urlQueryStringFromParametersWithEncoding:(NSDictionary*)parameters encoding:(NSStringEncoding) stringEncoding{
//    NSMutableArray *mutablePairs = [NSMutableArray array];
//    NSArray* array = [XYUtility getQueryStringPairsFromKeyAndValue:nil value:parameters];
//    for (AFQueryStringPair *pair in array) {
//        [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:stringEncoding]];
//    }
//    
//    return [mutablePairs componentsJoinedByString:@"&"];
//}


//+(NSArray*)getQueryStringPairsFromKeyAndValue:(NSString*)key value:(id)value{
//    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
//    
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
//    
//    if ([value isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *dictionary = value;
//        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
//        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
//            id nestedValue = [dictionary objectForKey:nestedKey];
//            if (nestedValue) {
//                [mutableQueryStringComponents addObjectsFromArray:[XYUtility getQueryStringPairsFromKeyAndValue:key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey value:nestedValue]];
//                
////                AFQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)
//            }
//        }
//    } else if ([value isKindOfClass:[NSArray class]]) {
//        NSArray *array = value;
//        for (id nestedValue in array) {
//            [mutableQueryStringComponents addObjectsFromArray:[XYUtility getQueryStringPairsFromKeyAndValue:[NSString stringWithFormat:@"%@[]",value] value:nestedValue]];
//        }
//    } else if ([value isKindOfClass:[NSSet class]]) {
//        NSSet *set = value;
//        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
//            [mutableQueryStringComponents addObjectsFromArray:[XYUtility getQueryStringPairsFromKeyAndValue:key value:obj]];
//        }
//    } else {
//        [mutableQueryStringComponents addObject:[[AFQueryStringPair alloc] initWithField:key value:value]];
//    }
//    
//    return mutableQueryStringComponents;
//}

+(UIColor*)randomColor{
    float r = rand() % 256;
    float g = rand() % 256;
    float b = rand() % 256;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

+(NSString*)appVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
@end