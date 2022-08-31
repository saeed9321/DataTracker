//
//  Tracker.h
//  
//
//  Created by Said Al Mujaini on 7/14/22.
//

#import <Foundation/Foundation.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <ifaddrs.h>
#import <dlfcn.h>
#import <net/if_var.h>
#import <mach/mach.h>

NS_ASSUME_NONNULL_BEGIN

extern float oldCellSent;
extern float oldCellReceived;

extern float savedCellSent;
extern float savedCellReceived;

extern float cellUploadSpeed;
extern float cellDownloadSpeed;

extern float cellUsage;

@interface Tracker : NSObject

+ (instancetype)shared;

- (void)start;
- (void)getDataUsage;
- (void)clearAllSavedUsage;
- (float)getDiffFrom:(float)old and:(float)new;

- (float)getRemainingData;
- (float)getTotalDataLimit;
- (long)getRemainingDays;
- (long)getTotalPeriodDays;

- (void)saveValue:(id)value forKey:(NSString *)key;
- (id)getValueForKey:(NSString *)key;

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;


@end

NS_ASSUME_NONNULL_END
