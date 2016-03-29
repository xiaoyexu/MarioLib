//
//  XYCoreDataConnector.h
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 6/14/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XYBaseErrorCenter.h"

/**
 This class represents a connector to read write coredata objects
 */
@interface XYCoreDataConnector : NSObject
{
    NSString* _modelName;
    NSString* _storeName;
}

/**
 Store file name. E.g somefile.sqlite
 Do not include any path in store name
*/
@property (nonatomic,readonly) NSString* storeName;

/**
 The xcdatamodeld name, without extension
 */
@property (nonatomic,readonly) NSString* modelName;

@property (nonatomic, readonly) NSPersistentStoreCoordinator*persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext*managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectModel*managedObjectModel;

/**
 Initialization method
 */
-(id)init;

/**
 Initialization method with model and file name
 @param model Model name
 @param name Store file name
 */
-(id)initWithModelName:(NSString*)model storeName:(NSString*) name;

/**
 @return document directory
 */
-(NSURL*)applicationDocumentsDirectory;

/**
 Method to save context for entities
 */
-(void)saveContext;

/**
 Method to reset data file
 */
-(void)resetPersistentStore;

/**
 Get list of entity by predicater, allow only one parameter
 */
-(NSArray*) getObjectsFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameter: (NSString*) predicateParameter;

/**
 Get single one entity by predicater, with one parameter
 */
-(NSManagedObject*)getSingleObjectFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameter: (NSString *) predicateParameter;

/**
 Get list of entity by predicater with multiply parameters
 */
-(NSArray*) getObjectsFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameterArray: (NSArray *) predicateParameterArr;

/**
 Get single one entity by predicater with multiply parameters
 */
-(NSManagedObject*)getSingleObjectFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameterArray: (NSArray *) predicateParameterArr;

/**
 Get new entity
 */
-(NSManagedObject*)getNewObjectForInsertByClass:(Class)className;
@end
