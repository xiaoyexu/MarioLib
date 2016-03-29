//
//  XYCoreDataConnector.m
//  XYUIDesignTest
//
//  Created by Xu Xiaoye on 6/14/13.
//  Copyright (c) 2013 XY. All rights reserved.
//

#import "XYCoreDataConnector.h"

@implementation XYCoreDataConnector
@synthesize storeName = _storeName;
@synthesize modelName = _modelName;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}
-(id)initWithModelName:(NSString*)model storeName:(NSString*) name{
    if (self = [super init]) {
        
        @try {
            NSURL* modelURL = [[NSBundle mainBundle] URLForResource:_modelName withExtension:@"momd"];
            if (modelURL == nil) {
                @throw [NSException exceptionWithName:@"ModelNotFound" reason:@"Model file not found!" userInfo:nil];
            }
            _modelName = model;
            _storeName = name;
            
            // Initialize Model
            _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
            //NSLog(@"%@",_managedObjectModel);
            
            // Initialize Store Coordinator
            NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:_storeName];
            
            _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
            
            // Automatic migration
            NSDictionary* optionsDictionary =
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
             NSFileProtectionComplete, NSFileProtectionKey,
             nil];
            
            NSError* error = nil;
            if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
                @throw [NSException exceptionWithName:@"addPersistentStoreWithTypeError" reason:error.description userInfo:nil];
            }
            
            // Initialize Context
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
        }
        @catch (NSException *exception) {
            
            [[XYBaseErrorCenter instance] recordErrorWithTitle:@"XYCoreDataConnector Error" detail:exception.reason level:XYErrorLevelFatal];
            @throw exception;
        }
    }
    return self;
}



-(NSURL*)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//-(NSManagedObjectContext *)managedObjectContext{
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    
//    if (coordinator != nil) {
//        _managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    
//    return _managedObjectContext;
//}

//-(NSManagedObjectModel*)managedObjectModel{
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    
//    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:_modelName withExtension:@"momd"];
//    if (modelURL == nil) {
//        @throw [NSException exceptionWithName:@"ModelNotFound" reason:@"Model file not found!" userInfo:nil];
//    }
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    
//    return _managedObjectModel;
//}


//-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:_storeName];
//    
//    NSError *error = nil;
//    if ([self managedObjectModel] == nil) {
//        return nil;
//    }
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    
//    // Automatic migration
//    NSDictionary* optionsDictionary =
//    [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
//     [NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption,
//     nil];
//    
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
//        @throw [NSException exceptionWithName:@"addPersistentStoreWithTypeError" reason:error.description userInfo:nil];
//    }
//    
//    return _persistentStoreCoordinator;
//}

-(void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    @try {
        if (managedObjectContext != nil) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            }
        }
    }
    @catch (NSException *exception) {
        [[XYBaseErrorCenter instance] recordErrorWithTitle:@"XYCoreDataConnector Error saveContext" detail:[NSString stringWithFormat:@"Reason:%@ Callstack:%@",exception.reason,exception.callStackSymbols] level:XYErrorLevelFatal];
    }
}

-(void)resetPersistentStore{
    //Erase the persistent store from coordinator and also file manager.
    NSPersistentStore *store = [self.persistentStoreCoordinator.persistentStores lastObject];
    if (store == nil) {
        return;
    }
    NSError *error = nil;
    NSURL *storeURL = store.URL;
    [self.persistentStoreCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
    [self persistentStoreCoordinator];
}

-(NSArray*)getObjectsFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameter: (NSString *) predicateParameter{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    
    entity = [NSEntityDescription entityForName:NSStringFromClass(className) inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Form the Predicate
    NSPredicate *predicate = nil;
    if(![predicateString isEqualToString:@""] && predicateParameter!=nil)
    {
        predicate = [NSPredicate predicateWithFormat:
                     predicateString, predicateParameter];
        [fetchRequest setPredicate:predicate];
    }
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

-(NSManagedObject*)getSingleObjectFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameter: (NSString *) predicateParameter{
    NSArray* result = [self getObjectsFromDatabase:className WithPredicate:predicateString AndParameter:predicateParameter];
    if (result != nil && result.count > 0) {
        return [result objectAtIndex:0];
    } else {
        return nil;
    }
}

-(NSArray*)getObjectsFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameterArray: (NSArray *) predicateParameterArr{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    
    entity = [NSEntityDescription entityForName:NSStringFromClass(className) inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Form the Predicate
    NSPredicate *predicate = nil;
    if(![predicateString isEqualToString:@""] && predicateParameterArr!=nil)
    {
        predicate = [NSPredicate predicateWithFormat:predicateString argumentArray:predicateParameterArr];
        [fetchRequest setPredicate:predicate];
    }
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];

}

-(NSManagedObject*)getSingleObjectFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameterArray: (NSArray *) predicateParameterArr{
    NSArray* result = [self getObjectsFromDatabase:className WithPredicate:predicateString AndParameterArray:predicateParameterArr];
    if (result != nil && result.count > 0) {
        return [result objectAtIndex:0];
    } else {
        return nil;
    }
}


-(NSManagedObject*)getNewObjectForInsertByClass:(Class)className{
    return [NSEntityDescription insertNewObjectForEntityForName:[className description] inManagedObjectContext:self.managedObjectContext];
}

@end
