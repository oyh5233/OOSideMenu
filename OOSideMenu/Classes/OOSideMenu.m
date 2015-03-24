//
//  OOSideMenu.m
//  OOSideMenu
//
//  Created by OO on 3/24/15.
//  Copyright (c) 2015 comein. All rights reserved.
//

#import "OOSideMenu.h"
@implementation UIViewController (OOSideMenu)
- (OOSideMenu *)ooSideMenuViewController
{
    UIViewController *vCtrl = self.parentViewController;
    while(vCtrl) {
        if ([vCtrl isKindOfClass:[OOSideMenu class]]) {
            return (OOSideMenu *)vCtrl;
        } else if (vCtrl.parentViewController && vCtrl.parentViewController != vCtrl) {
            vCtrl = vCtrl.parentViewController;
        } else {
            vCtrl = nil;
        }
    }
    return nil;
}
-(void)setSideMenuSide:(OOSideMenuSide)side{
    self.ooSideMenuViewController.side=side;
}
@end
#pragma mark -
#pragma mark - custom
static CGFloat side_menu_animation_duration=0.25;
static CGFloat side_menu_center_left_Offset=49;
static CGFloat side_menu_center_right_Offset=64;
static CGFloat side_menu_center_minimum_scale=0.8;
static CGSize  side_menu_center_shadow_offset=(CGSize){0,0};
static CGFloat side_menu_center_shadow_radius=5;
static CGFloat side_menu_left_mininum_scale=0.8;
static CGFloat side_menu_left_mininum_alpha=0.5;
static CGFloat side_menu_left_parallax=0.15;
static CGFloat side_menu_right_mininum_scale=0.8;
static CGFloat side_menu_rigth_mininum_alpha=0.5;
static CGFloat side_menu_right_parallax=0.15;
@interface OOSideMenu ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIButton *hideButton;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *backgroundImageView;
@property(nonatomic,assign)UIInterfaceOrientation toInterfaceOrientation;
@property(nonatomic,assign)CGFloat extraHeight;
@end

@implementation OOSideMenu
#pragma mark --
#pragma mark --
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"view.frame" context:NULL];
}
-(instancetype)initWithCenterViewController:(UIViewController*)centerViewController leftViewController:(UIViewController*)leftViewController rightViewController:(UIViewController*)rightViewController{
    self =[super init];
    if (self) {
        [self setup];
        self.leftViewController=leftViewController;
        self.rightViewController=rightViewController;
        [self setCenterViewController:centerViewController animal:NO];
    }
    return self;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)awakeFromNib{
    [self setup];
}
-(void)setup{
    _backgroundImageView=[[UIImageView alloc]init];
    _backgroundImageView.contentMode=UIViewContentModeScaleAspectFill;
    _backgroundImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _backgroundImageView.backgroundColor=[UIColor clearColor];
    _scrollView=[[UIScrollView alloc]init];
    _scrollView.backgroundColor=[UIColor clearColor];
    _scrollView.delegate=self;
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.autoresizingMask=UIViewAutoresizingNone;
    _hideButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _hideButton.backgroundColor=[UIColor clearColor];
    _hideButton.autoresizingMask=UIViewAutoresizingNone;
    [_hideButton addTarget:self action:@selector(setSideCenter) forControlEvents:UIControlEventTouchUpInside];
    _hideButton.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _backgroundImageView.frame=self.view.bounds;
    _scrollView.frame=self.view.bounds;
    _scrollView.contentSize=CGSizeMake(CGRectGetWidth(_scrollView.frame)*3, CGRectGetHeight(_scrollView.frame));
    [_scrollView addSubview:_hideButton];
    [self.view addSubview:_backgroundImageView];
    [self.view addSubview:_scrollView];
    [self addObserver:self forKeyPath:@"view.frame" options:NSKeyValueObservingOptionNew context:NULL];
    _toInterfaceOrientation=[UIApplication sharedApplication].statusBarOrientation;
    if (_leftViewController) {
        _leftViewController.view.frame=CGRectMake(0,0,CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    }
    if (_rightViewController) {
        _rightViewController.view.frame=CGRectMake(CGRectGetWidth(_scrollView.frame)*2,0,CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    }
    if (_centerViewController) {
        _centerViewController.view.frame=CGRectMake(CGRectGetWidth(_scrollView.frame),0,CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    }
    _scrollView.contentInset=[self expectedContentInset];
    [self.view addSubview:_scrollView];
    [self setSide:OOSideMenuSideCenter animal:NO];
}
#pragma mark -
#pragma mark - scrollViewContentInset
-(UIEdgeInsets)expectedContentInset{
    CGFloat left=0;
    CGFloat right=0;
    if (!_leftViewController) {
        left=-CGRectGetWidth(_scrollView.frame);
    }
    if (!_rightViewController) {
        right=-CGRectGetWidth(_scrollView.frame);
    }
    return UIEdgeInsetsMake(0, left, 0, right);
}
#pragma mark --
#pragma mark -- setter
-(void)setLeftViewController:(UIViewController *)leftViewController{
    if (_leftViewController!=leftViewController) {
        [self removeViewController:_leftViewController];
        _leftViewController=leftViewController;
        _leftViewController.view.frame=CGRectMake(0,0,CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        [self addViewController:leftViewController];
    }
}
-(void)setRightViewController:(UIViewController *)rightViewController{
    if (_rightViewController!=rightViewController) {
        [self removeViewController:_rightViewController];
        _rightViewController=rightViewController;
        _rightViewController.view.frame=CGRectMake(CGRectGetWidth(_scrollView.frame)*2,0,CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        [self addViewController:rightViewController];
    }
}
-(void)setCenterViewController:(UIViewController *)centerViewController{
    [self setCenterViewController:centerViewController animal:YES];
}
-(void)setCenterViewController:(UIViewController *)centerViewController animal:(BOOL)animal{
    if (_centerViewController!=centerViewController){
        if (animal) {
            [UIView animateWithDuration:side_menu_animation_duration animations:^{
                CGAffineTransform transform=_centerViewController.view.transform;
                transform=CGAffineTransformScale(CGAffineTransformIdentity, transform.a, transform.d);
                _centerViewController.view.transform=transform;
            } completion:^(BOOL finished) {
                [self removeViewController:_centerViewController];
                _centerViewController=centerViewController;
                _centerViewController.view.frame=CGRectMake(CGRectGetWidth(_scrollView.frame),0,CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
                _centerViewController.view.layer.shadowColor=[UIColor blackColor].CGColor;
                _centerViewController.view.layer.shadowOffset=side_menu_center_shadow_offset;
                _centerViewController.view.layer.shadowOpacity=1.0f;
                _centerViewController.view.layer.shadowRadius=side_menu_center_shadow_radius;
                [self addViewController:centerViewController];
                [self setSide:OOSideMenuSideCenter animal:animal];
            }];
        }else{
            CGAffineTransform transform;
            if (_centerViewController) {
                transform=_centerViewController.view.transform;
            }else{
                transform=CGAffineTransformIdentity;
            }
            [self removeViewController:_centerViewController];
            _centerViewController=centerViewController;
            _centerViewController.view.frame=CGRectMake(CGRectGetWidth(_scrollView.frame),0,CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
            _centerViewController.view.layer.shadowColor=[UIColor blackColor].CGColor;
            _centerViewController.view.layer.shadowOffset=side_menu_center_shadow_offset;
            _centerViewController.view.layer.shadowOpacity=1.0f;
            _centerViewController.view.layer.shadowRadius=side_menu_center_shadow_radius;
            _centerViewController.view.transform=transform;
            [self addViewController:centerViewController];
            [self setSide:OOSideMenuSideCenter animal:animal];
        }
    }else{
        [self setSide:OOSideMenuSideCenter animal:animal];
    }
}
-(void)setSide:(OOSideMenuSide)side{
    [self setSide:side animal:YES];
}
-(void)setSide:(OOSideMenuSide)side animal:(BOOL)animal{
    /**
     *  refresh status bar style
     */
    [self setNeedsStatusBarAppearanceUpdate];
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_scrollView.frame)*side, 0) animated:animal];
    [self scrollViewDidScroll:_scrollView];
}
-(void)setSideCenter{
    self.side=OOSideMenuSideCenter;
}
-(UIViewController*)visibleViewController{
    switch (_side) {
        case OOSideMenuSideLeft:
            return _leftViewController;
            break;
        case OOSideMenuSideCenter:
            return _centerViewController;
            break;
        case OOSideMenuSideRight:
            return _rightViewController;
            break;
        default:
            return nil;
            break;
    }
}
#pragma mark -
#pragma mark - childViewController
- (void)removeViewController:(UIViewController *)viewController{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}
- (void)addViewController:(UIViewController *)viewController{
    NSAssert(viewController, @"viewController is nil");
    viewController.view.autoresizingMask=UIViewAutoresizingNone;
    [self addChildViewController:viewController];
    [_scrollView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    [_scrollView bringSubviewToFront:_hideButton];
}
#pragma mark-
#pragma mark sync
-(void)syncSide:(CGPoint)contentOffset{
    CGFloat width;
    if (UIInterfaceOrientationIsLandscape(_toInterfaceOrientation)) {
        width=fmax(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    }else{
        width=fmin(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    }
    if (contentOffset.x<=0) {
        _side=OOSideMenuSideLeft;
    }else if(contentOffset.x>=width*2.0){
        _side=OOSideMenuSideRight;
    }else{
        _side=OOSideMenuSideCenter;
    }
}
-(void)syncHideButtonWithWidth:(CGFloat)width height:(CGFloat)height{
    CGFloat indent=width/fmin(width,height);
    CGRect frame;
    CGFloat buttonWidth;
    switch (_side) {
        case OOSideMenuSideLeft:
            _hideButton.hidden=NO;
            buttonWidth=side_menu_center_left_Offset*indent;
            frame=CGRectMake(width-buttonWidth, 0, buttonWidth, height);
            _hideButton.frame=frame;
            break;
        case OOSideMenuSideCenter:
            _hideButton.hidden=YES;
            break;
        case OOSideMenuSideRight:
            _hideButton.hidden=NO;
            buttonWidth=side_menu_center_right_Offset*indent;
            frame=CGRectMake(width*2, 0, buttonWidth, height);
            _hideButton.frame=frame;
            break;
        default:
            break;
    }
}
-(void)syncCenterViewTransformWithOffset:(CGFloat)offset width:(CGFloat)width minOffset:(CGFloat)minOffset{
    if (offset==0) {
        _centerViewController.view.transform=CGAffineTransformIdentity;
    }else{
        CGFloat indent=width/fmin(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        minOffset=minOffset*indent;
        CGFloat scale=1.0-fabs((1.0-side_menu_center_minimum_scale)*offset);
        CGAffineTransform transform1=CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        CGFloat tran=width*(1.0-scale)/2.0*(offset/fabs(offset))+minOffset*offset;
        CGAffineTransform transform2=CGAffineTransformTranslate(CGAffineTransformIdentity, tran, 0);
        CGAffineTransform transform=CGAffineTransformConcat(transform1, transform2);
        _centerViewController.view.transform=transform;
    }
}
-(void)syncLeftViewTransformWithOffset:(CGFloat)offset width:(CGFloat)width{
    if (offset<=0&&offset>=-1) {
        CGFloat tran=(1.0+offset)/(1.0+side_menu_left_parallax)*width;
        CGAffineTransform transform1=CGAffineTransformTranslate(CGAffineTransformIdentity, tran, 0);
        CGAffineTransform transform2=CGAffineTransformScale(CGAffineTransformIdentity,side_menu_left_mininum_scale+(1.0+offset)*(1.0-side_menu_left_mininum_scale), side_menu_left_mininum_scale+(1.0+offset)*(1.0-side_menu_left_mininum_scale));
        CGAffineTransform transform=CGAffineTransformConcat(transform1, transform2);
        _leftViewController.view.transform=transform;
        _leftViewController.view.alpha=side_menu_left_mininum_alpha+(1.0-side_menu_left_mininum_alpha)*(1.0+offset);
    }
}
-(void)syncRightViewTransformWithOffset:(CGFloat)offset width:(CGFloat)width{
    if (offset>=0&&offset<=1) {
        CGFloat tran=-(1.0-offset)/(1.0+side_menu_right_parallax)*width;
        CGAffineTransform transform1=CGAffineTransformTranslate(CGAffineTransformIdentity, tran, 0);
        CGAffineTransform transform2=CGAffineTransformScale(CGAffineTransformIdentity,side_menu_right_mininum_scale+(1.0-offset)*(1.0-side_menu_right_mininum_scale), side_menu_right_mininum_scale+(1.0-offset)*(1.0-side_menu_right_mininum_scale));
        CGAffineTransform transform=CGAffineTransformConcat(transform1, transform2);
        _rightViewController.view.transform=transform;
        _rightViewController.view.alpha=side_menu_rigth_mininum_alpha+(1-side_menu_rigth_mininum_alpha)*(1.0-offset);
    }
}
#pragma mark-
#pragma mark scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([UIApplication sharedApplication].statusBarOrientation==_toInterfaceOrientation) {
        CGFloat offset=(scrollView.contentOffset.x-CGRectGetWidth(scrollView.frame))/CGRectGetWidth(scrollView.frame);
        CGFloat width;
        CGFloat height;
        if (UIInterfaceOrientationIsLandscape(_toInterfaceOrientation)) {
            width=fmax(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
            height=fmin(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        }else{
            width=fmin(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
            height=fmax(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        }
        [self syncSide:scrollView.contentOffset];
        [self syncHideButtonWithWidth:width height:height];
        CGFloat minOffset=0;
        if (offset<0) {
            minOffset=side_menu_center_left_Offset;
        }else if(offset>0){
            minOffset=side_menu_center_right_Offset;
        }
        [self syncCenterViewTransformWithOffset:offset width:width minOffset:minOffset];
        [self syncLeftViewTransformWithOffset:offset width:width];
        [self syncRightViewTransformWithOffset:offset width:width];
    }
}
#pragma mark -
#pragma mark will rotate
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    _toInterfaceOrientation=toInterfaceOrientation;
    CGFloat width;
    CGFloat height;
    if (UIInterfaceOrientationIsLandscape(_toInterfaceOrientation)) {
        width=fmax(CGRectGetWidth(_scrollView.frame),CGRectGetHeight(_scrollView.frame));
        height=fmin(CGRectGetWidth(_scrollView.frame),CGRectGetHeight(_scrollView.frame));
    }else{
        /**
         *  if orientation is protrait,the statusbar's height will change;
         */
        width=fmin(CGRectGetWidth(_scrollView.frame),CGRectGetHeight(_scrollView.frame));
        height=fmax(CGRectGetWidth(_scrollView.frame),CGRectGetHeight(_scrollView.frame));
        height-=_extraHeight;
    }
    _centerViewController.view.transform=CGAffineTransformIdentity;
    _leftViewController.view.transform=CGAffineTransformIdentity;
    _rightViewController.view.transform=CGAffineTransformIdentity;
    /**
     *  if side is't center,animate~
     */
    if(_side!=OOSideMenuSideCenter){
        _centerViewController.view.hidden=YES;
    }
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _scrollView.frame=CGRectMake(0, 0, width, height);
        _scrollView.contentSize=CGSizeMake(width*3, height);
        _scrollView.contentInset=[self expectedContentInset];
        _scrollView.contentOffset=CGPointMake(width*_side, 0);
        CGRect frame=_centerViewController.view.frame;
        frame.size.width=width;
        frame.size.height=height;
        if (_leftViewController) {
            frame.origin.x=0;
            _leftViewController.view.frame=frame;
        }
        frame.origin.x=width;
        _centerViewController.view.frame=frame;
        if (_rightViewController) {
            
            frame.origin.x=width*2;
            _rightViewController.view.frame=frame;
        }
    } completion:^(BOOL finished) {
        [self syncHideButtonWithWidth:width height:height];
        _centerViewController.view.hidden=NO;
        [UIView animateWithDuration:duration/2.0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self scrollViewDidScroll:_scrollView];
        } completion:NULL];
    }];
}

#pragma mark -
#pragma mark -  adjust left,center,right when self.view.frame change;
-(void)syncViewsForExtra:(CGFloat)extraHeight{
    [self syncView:_leftViewController.view extra:extraHeight];
    [self syncView:_centerViewController.view extra:extraHeight];
    [self syncView:_rightViewController.view extra:extraHeight];
}
-(void)syncView:(UIView*)view extra:(CGFloat)extraHeight{
    CGAffineTransform transform=view.transform;
    view.transform=CGAffineTransformIdentity;
    CGRect frame=view.frame;
    view.transform=transform;
    if (((frame.size.height==[UIScreen mainScreen].bounds.size.height||frame.size.height==[UIScreen mainScreen].bounds.size.width)&&extraHeight<0)||extraHeight>0) {
        frame.size.height+=extraHeight;
        [self setView:view frame:frame];
    }
}
-(void)setView:(UIView *)view frame:(CGRect)frame{
    CGAffineTransform transform=view.transform;
    view.transform=CGAffineTransformIdentity;
    view.frame=frame;
    view.transform=transform;
}
#pragma mark -
#pragma mark observer
/**
 *  statusbar' height will change when iphone received a call,and should layout subviews.
 *
 *  @param extraHeight statusbar's extra-height
 */

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"view.frame"]) {
        CGRect frame=[[change objectForKey:NSKeyValueChangeNewKey]CGRectValue];
        CGFloat height=frame.size.height;
        if (height==[UIScreen mainScreen].bounds.size.width||height==[UIScreen mainScreen].bounds.size.height) {
            [self syncViewsForExtra:_extraHeight];
            _extraHeight=0;
        }else{
            _extraHeight=fmin(fabs([UIScreen mainScreen].bounds.size.width-height), fabs([UIScreen mainScreen].bounds.size.height-height));
            [self syncViewsForExtra:-_extraHeight];
        }
    }
}
#pragma mark -
#pragma mark - viewControllerBasedStatusBar
-(UIViewController*)childViewControllerForStatusBarStyle{
    return [self childViewControllerForStatusBar];
}
-(UIViewController*)childViewControllerForStatusBarHidden{
    return [self childViewControllerForStatusBar];
}
-(UIViewController*)childViewControllerForStatusBar{
    switch (_side) {
        case OOSideMenuSideLeft:
            return _leftViewController;
            break;
        case OOSideMenuSideCenter:
            return _centerViewController;
            break;
        case OOSideMenuSideRight:
            return _rightViewController;
            break;
        default:
            return nil;
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
