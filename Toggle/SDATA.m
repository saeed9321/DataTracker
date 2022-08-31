#import "SDATA.h"

typedef struct CCUILayoutSize {
	unsigned long long width;
	unsigned long long height;
} CCUILayoutSize;


@implementation SDATA
//override the init to initialize the contentViewController (and the backgroundViewController if you have one)
-(instancetype)init{
    if ((self = [super init])){
         _contentViewController = [[SDATA_controller alloc] init];
    }
    return self;
}

-(CCUILayoutSize)moduleSizeForOrientation:(int)orientation{
    return (CCUILayoutSize){2, 2};
}


@end
