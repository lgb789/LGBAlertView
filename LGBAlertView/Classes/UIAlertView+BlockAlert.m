//
//  UIAlertView+BlockAlert.m
//  Pods
//
//  Created by mac_256 on 2017/8/24.
//
//

#import "UIAlertView+BlockAlert.h"
#import <objc/runtime.h>

@implementation UIAlertView (BlockAlert)

+(instancetype)showWithTitle:(NSString *)title
                     message:(NSString *)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
                    tapBlock:(UIAlertViewCompleteBlock)tapBlock
{
    return [self showWithTitle:title message:message style:UIAlertViewStyleDefault cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles tapBlock:tapBlock];
}

+(instancetype)showWithTitle:(NSString *)title
                     message:(NSString *)message
                       style:(UIAlertViewStyle)style
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
                    tapBlock:(UIAlertViewCompleteBlock)tapBlock
{
    NSString *firstStr = otherButtonTitles.count ? otherButtonTitles[0] : nil;
    UIAlertView *alert = [[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:firstStr, nil];
    [alert setAlertViewStyle:style];
    
    if (otherButtonTitles.count > 1) {
        for (NSString *title in [otherButtonTitles subarrayWithRange:NSMakeRange(1, otherButtonTitles.count - 1)]) {
            [alert addButtonWithTitle:title];
        }
    }
    
    if (tapBlock) {
        alert.tapBlock = tapBlock;
    }
    
    return alert;
}

-(void)_checkAlertDelegate
{
    if (self.delegate != self) {
        self.delegate = self;
    }
}

-(void)setTapBlock:(UIAlertViewCompleteBlock)tapBlock
{
    [self _checkAlertDelegate];
    objc_setAssociatedObject(self, _cmd, tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertViewCompleteBlock tapBlock = objc_getAssociatedObject(self, @selector(setTapBlock:));
    if (tapBlock) {
        tapBlock(self, buttonIndex);
    }
}

@end





























