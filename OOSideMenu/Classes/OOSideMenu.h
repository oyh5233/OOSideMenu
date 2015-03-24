//
//  OOSideMenu.h
//  OOSideMenu
//
//  Created by OO on 3/24/15.
//  Copyright (c) 2015 comein. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OOSideMenu;
typedef enum{
    OOSideMenuSideLeft,
    OOSideMenuSideCenter,
    OOSideMenuSideRight
}OOSideMenuSide;
/**
 *  UIViewController category
 */
@interface UIViewController (OOSideMenu)
@property (strong, readonly, nonatomic) OOSideMenu *ooSideMenuViewController;

-(void)setSideMenuSide:(OOSideMenuSide)side;

@end
@interface OOSideMenu : UIViewController
@property(nonatomic,strong)UIViewController *leftViewController;
@property(nonatomic,strong)UIViewController *rightViewController;

/**
 *  setCenterViewController will close side.
 */
@property(nonatomic,strong)UIViewController *centerViewController;

@property(nonatomic,strong,readonly)UIViewController *visibleViewController;

/**
 *   [backgroundImageView setImage:]
 */
@property(nonatomic,strong,readonly)UIImageView *backgroundImageView;

@property(nonatomic,assign)OOSideMenuSide side;

-(instancetype)initWithCenterViewController:(UIViewController*)centerviewController leftViewController:(UIViewController*)leftViewController rightViewController:(UIViewController*)rightViewController;
@end
