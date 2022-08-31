//
//  PopoverViewController.h
//  DeleteME
//
//  Created by Said Al Mujaini on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "../Calendar/CalendarView.h"
#import "Tracker.h"

NS_ASSUME_NONNULL_BEGIN


@interface PopoverViewController : UIViewController<CalendarViewDelegate>
@property (strong,nonatomic) CalendarView *calender;
@property (nonatomic) BOOL isStartDate;
@property (nonatomic) NSDate *showingDate;
@end


NS_ASSUME_NONNULL_END
