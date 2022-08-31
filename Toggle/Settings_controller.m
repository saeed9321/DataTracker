//
//  Settings_controller.m
//  DeleteME
//
//  Created by Said Al Mujaini on 7/12/22.
//

#import "Settings_controller.h"


Settings_controller *thisViewController = nil;
NSDate *end_date = nil;
NSDate *start_date = nil;

@interface Settings_controller ()

@end

@implementation Settings_controller

void reloadTableView(CFNotificationCenterRef center,
                             void * observer,
                             CFStringRef name,
                             const void * object,
                             CFDictionaryRef userInfo){
    [thisViewController.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setTableFooterView:[UIView new]];
    
    self.bgColor = [UIColor whiteColor];
    [self.tableView setBackgroundColor:self.bgColor];
    
    thisViewController = self;
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, reloadTableView, CFSTR("S-Data_reloadView"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    if([[[Tracker shared] getValueForKey:@"did_select_GB"] isEqual:@YES]){
        self.isGB = YES;
    }else{
        self.isGB = NO;
    }
    
    self.inputDataLimit = [[Tracker shared] getTotalDataLimit];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 0;
    }
    if(section == 1){
        return 4;
    }
    if(section == 2){
        return 3;
    }
    if(section == 3){
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 100;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *v = [UIView new];

        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        [lbl setText:@"Data Tracker"];
        [lbl setFont:[UIFont monospacedSystemFontOfSize:26 weight:bold]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [v addSubview:lbl];
        return v;
    }
    return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return @"Cellular Internet Service";
    }
    if(section == 2){
        return @"Current Data Usage";
    }
    if(section == 3){
        return @"Actions";
    }
    return @"";
}

# pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            [cell.textLabel setText:@"Set Data Type"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", self.isGB ? @"GB" : @"MB"]];
        
        }
        
        if(indexPath.row == 1){
            [cell.textLabel setText:@"Set Data Limit"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld %@", self.inputDataLimit, self.isGB ? @"GB" : @"MB"]];

        }
        
        if(indexPath.row == 2){
            start_date = [[Tracker shared] getValueForKey:@"period_start_date"];
            if(start_date == nil){
                start_date = [NSDate now];
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd MMM yyyy"];
            NSString *start_date_string = [formatter stringFromDate:start_date];
            [cell.textLabel setText:@"Set Start Date"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", start_date_string]];
        }
        
        if(indexPath.row == 3){
            end_date = [[Tracker shared] getValueForKey:@"period_end_date"];
            if(end_date == nil){
                end_date = [NSDate now];
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd MMM yyyy"];
            NSString *end_date_string = [formatter stringFromDate:end_date];
            [cell.textLabel setText:@"Set Expiry Date"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", end_date_string]];
        }
    }
    
    if(indexPath.section == 2){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        // Get remaining Data
        float remaining = [[Tracker shared] getRemainingData];
        
        // Get remaining Days
        long remain_days = [[Tracker shared] getRemainingDays];
        
        if(indexPath.row == 0){
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.textLabel setText:@"Used Data"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.2f %@", self.isGB ? (cellUsage / 0x40000000) : (cellUsage /0x100000) , self.isGB ? @"GB" : @"MB"]];
        }
        if(indexPath.row == 1){
            [cell.textLabel setText:@"Remaining Data"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.2f %@", remaining, self.isGB ? @"GB" : @"MB"]];
        }
        if(indexPath.row == 2){
            [cell.textLabel setText:@"Remaining Days"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld days", remain_days]];
        }
    }
    
    if(indexPath.section == 3){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

        if(indexPath.row == 0){
            [cell.textLabel setText:@"Reset"];
            [cell.detailTextLabel setText:@"This will clear all data usage and start fresh"];
        }
    }
    
    [cell setBackgroundColor:self.bgColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

#pragma mark - didSelect
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            UIAlertController *isGBAlert = [UIAlertController alertControllerWithTitle:@"" message:@"Select Data Type" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *gb = [UIAlertAction actionWithTitle:@"GB" style:normal handler:^(UIAlertAction * _Nonnull action) {
                    self.isGB = YES;
                    [[Tracker shared] saveValue:@YES forKey:@"did_select_GB"];
                    cellUsage = 0;
                    [self.tableView reloadData];
            }];
            UIAlertAction *mb = [UIAlertAction actionWithTitle:@"MB" style:normal handler:^(UIAlertAction * _Nonnull action) {
                    self.isGB = NO;
                    [[Tracker shared] saveValue:@NO forKey:@"did_select_GB"];
                    cellUsage = 0;
                    [self.tableView reloadData];
            }];
            
            [isGBAlert addAction:gb];
            [isGBAlert addAction:mb];
            
            [self presentViewController:isGBAlert animated:YES completion:nil];
        }
        
        if(indexPath.row == 1){
            UIAlertController *data_limit_alert = [UIAlertController alertControllerWithTitle:@"" message:@"Set Data Limit" preferredStyle:UIAlertControllerStyleAlert];
            
            [data_limit_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                [textField setPlaceholder:@"Enter # of GB, MB, ..."];
                textField.delegate = self;
            }];
            
            UIAlertAction *ok_action = [UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.inputDataLimit = [data_limit_alert.textFields[0].text longLongValue];
                    [[Tracker shared] saveValue:[NSNumber numberWithLong:self.inputDataLimit] forKey:@"data_limit"];
                    [self.tableView reloadData];
            }];
            UIAlertAction *cancel_action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
         
            [data_limit_alert addAction:ok_action];
            [data_limit_alert addAction:cancel_action];
            
            [self presentViewController:data_limit_alert animated:YES completion:nil];
        }
        
        if(indexPath.row == 2){
            PopoverViewController *vc = [PopoverViewController new];
            vc.isStartDate = YES;
            vc.showingDate = [[Tracker shared] getValueForKey:@"period_start_date"];
            [self presentViewController:vc animated:YES completion:nil];
        }
        
        if(indexPath.row == 3){
            PopoverViewController *vc = [PopoverViewController new];
            vc.isStartDate = NO;
            vc.showingDate = [[Tracker shared] getValueForKey:@"period_end_date"];
            [self presentViewController:vc animated:YES completion:nil];
        }
        
    }
    if(indexPath.section == 2){
        if(indexPath.row == 0){
            UIAlertController *data_usage_alert = [UIAlertController alertControllerWithTitle:@"" message:@"Edit Used Data" preferredStyle:UIAlertControllerStyleAlert];
            
            [data_usage_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                [textField setPlaceholder:@""];
                textField.delegate = self;
            }];
            
            UIAlertAction *ok_action = [UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    float enteredValue = [data_usage_alert.textFields[0].text floatValue];
                    cellUsage = self.isGB ? (enteredValue * 0x40000000) : (enteredValue * 0x100000);
                    [self.tableView reloadData];
            }];
            UIAlertAction *cancel_action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
         
            [data_usage_alert addAction:ok_action];
            [data_usage_alert addAction:cancel_action];
            
            [self presentViewController:data_usage_alert animated:YES completion:nil]; 
        }
    }
    if(indexPath.section == 3){
        
        if(indexPath.row == 0){
            [[Tracker shared] clearAllSavedUsage];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Data Usage reset done !!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *act = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                [self.tableView reloadData];
            }];
            [alert addAction:act];
            [self presentViewController:alert animated:YES completion:nil];

        }
        if(indexPath.row == 1){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (!string.length)
        return YES;

        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
    return YES;
}

@end
