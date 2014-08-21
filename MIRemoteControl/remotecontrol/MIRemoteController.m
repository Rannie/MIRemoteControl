//
//  JLRemoteController.m
//  Wisetv_2x
//
//  Created by ran on 14-7-23.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import "MIRemoteController.h"
#import "MIGestureManager.h"
#import "UIImage+MIName.h"
#import "UIButton+MIFactory.h"

#define SCREEN_BOUNDS                      ([UIScreen mainScreen].bounds.size)
#define SCREEN_WIDTH                       (SCREEN_BOUNDS.width)
#define SCREEN_HEIGHT                      (SCREEN_BOUNDS.height)

#define LIGHT_DURATION      (0.8)
#define RESULT_DURATION     (1.4)
#define LIGHT_IMG_TAG       (100)
#define RESULT_IMG_TAG      (101)

#define BUTTON_WIDTH        (50)
#define BUTTON_HEIGHT       (40)
#define MARGIN_H            (5)
#define MARGIN_V            (2)

@interface MIRemoteController () <MIGestureManagerDelegate>
{
    MIGestureManager *_gestureManager;
}

@property (nonatomic, strong) UIImageView *maskView;
@property (nonatomic, strong) UIImageView *bottomView;
@property (nonatomic, strong) UIView      *helpPage;
@property (nonatomic, assign) BOOL         allowsInteraction;

@end

@implementation MIRemoteController

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialConfig];
    [self setupBottomView];
    [self setupMaskView];
    [self setupButtons];
    [self loadGestureManager];
    [self setupHelpPage];
}

- (void)initialConfig
{
    self.view.backgroundColor = [UIColor blackColor];
    self.allowsInteraction = YES;
}

- (void)setupBottomView
{
    _bottomView = [[UIImageView alloc] init];
    _bottomView.frame = self.view.bounds;
    _bottomView.userInteractionEnabled = YES;
    _bottomView.image = ImageCache(@"remote_bg");
    [self.view addSubview:_bottomView];
}

- (void)setupMaskView
{
    _maskView = [[UIImageView alloc] init];
    _maskView.frame = self.view.bounds;
    _maskView.userInteractionEnabled = YES;
    _maskView.image = [UIImage mi_imageMatchSizeWithName:@"remote_mask"];
    [self.view addSubview:_maskView];
}

- (void)setupButtons
{
    UIButton *backBtn = [UIButton mi_buttonWithIcon:@"remote_btn_back" pressedIcon:nil target:self action:@selector(onPressBackButton:)];
    backBtn.frame = CGRectMake(MARGIN_H, MARGIN_V, 25, BUTTON_HEIGHT);
    [self.maskView addSubview:backBtn];
    
    UIButton *homeBtn = [UIButton mi_buttonWithIcon:@"remote_btn_home" pressedIcon:@"remote_btn_home_highlight" target:self action:@selector(onPressHomeButton:)];
    homeBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 2*MARGIN_H - BUTTON_WIDTH, MARGIN_V, BUTTON_WIDTH, BUTTON_HEIGHT);
    [self.maskView addSubview:homeBtn];
    
    UIButton *menuBtn = [UIButton mi_buttonWithIcon:@"remote_btn_menu" pressedIcon:@"remote_btn_menu_highlight" target:self action:@selector(onPressMenuButton:)];
    menuBtn.frame = CGRectMake(SCREEN_WIDTH/2 + MARGIN_H, MARGIN_V, BUTTON_WIDTH, BUTTON_HEIGHT);
    [self.maskView addSubview:menuBtn];
    
    UIButton *helpBtn = [UIButton mi_buttonWithIcon:@"remote_btn_help" pressedIcon:nil target:self action:@selector(onPressHelpButton:)];
    helpBtn.frame = CGRectMake(SCREEN_WIDTH - 2*MARGIN_H - BUTTON_WIDTH, MARGIN_V, BUTTON_WIDTH, BUTTON_HEIGHT);
    [self.maskView addSubview:helpBtn];
}

- (void)loadGestureManager
{
    _gestureManager = [MIGestureManager sharedManager];
    _gestureManager.delegate = self;
    [_gestureManager preloadResources];
}

- (void)setupHelpPage
{
    _helpPage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _helpPage.backgroundColor = [UIColor clearColor];
    
    UIImageView *main = [[UIImageView alloc] initWithFrame:_helpPage.frame];
    main.image = [UIImage mi_imageMatchSizeWithName:@"remote_helppage"];
    [_helpPage addSubview:main];
    
    UIButton *closeBtn = [UIButton mi_buttonWithIcon:@"remote_help_closebtn" pressedIcon:@"remote_help_closebtn_highlight" target:self action:@selector(onHelpCloseClicked:)];
    closeBtn.frame = CGRectMake(SCREEN_WIDTH - 55, 10, 40, 30);
    [_helpPage addSubview:closeBtn];
    
    [self.view addSubview:_helpPage];
    _helpPage.hidden = YES;
}

- (void)dealloc
{
    NSLog(@"dealloc remote vc");
    [_gestureManager clearMemory];
}

#pragma mark - Button press
- (void)onPressBackButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onPressHomeButton:(id)sender
{
    NSLog(@"home btn clicked");
}

- (void)onPressMenuButton:(id)sender
{
    NSLog(@"menu btn clicked");
}

- (void)onPressHelpButton:(id)sender
{
    NSLog(@"help btn clicked");
    _helpPage.hidden = NO;
    self.allowsInteraction = NO;
}

- (void)onHelpCloseClicked:(id)sender
{
    _helpPage.hidden = YES;
    self.allowsInteraction = YES;
}

#pragma mark - Action
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.allowsInteraction) return;
    UITouch *touch = [touches anyObject];
    CGPoint start = [touch locationInView:self.view];
    
    [_gestureManager beginMonitorWithPoint:start];
    [self showLightAtPoint:start];
    
    NSLog(@"touch begin");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.allowsInteraction) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    __weak typeof(&*self) weakSelf = self;
    [_gestureManager updateMonitorWithPoint:point action:^{
        [weakSelf showLightAtPoint:point];
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.allowsInteraction) return;
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.allowsInteraction) return;
    [_gestureManager endMonitor];
    
    NSLog(@"touch end");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (!self.allowsInteraction) return;
    if (motion == UIEventSubtypeMotionShake) {
        [_gestureManager endMotion];
    }
}

- (void)gestureManagerMonitorResult:(MonitorResultType)resultType
{
    switch (resultType) {
        case MonitorResultTypeNone:
            NSLog(@"none");
            break;
        case MonitorResultTypeChosen:
        {
            NSLog(@"chosen");
            [self animateChosen];
        }
            break;
        case MonitorResultTypeRight:
            [self showAtCenterWithImageView:_gestureManager.rightImageView];
            NSLog(@"right");
            break;
        case MonitorResultTypeMenu:
            [self showAtCenterWithImageView:_gestureManager.menuImageView];
            NSLog(@"menu");
            break;
        case MonitorResultTypeLeft:
            [self showAtCenterWithImageView:_gestureManager.leftImageView];
            NSLog(@"left");
            break;
        case MonitorResultTypeUpwards:
            [self showAtCenterWithImageView:_gestureManager.upImageView];
            NSLog(@"up");
            break;
        case MonitorResultTypeDownwards:
            [self showAtCenterWithImageView:_gestureManager.downImageView];
            NSLog(@"down");
            break;
        case MonitorResultTypeBack:
            [self showAtCenterWithImageView:_gestureManager.backImageView];
            [self back];
            break;
        case MonitorResultTypeHome:
            [self showAtCenterWithImageView:_gestureManager.homeImageView];
            NSLog(@"home");
            break;
    }
}

#pragma mark - Func callback
- (void)back
{
    NSLog(@"back");
    
}

//......

#pragma mark - Image methods
- (void)showLightAtPoint:(CGPoint)point
{
    [self clearResult];
    
    UIImageView *light = [_gestureManager dequeueReusableImageView];
    light.center = point;
    light.tag = LIGHT_IMG_TAG;
    [self.bottomView addSubview:light];
    
    [UIView animateWithDuration:LIGHT_DURATION animations:^{
        light.alpha = 0.1;
    } completion:^(BOOL finished) {
        [light removeFromSuperview];
        light.alpha = 1.0;
        [_gestureManager enqueueReusableImageView:light];
    }];
}

- (void)showAtCenterWithImageView:(UIImageView *)imageView
{
    [self clearPoints];
    [self clearResult];
    
    imageView.tag = RESULT_IMG_TAG;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        imageView.center = self.view.center;
        [self.maskView addSubview:imageView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([imageView isDescendantOfView:self.maskView]) {
                [imageView removeFromSuperview];
            }
        });
    });
}

- (void)animateChosen
{
    CGPoint point = _gestureManager.lastPoint;
    if (CGRectContainsPoint(CGRectMake(0, 0, SCREEN_WIDTH, 95), point)) return;
    
    UIImageView *chosenImageView = [_gestureManager chosenImageView];
    chosenImageView.center = point;
    [self.maskView addSubview:chosenImageView];
    
    [chosenImageView startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [chosenImageView removeFromSuperview];
    });
}

- (void)clearResult
{
    for (UIView *view in self.maskView.subviews) {
        if (view.tag == RESULT_IMG_TAG && [view isDescendantOfView:self.maskView]) {
            [view removeFromSuperview];
        }
    }
}

- (void)clearPoints
{
    for (UIView *view in self.bottomView.subviews) {
        if (view.tag == LIGHT_IMG_TAG) {
            [view removeFromSuperview];
        }
    }
}

@end
