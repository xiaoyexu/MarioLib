//
//  XYStorageManager.m
//  XYStorageManager
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYStorageManager.h"

@implementation XYStorageManager

//+(void)saveArrayData:(NSArray*) array nameAs:(NSString*) name{
//    
//    NSMutableArray* saveArray = [NSMutableArray new];
//    for (id obj in array) {
//        [saveArray addObject:[XYUtility objectToDictionary:obj]];
//    }
//    
//    if ([XYLoginContext instance].logonStyle == XYLogonStyleCustomized) {
//        [[XYLoginContext instance] setAttributeValue:[saveArray JSONRepresentation] withName:name scope:MDFScopeGroup];
//        return;
//    }
//    
//    if ([MDFFramework instance].logon != nil) {
//        MDFStorage* storage = [[MDFFramework instance] storage];
//        [storage setValue:[saveArray JSONRepresentation] forAttributeWithName:name inScope:MDFScopeGroup];
//        [storage synchronize];
//    }
//}


//+(NSArray*)readArrayDataOfClass:(Class) objClass byName:(NSString*)name{
//    
//    if ([XYLoginContext instance].logonStyle == XYLogonStyleCustomized) {
//        
//        NSString* value = [[XYLoginContext instance] attributeValueWithName:name scope:MDFScopeGroup];
//        
//        NSMutableArray* result = [value JSONValue];
//        NSMutableArray *resultList = [NSMutableArray new];
//        for (NSDictionary* dict in result) {
//            id obj = [XYUtility dictionaryToObject:dict forClass:objClass];
//            if (obj != nil) {
//                [resultList addObject:obj];
//            }
//        }
//        return resultList;
//    }
//
//    if ([MDFFramework instance].logon != nil) {
//        
//        // Data from MDF storage
//        MDFStorage* storage = [[MDFFramework instance] storage];
//        MDFAttribute* attribute = (MDFAttribute*)[storage attributeWithName:name inScope:MDFScopeGroup];
//        
//        NSMutableArray* result = [attribute.value JSONValue];
//        NSMutableArray *resultList = [NSMutableArray new];
//        for (NSDictionary* dict in result) {
//            id obj = [XYUtility dictionaryToObject:dict forClass:objClass];
//            if (obj != nil) {
//                [resultList addObject:obj];
//            }
//        }
//        return resultList; 
//    } else {
//        return nil;
//    }
//}

+(NSString*)fullDocumentDirectoryFilePath:(NSString*) fileName{
    NSString *filePath = [[NSString alloc]init];
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    return filePath;
}

+(void)saveDictionary:(NSDictionary*)dict toFile:(NSString*) file{
    NSString* data = [dict JSONRepresentation];
    [XYStorageManager write:data toFile:file cover:YES];
}

+(NSDictionary*)readDictionaryFromFile:(NSString*) file{
    NSString* data = [XYStorageManager readFromFile:file];
    if (data != nil) {
        return (NSDictionary*)[data JSONValue];
    }
    return nil;
}

+(BOOL)write:(NSString *) content toFile:(NSString *) fileName cover:(BOOL) isCover{
    NSString *filePath = [XYStorageManager fullDocumentDirectoryFilePath:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    BOOL isWrittenSuccessful = NO;
    
    if ([fm fileExistsAtPath:filePath]) {
        NSData *fileData = [fm contentsAtPath:filePath];
        if(!fileData || isCover){
            [content writeToFile:filePath atomically:YES
                        encoding:NSUTF8StringEncoding error:nil];
            isWrittenSuccessful = YES;
        }else {
            NSFileHandle *fh = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
            [fh seekToEndOfFile];
            [fh writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
            [fh closeFile];
            isWrittenSuccessful = YES;
        }
    }else {
        [fm createFileAtPath:filePath contents:[content dataUsingEncoding:NSUTF8StringEncoding]
                  attributes:nil];
        [content writeToFile:filePath atomically:YES
                    encoding:NSUTF8StringEncoding error:nil];
        isWrittenSuccessful = YES;
    }
    return isWrittenSuccessful;
}



+(NSString *)readFromFile:(NSString *) fileName{
    NSString *filePath = [XYStorageManager fullDocumentDirectoryFilePath:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSData *fileData = [fm contentsAtPath:filePath];
    NSString *fileContent;
    if(!fileData)
        fileContent = nil;
    else {
        fileContent =
        [[NSString alloc]initWithData:fileData encoding:NSUTF8StringEncoding];
    }
    return fileContent;
}


+(BOOL)writeArchiveData:(id)obj toFile:(NSString*) fileName{
    NSString* filePath = [XYStorageManager fullDocumentDirectoryFilePath:fileName];
    return [NSKeyedArchiver archiveRootObject:obj toFile:filePath];
}


+(id)readArchivedDataFromFile:(NSString*)fileName{
    NSString* filePath = [XYStorageManager fullDocumentDirectoryFilePath:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+(void)deleteFile:(NSString*)fileName{
   NSString *filePath = [XYStorageManager fullDocumentDirectoryFilePath:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath] && [fm isDeletableFileAtPath:filePath]) {
        NSError* error;
        BOOL success = [fm removeItemAtPath:filePath error:&error];
        if (!success) {
            [[XYBaseErrorCenter instance] recordErrorWithTitle:@"XYStorageManager delete file error" detail:[NSString stringWithFormat:@"Delete %@ failed with error %@",fileName,error.localizedDescription] level:XYErrorLevelHigh];
        }
    }
}

+(BOOL)existsFile:(NSString*)fileName{
    NSString *filePath = [XYStorageManager fullDocumentDirectoryFilePath:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:filePath];
}

//+(void)addSavedSearch:(XYBaseSearchEntity*)searchEntity asAlias:(NSString*)alias forCategory:(NSString*)category{
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString* categoryKey = [NSString stringWithFormat:@"savedSearch%@",category];
//    NSMutableDictionary* savedSearchDic = [NSMutableDictionary dictionaryWithDictionary:[userDefaults dictionaryForKey:categoryKey]];
//    if (savedSearchDic == nil) {
//        savedSearchDic = [NSMutableDictionary new];
//    }
//    
//    [savedSearchDic setObject:[NSKeyedArchiver archivedDataWithRootObject:searchEntity] forKey:alias];
//    
//    
//    NSMutableDictionary *appDefaults = [[NSMutableDictionary alloc] init];
//    [appDefaults setValue:savedSearchDic forKey:categoryKey];
//    [userDefaults registerDefaults:appDefaults];
//    // In case key is available
//    [userDefaults setValue:savedSearchDic forKey:categoryKey];
//    [userDefaults synchronize];
//}

//+(XYBaseSearchEntity*)getSavedSearchByAlias:(NSString*)alias forCategory:(NSString*)category{
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString* categoryKey = [NSString stringWithFormat:@"savedSearch%@",category];
//    NSMutableDictionary* savedSearchDic = [NSMutableDictionary dictionaryWithDictionary:[userDefaults dictionaryForKey:categoryKey]];
//    
//    return [NSKeyedUnarchiver unarchiveObjectWithData:[savedSearchDic objectForKey:alias]];
//}

+(void)deleteSavedSearchByAlias:(NSString*)alias forCategory:(NSString*)category{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* categoryKey = [NSString stringWithFormat:@"savedSearch%@",category];
    NSMutableDictionary* savedSearchDic = [NSMutableDictionary dictionaryWithDictionary:[userDefaults dictionaryForKey:categoryKey]];
    if (savedSearchDic == nil) {
        return;
    }
    
    [savedSearchDic removeObjectForKey:alias];
    
    NSMutableDictionary *appDefaults = [[NSMutableDictionary alloc] init];
    [appDefaults setValue:savedSearchDic forKey:categoryKey];
    [userDefaults registerDefaults:appDefaults];
    // In case key is available
    [userDefaults setValue:savedSearchDic forKey:categoryKey];
    [userDefaults synchronize];
}

+(NSDictionary*)getSavedSearchByCategory:(NSString*)category{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* categoryKey = [NSString stringWithFormat:@"savedSearch%@",category];
   return [userDefaults dictionaryForKey:categoryKey];
}
@end
