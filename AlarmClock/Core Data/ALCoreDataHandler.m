//
//  ALCoreDataHandler.m
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-05.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "ALCoreDataHandler.h"

#import "utils.h"

@implementation ALCoreDataHandler

//------------------------------------------------------------------------------
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AlarmClock" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AlarmClock.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}


//------------------------------------------------------------------------------
#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


//------------------------------------------------------------------------------
#pragma mark - Public Methods

- (NSMutableArray *)getAlarms {
    NSLog(@"[NOTICE] Performing getAlarms Method Started");
    
    NSArray *managedObjects = [self getManagedObjectsFromEntity:@"Alarm"];
    
    NSMutableArray *alarmArray = [[NSMutableArray alloc] initWithCapacity:managedObjects.count];
    for (NSManagedObject *object in managedObjects) {
        ALAlarm *alarm = [[ALAlarm alloc] initWithId:[object.objectID URIRepresentation] enabled:[[object valueForKey:@"enabled"] boolValue] message:[object valueForKey:@"message"] repeat:stringToArray([object valueForKey:@"repeat"]) time:[object valueForKey:@"time"]];
        [alarmArray addObject:alarm];
    }
    
    NSLog(@"[NOTICE] Performing getAlarms Method Finished");
    return alarmArray;
}

- (void)insertAlarm:(ALAlarm *)alarm withCompletion:(ALCompletionBlock)completion {
    NSLog(@"[NOTICE] Performing insertAlarmWithCompletion Method Started");
    
    NSManagedObject *object;
    
    if (alarm.id) {
        object = [self getManagedObjectFromEntity:@"Alarm" id:alarm.id];
        
        if (!object) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Alarm does not exist."};
            NSError *error = [[NSError alloc] initWithDomain:@"ALCoreDataHandler Domain" code:404 userInfo:userInfo];
            completion(error);
            return;
        }
        NSLog(@"            Updating Existing Data");
    } else {
        object = [NSEntityDescription insertNewObjectForEntityForName:@"Alarm" inManagedObjectContext:self.managedObjectContext];
        NSLog(@"            Creating New Data");
    }
    
    [object setValue:alarm.message forKey:@"message"];
    [object setValue:@(alarm.enabled) forKey:@"enabled"];
    [object setValue:arrayToString(alarm.repeat) forKey:@"repeat"];
    [object setValue:alarm.time forKey:@"time"];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
    
    NSLog(@"[NOTICE] Performing insertAlarmWithCompletion Method Finished");
    completion(error);
}

- (void)deleteAlarm:(ALAlarm *)alarm withCompletion:(ALCompletionBlock)completion {
    NSLog(@"[NOTICE] Performing deleteAlarmWithCompletion Method Started");
    
    NSManagedObject *object = [self getManagedObjectFromEntity:@"Alarm" id:alarm.id];
    
    if (!object) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Alarm does not exist."};
        NSError *error = [[NSError alloc] initWithDomain:@"ALCoreDataHandler Domain" code:404 userInfo:userInfo];
        completion(error);
        return;
    }
    
    NSLog(@"            Deleting Existing Data");
    
    [self.managedObjectContext deleteObject:object];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
    
    NSLog(@"[NOTICE] Performing deleteAlarmWithCompletion Method Finished");
    completion(error);
}


//------------------------------------------------------------------------------
#pragma mark - Private Methods

- (NSManagedObject *)getManagedObjectFromEntity:(NSString *)entityName id:(NSURL *)objectId {
    NSArray *managedObjects = [self getManagedObjectsFromEntity:entityName];
    NSManagedObject *object;
    BOOL objectFound = NO;
    
    for (object in managedObjects) {
        if ([[object.objectID URIRepresentation] isEqual:objectId]) {
            objectFound = YES;
            break;
        }
    }
    
    if (!objectFound) {
        return nil;
    }

    return object;
}

- (NSArray *)getManagedObjectsFromEntity:(NSString *)entityName {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext: self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (result == nil) {
        NSLog(@"[ERROR] getAlarms Method: %@", error);
    }

    return result;
}

@end
