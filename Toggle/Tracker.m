//
//  Tracker.m
//  
//
//  Created by Said Al Mujaini on 7/14/22.
//

#import "Tracker.h"

// Global vars
float oldCellSent = 0;
float oldCellReceived = 0;

float savedCellSent = 0;
float savedCellReceived = 0;

float cellUploadSpeed = 0;
float cellDownloadSpeed = 0;

float cellUsage = 0;

///
BOOL firstRun = YES;

NSString *PLIST_PATH = @"/var/mobile/Library/Preferences/SDATA.plist";


@implementation Tracker

+ (instancetype)shared{
    static Tracker *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Tracker alloc] init];
    });
    return sharedInstance;
}

- (void)start {
    
    float timeSinceLastBoot = (float)mach_absolute_time();
    float savedLastBootTime = [[self getValueForKey:@"boot_time"] floatValue];
    if(timeSinceLastBoot != savedLastBootTime){
        firstRun = YES;
        [self saveValue:[NSNumber numberWithFloat:timeSinceLastBoot] forKey:@"boot_time"];
    }
    
    
    // Fetch saved value if any - after sbreload
    if(savedCellSent == 0){
        if([self getValueForKey:@"saved_cell_sent"]){
            savedCellSent = [[self getValueForKey:@"saved_cell_sent"] floatValue];
        }
    }
    if(savedCellReceived == 0){
        if([self getValueForKey:@"saved_cell_received"]){
            savedCellReceived = [[self getValueForKey:@"saved_cell_received"] floatValue];
        }
    }
    if(cellUsage == 0){
        if([self getValueForKey:@"cell_usage"]){
            cellUsage = [[self getValueForKey:@"cell_usage"] floatValue];
        }
    }
    
    // Keep updating Cell usage
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self getDataUsage];
    }];
    
}

- (void)getDataUsage{
    
    float cell_sent = 0;
    float cell_received = 0;
    
    struct ifaddrs *cursor = nil;

    if(getifaddrs(&cursor) == 0){
        while (cursor != NULL) {
            if(cursor->ifa_addr->sa_family == AF_LINK){
                const struct if_data *network = (const struct if_data*) cursor->ifa_data;
                if([[NSString stringWithUTF8String:cursor->ifa_name] hasPrefix:@"pdp_ip"]){
                    cell_sent += network->ifi_obytes;
                    cell_received += network->ifi_ibytes;
                }
            }
            cursor = cursor->ifa_next;
        }
    }
    freeifaddrs(cursor);
    
    // Exception for first run
    if(firstRun){
        oldCellSent = cell_sent;
        oldCellReceived = cell_received;
        firstRun = NO;
    }


    // Current scan
    cellUploadSpeed = [self getDiffFrom:oldCellSent and:cell_sent];
    cellDownloadSpeed = [self getDiffFrom:oldCellReceived and:cell_received];
    
    
    // Get Total since last reset
    savedCellSent += oldCellSent + cellUploadSpeed;
    savedCellReceived += oldCellReceived + cellDownloadSpeed;
    
    
    // Prep for next
    oldCellSent = cell_sent;
    oldCellReceived = cell_received;
    
    // General values
    cellUsage += cellUploadSpeed + cellDownloadSpeed;
    
    // Save to Plist
    [self saveValue:[NSNumber numberWithFloat:savedCellSent] forKey:@"saved_cell_sent"];
    [self saveValue:[NSNumber numberWithFloat:savedCellReceived] forKey:@"saved_cell_received"];
    [self saveValue:[NSNumber numberWithFloat:cellUsage] forKey:@"cell_usage"];

    return;
}

- (void) clearAllSavedUsage{
    firstRun = YES;
    
    savedCellSent = 0;
    savedCellReceived = 0;
    cellUsage = 0;
    
    [[NSFileManager defaultManager] removeItemAtPath:PLIST_PATH error:nil];

    NSLog(@"Saved Data cleared !!");
}

- (float)getDiffFrom:(float)old and:(float)new{
    float ret;
    
    if(new < old){ // This would mean the actual value of more than the max value of an unsigned int (u_int32_t) 
        NSLog(@"overflow detected %f - %f", old ,new);
        unsigned int maxVal = 0xFFFFFFFF;
        unsigned int short_from_old = maxVal - old;
        ret = new + short_from_old;
    }else{
        ret = new - old;
    }
    return ret;
}

- (float)getRemainingData{
    
    BOOL isGB = NO;
    if([[self getValueForKey:@"did_select_GB"] isEqual:@YES]){
        isGB = YES;
    }else{
        isGB = NO;
    }
    
    NSNumber *data_limit = [self getValueForKey:@"data_limit"];
    float remaining = 0; 
   
    if(isGB){
        remaining = [data_limit floatValue] - (cellUsage / 0x40000000);
    }else{
        remaining = [data_limit floatValue] - (cellUsage / 0x100000);
    }
    
    if(remaining < 0){
        remaining = 0;
    }
    
    return remaining;

}

- (float)getTotalDataLimit{
    return [[self getValueForKey:@"data_limit"] floatValue];
}

- (long)getRemainingDays{
    
    NSDate *start_date = [self getValueForKey:@"period_start_date"];
    if(start_date == nil){
        start_date = [NSDate now];
    }
    NSDate *end_date = [self getValueForKey:@"period_end_date"];
    if(end_date == nil){
        end_date = [NSDate now];
    }
    
    long remain_days = 0;
    if([self daysBetweenDate:[NSDate now] andDate:start_date] > 0){
        remain_days = [self daysBetweenDate:start_date andDate:end_date];
    }else{
        remain_days = [self daysBetweenDate:[NSDate now] andDate:end_date];
    }
    
    // [self saveValue:[NSNumber numberWithLong:remain_days] forKey:@"remaining_days"];
    return remain_days;
}

- (long)getTotalPeriodDays{
    NSDate *end_date = [self getValueForKey:@"period_end_date"];
    if(end_date == nil){
        end_date = [NSDate now];
    }
    NSDate *start_date = [self getValueForKey:@"period_start_date"];
    if(start_date == nil){
        start_date = [NSDate now];
    }
    return [self daysBetweenDate:start_date andDate:end_date];
}

- (void)saveValue:(id)value forKey:(NSString *)key{
    
    NSMutableDictionary *savedData = nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:PLIST_PATH]){
        savedData = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
    }else{
        savedData = [[NSMutableDictionary alloc] init];
    }
    
    [savedData setValue:value forKey:key];
    [savedData writeToFile:PLIST_PATH atomically:YES];
}

- (id)getValueForKey:(NSString *)key{
    if([[NSFileManager defaultManager] fileExistsAtPath:PLIST_PATH]){
        NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
        return [savedData valueForKey:key];
    }
    
    return nil;
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime{
    NSDate *fromDate;
    NSDate *toDate;

    NSCalendar *calendar = [NSCalendar currentCalendar];

    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
        interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
        interval:NULL forDate:toDateTime];

    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
        fromDate:fromDate toDate:toDate options:0];

    return [difference day];
}

@end
