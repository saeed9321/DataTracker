//
//  PDStatusView.m
//  DeleteME
//
//  Created by Said Al Mujaini on 7/10/22.
//

#import "PDStatusView.h"

@implementation PDStatusView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        CGSize size = frame.size;
        
        UIFont *data_font = [UIFont monospacedSystemFontOfSize:16 weight:UIFontWeightBold];
        UIFont *lbl_font = [UIFont monospacedDigitSystemFontOfSize:14 weight:UIFontWeightBold];
        
        UILabel *remaining_data_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width/2, 20)];
        [remaining_data_lbl setTextAlignment:NSTextAlignmentCenter];
        [remaining_data_lbl setText:@"🔴 Remaining Data"];
        [remaining_data_lbl setFont:lbl_font];
        [remaining_data_lbl setTextColor:[UIColor whiteColor]];
        [self addSubview:remaining_data_lbl];
        
        UILabel *remaining_data = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, size.width/2, 20)];
        [remaining_data setTextAlignment:NSTextAlignmentCenter];
        
        
        BOOL isGB = NO;
        if([[[Tracker shared] getValueForKey:@"did_select_GB"] isEqual:@YES]){
            isGB = YES;
        }else{
            isGB = NO;
        }
        
        
        float remaining = [[Tracker shared] getRemainingData];
                
        [remaining_data setText:[NSString stringWithFormat:@"%.2f %@", remaining, isGB ? @"GB" : @"MB"]];
        [remaining_data setFont:data_font];
        [remaining_data setTextColor:[UIColor systemGreenColor]];
        [self addSubview:remaining_data];
        
        UILabel *remaining_period_lbl = [[UILabel alloc] initWithFrame:CGRectMake(size.width/2, 0, size.width/2, 20)];
        [remaining_period_lbl setTextAlignment:NSTextAlignmentCenter];
        [remaining_period_lbl setText:@"🔵 Remaining Period"];
        [remaining_period_lbl setFont:lbl_font];
        [remaining_period_lbl setTextColor:[UIColor whiteColor]];
        [self addSubview:remaining_period_lbl];
        
        UILabel *remaining_period = [[UILabel alloc] initWithFrame:CGRectMake(size.width/2, 25, size.width/2, 20)];
        [remaining_period setTextAlignment:NSTextAlignmentCenter];
        
        long days_left = [[Tracker shared] getRemainingDays];
        if(!days_left || days_left < 0){
            days_left = 0;
        }
        
        [remaining_period setText:[NSString stringWithFormat:@"%ld days", days_left]];
        [remaining_period setFont:data_font];
        [remaining_period setTextColor:[UIColor systemGreenColor]];
        [self addSubview:remaining_period];
        

    }
    return self;
}


@end

