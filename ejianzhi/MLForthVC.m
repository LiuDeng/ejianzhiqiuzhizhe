//
//  MLForthVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLForthVC.h"
#import "SRLoginVC.h"
#import "MLJobListViewController.h"
#import "MyApplicationList.h"
#import "MLLoginManger.h"
#import "MLResumePreviewVC.h"
#import "MyFavorVC.h"
#import "settingVC.h"
#import "ResumeVC.h"
#import "MLTextUtils.h"

#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "UIImageView+EMWebCache.h"
#import "AppDelegate.h"

#import "MLTabbarVC.h"

#import "feedbackVC.h"
#import "StudentCertifyViewController.h"

#define  PIC_WIDTH 80
#define  PIC_HEIGHT 80

@interface MLForthVC ()<finishLogin,UIAlertViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    BOOL pushing;
    BOOL imagePickerPushing;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIButton *certifyButton;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *headView;

//登录控制器
@property (weak,nonatomic) MLLoginManger *loginManager;

@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
//@property (strong, nonatomic) IBOutlet UIImageView *userAvatarView;
@property (nonatomic, strong) UIImageView *userAvatarView;
@end

@implementation MLForthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatAvuserImage];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.loginManager=[MLLoginManger shareInstance];
    
    pushing=NO;
    imagePickerPushing=NO;
    
    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAvatar)];
    tapGesture.delegate=self;
    [self.userAvatarView addGestureRecognizer:tapGesture];
    self.userAvatarView.userInteractionEnabled=YES;
    
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 247/255.0, 79/255.0, 92/255.0, 1.0 });
}

- (void)creatAvuserImage{
    self.userAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH-80)/2, 30, 80, 80)];
    self.userAvatarView.image = [UIImage imageNamed:@"placeholder"];
    [self.headView addSubview:self.userAvatarView];
    [self.userAvatarView.layer setCornerRadius:40.0f];
    [self.userAvatarView.layer setMasksToBounds:YES];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAvatar)];
    tapGesture.delegate=self;
    [self.userAvatarView addGestureRecognizer:tapGesture];
    self.userAvatarView.userInteractionEnabled=YES;


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (pushing) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
        pushing=NO;
    }
}

- (void)viewDidAppear:(BOOL)animated{
   [super viewDidAppear:animated];
    int validate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userIsValidate"] intValue];
    if (validate == 1)
    {
        [self.certifyButton setTitle:@"已认证" forState:UIControlStateNormal];
        self.certifyButton.enabled = NO;
    }
    else if (validate == 0)
    {
        [self.certifyButton setTitle:@"未认证" forState:UIControlStateNormal];
        self.certifyButton.enabled = YES;
    }
    else if (validate == 2)
    {
        [self.certifyButton setTitle:@"审核中" forState:UIControlStateNormal];
        self.certifyButton.enabled = NO;
    }
    if ([AVUser currentUser]==nil) {
        MLTabbarVC *tabbar = [MLTabbarVC shareInstance];
        [tabbar.navigationController popViewControllerAnimated:YES];
    }
    
    
    if (!imagePickerPushing) {
        if ([AVUser currentUser]!=nil) {
            [self finishLogin];
        }
        else {
            [self finishLogout];
        }
    }else{
        imagePickerPushing=NO;
    }
}

- (void)chooseAvatar{
    if ([AVUser currentUser]!=nil) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:Nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:Nil
                                      otherButtonTitles:@"从相册选择",@"拍照",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请先登录账户" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==0) {
        if (buttonIndex == 0) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = TRUE;
            [self presentViewController:imagePickerController animated:YES completion:^{
                imagePickerPushing=YES;
            }];
            return;
        }
        if (buttonIndex == 1) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = TRUE;
                [self presentViewController:imagePickerController animated:YES completion:^{
                    imagePickerPushing=YES;
                }];
            }else{
                UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:ALERTVIEW_TITLE message:ALERTVIEW_CAMERAWRONG delegate:nil cancelButtonTitle:ALERTVIEW_KNOWN otherButtonTitles:nil];
                [alterTittle show];
            }
            return;
        }

    }
}

- (IBAction)touchLogin:(id)sender {
    if ([AVUser currentUser]==nil) {
        MLTabbarVC *tabbar=[MLTabbarVC shareInstance];
        [tabbar.navigationController popViewControllerAnimated:YES];
    }
}
#pragma -mark 学生认证
- (IBAction)touchCertify:(id)sender {
    int ishasJianli = [[[NSUserDefaults standardUserDefaults] objectForKey:hasJianLi] intValue];
    if (ishasJianli == 2)
    {
        StudentCertifyViewController *studentCertify=[[StudentCertifyViewController alloc]init];
        studentCertify.title=@"学生认证";
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        studentCertify.hidesBottomBarWhenPushed=YES;
        pushing=YES;
        self.navigationItem.backBarButtonItem=backItem;
        [self.navigationController pushViewController:studentCertify animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您先完善简历再去认证" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}


- (IBAction)logout:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出账户？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==1001) {
        if (buttonIndex==1) {
            NSString *telUrl = @"tel://010-62416324";
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]]; //拨号
            
        }
    }else{
        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
        
        if (buttonIndex==1) {
            BOOL isLogout=[[[SRLoginBusiness alloc]init]logOut];
            if (isLogout) {
                
                MLTabbarVC *tabbar=[MLTabbarVC shareInstance];
                [tabbar.navigationController popViewControllerAnimated:YES];
                [self finishLogout];
            }
        }
    }
}

- (void)finishLogout{
    
    self.buttonLabel.text=@"点击登录";
    self.userAvatarView.image=[UIImage imageNamed:@"placeholder"];
    self.bottomConstraint.constant=-60;
    
}

- (void)finishLogin{
    
    if ([AVUser currentUser]) {
        [self checkUserName];
    }

    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    if ([mySettingData objectForKey:@"userAvatar"]) {
        [self.userAvatarView sd_setImageWithURL:[NSURL URLWithString:[mySettingData objectForKey:@"userAvatar"]]];
    }else{
        AVQuery *userQuery=[AVUser query];
        [userQuery whereKey:@"objectId" equalTo:[AVUser currentUser].objectId];
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if ([objects count]>0) {
                    AVUser *_user=[objects objectAtIndex:0];
                    AVFile *imageFile=[_user objectForKey:@"avatar"];
                    [self.userAvatarView sd_setImageWithURL:[NSURL URLWithString:imageFile.url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                    [mySettingData setObject:imageFile.url forKey:@"userAvatar"];
                    [mySettingData synchronize];
                }
            }
        }];
    }
    
    self.bottomConstraint.constant=0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma --mark  显示简历
- (IBAction)showResumeAction:(id)sender {
    
    if ([AVUser currentUser]) {
        MLResumePreviewVC *previewVC=[[MLResumePreviewVC alloc]init];
        previewVC.hidesBottomBarWhenPushed=YES;
        previewVC.type=1;
        previewVC.userObjectId=[AVUser currentUser].objectId;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        pushing=YES;
        [self.navigationController pushViewController:previewVC animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未登录" message:@"是否现在登录？" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"立即登录",nil];
        [alert show];
    }
}

- (IBAction)showMyApplication:(UIButton *)sender {

    if ([AVUser currentUser]) {
        MyApplicationList *myAppliedJobListVC=[[MyApplicationList alloc]init];
        myAppliedJobListVC.hidesBottomBarWhenPushed=YES;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
        pushing=YES;
        [self.navigationController pushViewController:myAppliedJobListVC animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未登录" message:@"是否现在登录？" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"立即登录",nil];
        [alert show];

    }
}

- (IBAction)showMyFavor:(id)sender {
    
    MyFavorVC *myFavorVC=[[MyFavorVC alloc]init];
    myFavorVC.hidesBottomBarWhenPushed=YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    pushing=YES;
    [self.navigationController pushViewController:myFavorVC animated:YES];
}

- (IBAction)showSettingVC:(id)sender {
    settingVC *setting=[[settingVC alloc]init];
    setting.hidesBottomBarWhenPushed=YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    pushing=YES;
    [self.navigationController pushViewController:setting animated:YES];
}

//图片获取
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    picker = Nil;
    
    [self dismissModalViewControllerAnimated:YES];
    
    self.userAvatarView.image=image;
    
    //上传图片
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    AVFile *imageFile = [AVFile fileWithName:@"AvatarImage" data:imageData];
   
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            if (imageFile.url != Nil) {
                AVQuery *query=[AVUser query];
                [query whereKey:@"objectId" equalTo:[AVUser currentUser].objectId];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    [MBProgressHUD showError:UPLOADSUCCESS toView:self.view];
                    NSUserDefaults *defaultData=[NSUserDefaults standardUserDefaults];
                    [defaultData setObject:imageFile.url forKey:@"userAvatar"];
                    [defaultData synchronize];
                    
                    AVUser *currentUser=[objects objectAtIndex:0];
                    [currentUser setObject:imageFile forKey:@"avatar"];
                    [currentUser saveEventually];
                    
                    AVQuery *userDetailQuery=[AVQuery queryWithClassName:@"UserDetail"];
                    [userDetailQuery whereKey:@"userObjectId" equalTo:currentUser.objectId];
                    [userDetailQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            if ([objects count]>0) {
                                AVObject *userDetailObject=[objects objectAtIndex:0];
                                NSMutableArray *imageArray=[userDetailObject objectForKey:@"userImageArray"];
                                [imageArray insertObject:imageFile.url atIndex:0];
                                [userDetailObject setObject:imageArray forKey:@"userImageArray"];
                                [userDetailObject saveEventually];
                            }else{
                                AVObject *userDetailObject = [AVObject objectWithClassName:@"UserDetail"];
                                NSMutableArray *imageArray=[[NSMutableArray alloc] initWithObjects:imageFile.url, nil];
                                [userDetailObject setObject:imageArray forKey:@"userImageArray"];
                                [userDetailObject saveEventually];
                            }
                        }
                    }];
                }];

            }else{
                dispatch_async(dispatch_get_main_queue(), ^{

                    [MBProgressHUD showError:UPLOADFAIL toView:self.view];
                });
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD showError:UPLOADFAIL toView:self.view];
            });
        }
        
    } progressBlock:^(NSInteger percentDone) {
       
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picker = Nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)makePhoneCall:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"是否呼叫客服中心？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=1001;
    [alert show];
    
}

- (void)checkUserName{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];

        if ([mySettingData objectForKey:@"userName"]) {
            self.buttonLabel.text=[mySettingData objectForKey:@"userName"];
        }else{
            self.buttonLabel.text = [AVUser currentUser].username;
        }
    
}

- (IBAction)feedback:(id)sender {
    feedbackVC *feedVC=[[feedbackVC alloc]init];
    [self.navigationController pushViewController:feedVC animated:YES];
}



@end
