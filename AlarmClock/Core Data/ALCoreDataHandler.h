//
//  ALCoreDataHandler.h
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-05.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "ALAlarm.h"

typedef void(^ALCompletionBlock)(NSError *error);

@interface ALCoreDataHandler : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

- (NSMutableArray *)getAlarms;
- (void)insertAlarm:(ALAlarm *)alarm withCompletion:(ALCompletionBlock)completion;
- (void)deleteAlarm:(ALAlarm *)alarm withCompletion:(ALCompletionBlock)completion;

@end
