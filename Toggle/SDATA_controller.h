
#import <UIKit/UIViewController.h>
#import <ControlCenterUIKit/CCUIContentModuleContentViewController.h>
#import <CoreFoundation/CoreFoundation.h>


#import "SettingsButton.h"
#import "../Components/PDGuageView.h"
#import "../Components/PDStatusView.h"
#import "../Components/UDStatusView.h"
#import "Tracker.h"


extern CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);

@interface SDATA_controller : UIViewController <CCUIContentModuleContentViewController>
@property (nonatomic,readonly) CGFloat preferredExpandedContentHeight;
@property (nonatomic,readonly) CGFloat preferredExpandedContentWidth;
@property (nonatomic,readonly) BOOL providesOwnPlatter;
@property (nonatomic, readonly) BOOL expanded;


@property (strong, nonatomic) SettingsButton *settingsButton;
@property (strong, nonatomic) UDStatusView *ud_view;
@property (strong, nonatomic) PDGuageView *pd_guage;
@property (strong, nonatomic) PDStatusView *pd_status;

@property (strong, nonatomic) Tracker *tracker;


-(void)layoutCollapsed;
-(void)layoutExpanded;
@end
