//
//  PDGuageView.h
//  DeleteME
//
//  Created by Said Al Mujaini on 7/10/22.
//

#import <UIKit/UIKit.h>
#import "../Toggle/Tracker.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDGuageView : UIView

@property (strong, nonatomic) CAShapeLayerLineCap lineCap;
@property (nullable) CGColorRef period_shape_color;
@property (nullable) CGColorRef data_shape_color;
@property (nonatomic) CGFloat period_shape_thickness;
@property (nonatomic) CGFloat data_shape_thickness;

- (instancetype)initWithFrame:(CGRect)frame smallSize:(BOOL) isSmallSize;


@end

NS_ASSUME_NONNULL_END
