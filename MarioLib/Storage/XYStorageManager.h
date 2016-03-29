//
//  XYStorageManager.h
//  XYStorageManager
//
//  Created by Xu Xiaoye on 4/1/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MDF/MDF.h"
//#import "XYFavoriteCustomerItem.h"
#import "XYUtility.h"
#import "XYBaseErrorCenter.h"
#import "XYUIDesign.h"
//#import "XYBaseSearchEngine.h"
//#import "XYLoginContext.h"

/**
 This class handle all storage related stuff
 All methods are static
 */
@interface XYStorageManager : NSObject

/**
  Save array list by MDFStorage object
  Each object in list will be mapped to a dictionary
 */
+(void)saveArrayData:(NSArray*) array nameAs:(NSString*) name;

/**
  Read list data by MDFStorage object
  The list data is stored as JSONValue and will be converted into NSArray
  Each dictionary object in the list will be converted into class passed
 */
+(NSArray*)readArrayDataOfClass:(Class) objClass byName:(NSString*)name;

/**
  Return full file path based on document directory
 */
+(NSString*)fullDocumentDirectoryFilePath:(NSString*) fileName;

/**
  Save NSDictionary object to a file in JSON format
 */
+(void)saveDictionary:(NSDictionary*)dict toFile:(NSString*) file;

/**
  Read JSONValue from a file and convert to NSDictionary
 */
+(NSDictionary*)readDictionaryFromFile:(NSString*) file;

/**
  Write string into local file
 */
+(BOOL)write:(NSString *) content toFile:(NSString *) fileName cover:(BOOL) isCover;

/**
  Read string from local file
 */
+(NSString *)readFromFile:(NSString *) fileName;

/**
  NSKeyedArchiver archiveRootObject
 */
+(BOOL)writeArchiveData:(id)obj toFile:(NSString*) fileName;

/**
  NSKeyedUnarchiver unarchiveObjectWithFile
 */
+(id)readArchivedDataFromFile:(NSString*)fileName;

/**
  Delete file
 */
+(void)deleteFile:(NSString*)fileName;


/**
  Check whether file exists
 */
+(BOOL)existsFile:(NSString*)fileName;

/**
  Save searchEntity into NSUserDefault
  Notice: The searchEntity class must implemented NSCoding protocal
  category                       alias       value
  savedSearch<EntityType1>        My search1  <SearchEntity class>
  savedSearch<EntityType1>        My search2  <SearchEntity class>
  savedSearch<EntityType2>        My search1  <SearchEntity class>
 
 */
//+(void)addSavedSearch:(XYBaseSearchEntity*)searchEntity asAlias:(NSString*)alias forCategory:(NSString*)category;

/**
  Get saved searchEntity by category and alias name
 */
//+(XYBaseSearchEntity*)getSavedSearchByAlias:(NSString*)alias forCategory:(NSString*)category;

/**
  Remove saved search by alias name
 */
+(void)deleteSavedSearchByAlias:(NSString*)alias forCategory:(NSString*)category;

/**
  Get saved search list
 */
+(NSDictionary*)getSavedSearchByCategory:(NSString*)category;

@end
