//
//  PopoverViewController.m
//  DeleteME
//
//  Created by Said Al Mujaini on 7/12/22.
//

#import "PopoverViewController.h"


@interface PopoverViewController ()

@end

@implementation PopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _calender = [[CalendarView alloc] init];
    [_calender setShouldShowHeaders:YES];
    
    [_calender setCenter:self.view.center];
    
    _calender.calendarDelegate = self;
    
    _calender.currentDate = _showingDate;
    
    [self.view addSubview:_calender];
}


- (void)didChangeCalendarDate:(NSDate *)date withType:(NSInteger)type withEvent:(NSInteger)event{
    if(type == 0 && event == 1){
        
        long diff = (long)[[Tracker shared] daysBetweenDate:[NSDate now] andDate:date];
        if(diff < 0 && !self.isStartDate){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Cannot select past date" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [_calender goToToday];
            }];
            [alert addAction:act];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            if(self.isStartDate){
                [[Tracker shared] saveValue:date forKey:@"period_start_date"];
                [self dismissViewControllerAnimated:YES completion:^{
                    CFNotificationCenterPostNotification(CFNotificationCenterGetLocalCenter(), CFSTR("S-Data_reloadView"), NULL, NULL, kCFNotificationDeliverImmediately);
                }];
            }else{
                NSDate *start_date = [[Tracker shared] getValueForKey:@"period_start_date"];
                if(start_date == nil){
                    start_date = [NSDate now];
                    [[Tracker shared] saveValue:start_date forKey:@"period_start_date"];
                }
                
                long diff = (long)[[Tracker shared] daysBetweenDate:start_date andDate:date];
                if(diff < 0){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Cannot select past date" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *act = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [_calender goToToday];
                    }];
                    [alert addAction:act];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
                [[Tracker shared] saveValue:date forKey:@"period_end_date"];
                [self dismissViewControllerAnimated:YES completion:^{
                    CFNotificationCenterPostNotification(CFNotificationCenterGetLocalCenter(), CFSTR("S-Data_reloadView"), NULL, NULL, kCFNotificationDeliverImmediately);
                }];
            }
        }
    }
}



@end
