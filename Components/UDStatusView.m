//
//  UDStatusView.m
//  DeleteME
//
//  Created by Said Al Mujaini on 7/10/22.
//

#import "UDStatusView.h"


@implementation UDStatusView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        CGSize size = frame.size;
        
        UIFont *data_font = [UIFont monospacedSystemFontOfSize:16 weight:UIFontWeightBold];
        UIFont *lbl_font = [UIFont monospacedDigitSystemFontOfSize:14 weight:UIFontWeightBold];
        
        UILabel *upload_speed_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width/2, 20)];
        [upload_speed_label setTextAlignment:NSTextAlignmentCenter];
        [upload_speed_label setText:@"🔼 Upload"];
        [upload_speed_label setFont:lbl_font];
        [upload_speed_label setTextColor:[UIColor whiteColor]];
        [self addSubview:upload_speed_label];
        
        UILabel *upload_speed = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, size.width/2, 20)];
        [upload_speed setTextAlignment:NSTextAlignmentCenter];
        [upload_speed setText:[NSString stringWithFormat:@"%.1f KB", (cellUploadSpeed / 0x400)]];
        [upload_speed setFont:data_font];
        [upload_speed setTextColor:[UIColor systemPurpleColor]];
        [self addSubview:upload_speed];
        
        UILabel *download_speed_label = [[UILabel alloc] initWithFrame:CGRectMake(size.width/2, 0, size.width/2, 20)];
        [download_speed_label setTextAlignment:NSTextAlignmentCenter];
        [download_speed_label setText:@"🔽 Download"];
        [download_speed_label setFont:lbl_font];
        [download_speed_label setTextColor:[UIColor whiteColor]];
        [self addSubview:download_speed_label];
        
        UILabel *download_speed = [[UILabel alloc] initWithFrame:CGRectMake(size.width/2, 25, size.width/2, 20)];
        [download_speed setTextAlignment:NSTextAlignmentCenter];
        [download_speed setText:[NSString stringWithFormat:@"%.1f KB", (cellDownloadSpeed / 0x400)]];
        [download_speed setFont:data_font];
        [download_speed setTextColor:[UIColor systemOrangeColor]];
        [self addSubview:download_speed];
        
    }
    return self;
}


@end
