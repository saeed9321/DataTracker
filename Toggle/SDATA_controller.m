#import "SDATA_controller.h"


@implementation SDATA_controller


-(void)viewDidLoad{
    [super viewDidLoad];
    
    //calculate expanded size:
    _preferredExpandedContentWidth = [UIScreen mainScreen].bounds.size.width * 0.92;
    _preferredExpandedContentHeight = _preferredExpandedContentWidth * 1.25;
    
    if(!_tracker){
        _tracker = [Tracker new];
        [_tracker start];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self layoutCollapsed];

}

-(instancetype)initWithNibName:(NSString*)name bundle:(NSBundle*)bundle{
    self = [super initWithNibName:name bundle:bundle];
    if (self)
    {
        _settingsButton  = [[SettingsButton  alloc] initWithGlyphImage:[UIImage imageNamed:@"Settings" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] highlightColor:[UIColor clearColor] useLightStyle:YES];
        _settingsButton.labelsVisible = NO;
        _settingsButton.toggleStateOnTap = YES;
        [self addChildViewController:_settingsButton];
                
        [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if(_expanded){
                [self layoutExpanded];
            }else{
                [self layoutCollapsed];
            }
        }];
	}
    return self;
}

-(CAShapeLayer*)getLayerWithCenter:(CGPoint)center radius:(CGFloat)radius width:(CGFloat)width percentage:(CGFloat)percentage andColor:(CGColorRef)color{
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    percentage = 1 - percentage;
    if(percentage == 1.0) { percentage = 0.99; };
    [bezierPath addArcWithCenter:center radius:radius startAngle:-(M_PI/2) endAngle:(-(M_PI/2) + percentage*M_PI*2) clockwise:NO];

    CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
    [progressLayer setPath:bezierPath.CGPath];
    [progressLayer setStrokeColor:color];
    [progressLayer setFillColor:[UIColor clearColor].CGColor];
    [progressLayer setLineWidth:width];
    [progressLayer setLineCap:kCALineCapRound];
    return progressLayer;
}

- (void)clearAllSubviews{
    for(UIView *v in self.view.subviews){
        [v removeFromSuperview];
    }
}

-(void)layoutCollapsed{
    [self clearAllSubviews];
    CGSize size = self.view.frame.size;
    
    _pd_guage = [[PDGuageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) smallSize:YES];
    [self.view addSubview:_pd_guage];
    
}

-(void)layoutExpanded{

    [self clearAllSubviews];
    CGSize size = self.view.frame.size;
    
    _ud_view = [[UDStatusView alloc] initWithFrame:CGRectMake(0, 10, size.width, 40)];
    [self.view addSubview:_ud_view];
    
    _pd_guage = [[PDGuageView alloc] initWithFrame:CGRectMake(0, 70, size.width, 200) smallSize:NO];
    [self.view addSubview:_pd_guage];
    
    _pd_status = [[PDStatusView alloc] initWithFrame:CGRectMake(0, 320, size.width, 50)];
    [self.view addSubview:_pd_status];
    
    [_settingsButton.view setFrame:CGRectMake(size.width/2-50, 370, 100, 100)];
    [self.view addSubview:_settingsButton.view];
    
}

-(void)willTransitionToExpandedContentMode:(BOOL)expanded{
    //keep track of the expansion state:
    _expanded = expanded;
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        if (_expanded)
            [self layoutExpanded];
        else
            [self layoutCollapsed];
    } completion:nil];    
}

-(BOOL)_canShowWhileLocked{
	return YES;
}
@end