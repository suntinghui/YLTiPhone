//
//  SignViewController.h
//  YLTiPhone
//
//  Created by xushuang on 13-12-30.
//  Copyright (c) 2013年 xushuang. All rights reserved.
//

#import "AbstractViewController.h"
#import "HandSignPanel.h"
#import "InputTextField.h"
#import "PaintMaskView.h"

@interface SignViewController : UIViewController<UITextFieldDelegate>
{
	CGPoint myBeganpoint;
	CGPoint myMovepoint;
}

@property (nonatomic, strong) IBOutlet UILabel *amountLabel;
@property (nonatomic, strong) HandSignPanel *signPanel;
@property (nonatomic, weak )id <AbstractViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextField *phoneNumTF;
@property (nonatomic, strong) PaintMaskView *painCanvasView;


-(IBAction)myPalttealllineclear;
-(IBAction)close:(id)sender;
-(IBAction)backBUttonAction:(id)sender;

@end
