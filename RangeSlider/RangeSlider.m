//
//  RangeSlider.m
//  RangeSlider
//

#import "RangeSlider.h"

@interface RangeSlider (PrivateMethods)
- (float) xForValue:(float)value;
- (float) valueForX:(float)x;
- (void) updateTrackHighlight;
@end

@implementation RangeSlider

@synthesize minimumValue, maximumValue, minimumRange, selectedMinimumValue, selectedMaximumValue;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Set the initial state
        _minThumbOn = false;
        _maxThumbOn = false;
        _padding = 20;
        
        // setup the gray track background
        _trackBackground = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar-background.png"]] autorelease];
        _trackBackground.center = self.center;
        [self addSubview:_trackBackground];
        
        // setup the blue highlight track
        _track = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar-highlight.png"]] autorelease];
        _track.center = self.center;
        [self addSubview:_track];
        
        // setup the left side thumb slider
        _minThumb = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handle.png"] highlightedImage:[UIImage imageNamed:@"handle-hover.png"]] autorelease];
        _minThumb.frame = CGRectMake(0,0, self.frame.size.height,self.frame.size.height);
        _minThumb.contentMode = UIViewContentModeCenter;
		_minThumb.center = CGPointMake([self xForValue:selectedMinimumValue], self.center.y);
		[self addSubview:_minThumb];
        
        // setup the right side thumb slider
        _maxThumb = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handle.png"] highlightedImage:[UIImage imageNamed:@"handle-hover.png"]] autorelease];
        _maxThumb.frame = CGRectMake(0,0, self.frame.size.height,self.frame.size.height);
        _maxThumb.contentMode = UIViewContentModeCenter;
		_maxThumb.center = CGPointMake([self xForValue:selectedMaximumValue], self.center.y);
		[self addSubview:_maxThumb];

        // adjust the blue track highlight to only show between the sliders
        [self updateTrackHighlight];
    }
    return self;
}


- (float) xForValue:(float)value {
    return (self.frame.size.width-(_padding*2))*((value - minimumValue) / (maximumValue - minimumValue))+_padding;
}


- (float) valueForX:(float)x {
    return minimumValue + (x-_padding) / (self.frame.size.width-(_padding*2)) * (maximumValue - minimumValue);
}


- (BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (!_minThumbOn && !_maxThumbOn) {
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    if (_minThumbOn) {
        _minThumb.center = CGPointMake(MAX([self xForValue:minimumValue],MIN(touchPoint.x, [self xForValue:selectedMaximumValue - minimumRange])), _minThumb.center.y);
        selectedMinimumValue = [self valueForX:_minThumb.center.x];
    }
    if (_maxThumbOn) {
        _maxThumb.center = CGPointMake(MIN([self xForValue:maximumValue], MAX(touchPoint.x, [self xForValue:selectedMinimumValue + minimumRange])), _maxThumb.center.y);
        selectedMaximumValue = [self valueForX:_maxThumb.center.x];
    }
    [self updateTrackHighlight];
    [self setNeedsDisplay];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}


- (BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(_minThumb.frame, touchPoint)) {
        _minThumbOn = true;
    } else if(CGRectContainsPoint(_maxThumb.frame, touchPoint)) {
        _maxThumbOn = true;
    }
    return YES;
}


- (void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _minThumbOn = false;
    _maxThumbOn = false;
}

- (void) updateTrackHighlight {
	_track.frame = CGRectMake(
                              _minThumb.center.x,
                              _track.center.y - (_track.frame.size.height/2),
                              _maxThumb.center.x - _minThumb.center.x,
                              _track.frame.size.height
                              );
}

- (void) reset {
    [self setMinRating:minimumValue maxRating:maximumValue];
}

- (void) setMinRating:(CGFloat)minRating maxRating:(CGFloat)maxRating {
    _minThumb.center = CGPointMake([self xForValue:minRating], self.center.y);
    _maxThumb.center = CGPointMake([self xForValue:maxRating], self.center.y);
    self.selectedMinimumValue = minRating;
    self.selectedMaximumValue = maxRating;
    [self updateTrackHighlight];
    [self setNeedsDisplay];    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
