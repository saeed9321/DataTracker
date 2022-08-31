#import "SettingsButton.h"

@implementation SettingsButton
-(void)buttonTapped:(id)arg1{    
    Settings_controller *a = [[Settings_controller alloc] init];
    [self presentViewController:a animated:YES completion:nil];
}

@end
