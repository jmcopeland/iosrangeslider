//
//  RangeSlider.h
//  RangeSlider
//

#import <UIKit/UIKit.h>

@interface RangeSlider : UIControl{
    float minimumValue;
    float maximumValue;
    float minimumRange;
    float selectedMinimumValue;
    float selectedMaximumValue;

    float _padding;
    
    BOOL _maxThumbOn;
    BOOL _minThumbOn;
    
    UIImageView * _minThumb;
    UIImageView * _maxThumb;
    UIImageView * _track;
    UIImageView * _trackBackground;
}

@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;
@property(nonatomic) float minimumRange;
@property(nonatomic) float selectedMinimumValue;
@property(nonatomic) float selectedMaximumValue;

- (void) reset;
- (void) setMinRating:(CGFloat)minRating maxRating:(CGFloat)maxRating;

@end
