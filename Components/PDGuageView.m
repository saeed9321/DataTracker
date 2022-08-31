//
//  PDGuageView.m
//  DeleteME
//
//  Created by Said Al Mujaini on 7/10/22.
//

#import "PDGuageView.h"


@implementation PDGuageView


- (CAShapeLayer*)getLayerWithCenter:(CGPoint)center radius:(CGFloat)radius width:(CGFloat)width percentage:(CGFloat)percentage andColor:(CGColorRef)color{
    if(percentage == 1){
        percentage = 0.999999;
    }
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    percentage = 1 - percentage;
    [bezierPath addArcWithCenter:center radius:radius startAngle:-(M_PI/2) endAngle:(-(M_PI/2) + percentage*M_PI*2) clockwise:NO];

    CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
    [progressLayer setPath:bezierPath.CGPath];
    [progressLayer setStrokeColor:color];
    [progressLayer setFillColor:[UIColor clearColor].CGColor];
    [progressLayer setLineWidth:width];
    [progressLayer setLineCap:self.lineCap];
    return progressLayer;
}


- (instancetype)initWithFrame:(CGRect)frame smallSize:(BOOL)isSmallSize{
    self = [super initWithFrame:frame];
    

    
    float remaining = [[Tracker shared] getRemainingData];
    float data_limit = [[Tracker shared] getTotalDataLimit];
    float data_percentage_n = remaining / data_limit;
    if(data_percentage_n < 0 || data_limit == 0){
        data_percentage_n = 0;
    }
    

    long remain_days = [[Tracker shared] getRemainingDays];
    long period_days = [[Tracker shared] getTotalPeriodDays];
    float period_percentage_n = ((float)remain_days / (float)period_days);
    if(period_percentage_n < 0 || period_days == 0){
        period_percentage_n = 0;
    }
    
        
            
    // Get User prefered settings
    self.lineCap = kCALineCapButt;
    self.period_shape_color = [UIColor systemBlueColor].CGColor;
    self.data_shape_color = [UIColor systemRedColor].CGColor;

    if(self){
        
        CGSize size = frame.size;
        
        if(isSmallSize){
            CAShapeLayer *data_shape = [self getLayerWithCenter:CGPointMake(size.width/2, size.height/2) radius:60 width:30 percentage:data_percentage_n andColor:self.data_shape_color];
            CAShapeLayer *period_shape = [self getLayerWithCenter:CGPointMake(size.width/2, size.height/2) radius:30 width:30 percentage:period_percentage_n andColor:self.period_shape_color];
            
            [self.layer addSublayer:data_shape];
            [self.layer addSublayer:period_shape];
        }else{
                
            CAShapeLayer *data_shape = [self getLayerWithCenter:CGPointMake(size.width/2, 105) radius:100 width:50 percentage:data_percentage_n andColor:self.data_shape_color];
            CAShapeLayer *period_shape = [self getLayerWithCenter:CGPointMake(size.width/2, 105) radius:50 width:50 percentage:period_percentage_n andColor:self.period_shape_color];
            
            [self.layer addSublayer:data_shape];
            [self.layer addSublayer:period_shape];
            
            UILabel *data_percentage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 20)];
            [data_percentage  setTextAlignment:NSTextAlignmentCenter];
            NSString *b = [NSString stringWithFormat:@"%.0f%%", data_percentage_n*100];
            [data_percentage  setText:b];
            [data_percentage  setTextColor:[UIColor whiteColor]];
            [data_percentage  setFont:[UIFont systemFontOfSize:18 weight:bold]];
            [self addSubview:data_percentage];
            
            
            UILabel *period_percentage = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, size.width, 20)];
            [period_percentage  setTextAlignment:NSTextAlignmentCenter];
            NSString *a = [NSString stringWithFormat:@"%.0f%%", period_percentage_n*100];
            [period_percentage  setText:a];
            [period_percentage  setTextColor:[UIColor whiteColor]];
            [period_percentage  setFont:[UIFont systemFontOfSize:18 weight:bold]];
            [self addSubview:period_percentage];
        }
    }
    return self;
}

@end
