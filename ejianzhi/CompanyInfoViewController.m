//
//  CompanyInfoViewController.m
//  ejianzhi
//
//  Created by Mac on 4/29/15.
//  Copyright (c) 2015 Studio Of Spicy Hot. All rights reserved.
//

#import "CompanyInfoViewController.h"
#import "JobOfComListVC.h"
#import "CompanyInfoViewModel.h"
#import "HZAreaPickerView.h"
#import "MLSelectJobTypeVC.h"

@interface CompanyInfoViewController ()<HZAreaPickerDelegate,finishSelectDelegate>
{
    UIView *covervView;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)seeMoreJobAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView1;
@property (weak, nonatomic) IBOutlet UILabel *comTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *comIconView;
@property (weak, nonatomic) IBOutlet UILabel *comNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *comAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *comAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *comContactorLabel;
@property (weak, nonatomic) IBOutlet UILabel *comPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *comEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *comFileCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *comIndustryLabel;
@property (weak, nonatomic) IBOutlet UILabel *comPropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *comScaleLabel;

@property (strong, nonatomic) IBOutlet UIButton *btn1;



@property (strong,nonatomic)CompanyInfoViewModel *viewModel;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@end

@implementation CompanyInfoViewController

-(instancetype)init
{
    return nil;
}

-(instancetype)initWithData:(id)company
{
    if (self=[super init]) {
        if (company!=nil) {
            self.company=company;
        }
        
    }
    return self;
}

-(void)viewWillLayoutSubviews
{
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title=@"企业信息";
    [self.comIconView.layer setCornerRadius:40.0f];
    [self.comIconView.layer setMasksToBounds:YES];

    if (self.company!=nil) {
          self.viewModel=[[CompanyInfoViewModel alloc]initWithData:self.company];
    }
  
    RAC(self.comTitleLabel,text)=RACObserve(self.viewModel,comName);
    RAC(self.comNameLabel,text)=RACObserve(self.viewModel, comName);
    RAC(self.comAreaLabel,text)=RACObserve(self.viewModel, comArea);
    RAC(self.comAddressLabel,text)=RACObserve(self.viewModel, comAddress);
    RAC(self.comPhoneLabel,text)=RACObserve(self.viewModel, comPhone);
    RAC(self.comEmailLabel,text)=RACObserve(self.viewModel, comEmail);
    RAC(self.comScaleLabel,text)=RACObserve(self.viewModel, comScaleNum);
    RAC(self.comFileCodeLabel,text)=RACObserve(self.viewModel, comFileNum);
    RAC(self.comIndustryLabel,text)=RACObserve(self.viewModel, comIndustry);
    RAC(self.comPropertyLabel,text)=RACObserve(self.viewModel, comProperty);
    RAC(self.comContactorLabel,text)=RACObserve(self.viewModel, comContactors);
    RAC(self.comIconView,image)=RACObserve(self.viewModel, comIcon);
    RAC(self.tagImageView1,image)=RACObserve(self.viewModel, tag1Icon);

    [self.viewModel fetchCompanyDataFromAVOS:self.company];
    
    covervView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    covervView.backgroundColor = [UIColor blackColor];
    covervView.alpha = 0.4;
    
    UITapGestureRecognizer *tapCovervView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(covervViewDidCancel)];
    [covervView addGestureRecognizer:tapCovervView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)seeMoreJobAction:(id)sender {
    JobOfComListVC *jobListForCom=[[JobOfComListVC alloc]init];
    [self.navigationController pushViewController:jobListForCom animated:YES];
    
    if (self.company!=nil) {
        [jobListForCom setCompanyAndQuery:self.company];
    }
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker{
    self.viewModel.comProvince=picker.locate.state;
    self.viewModel.comCity=picker.locate.city;
    self.viewModel.comDistrict=picker.locate.district;
    
    self.viewModel.comArea=[NSString stringWithFormat:@"%@%@%@",picker.locate.state,picker.locate.city,picker.locate.district];

    [covervView removeFromSuperview];
    if (picker.locate.state) {

        NSMutableArray *infos=[[NSMutableArray alloc] initWithObjects:picker.locate.state,picker.locate.city,picker.locate.district, nil];
        NSMutableArray *keys=[[NSMutableArray alloc]initWithObjects:@"qiYeProvince",@"qiYeCity",@"qiYeDistrict", nil];
        [self.viewModel saveCompanyDataToAVOS:infos Keys:keys];
    }
    
}

- (void)pickerCancel:(HZAreaPickerView *)picker{
    [picker cancelPicker];
    [covervView removeFromSuperview];
}

-(void)covervViewDidCancel{
//    [covervView removeFromSuperview];
//    [self.locatePicker cancelPicker];
}

- (void)pickerDidCancel{
    [covervView removeFromSuperview];
}

- (void)finishInputWithType:(NSInteger)type And:(id)info{
    if (type==2) {
        self.viewModel.comName=info;
        [self.viewModel saveCompanyDataToAVOS:info Key:@"qiYeName"];
    }else if (type==4){
        self.viewModel.comAddress=info;
        [self.viewModel saveCompanyDataToAVOS:info Key:@"qiYeDetailAddress"];
    }else if (type==5){
        self.viewModel.comContactors=info;
        [self.viewModel saveCompanyDataToAVOS:info Key:@"qiYeLinkName"];
    }else if (type==6){
        self.viewModel.comPhone=info;
        [self.viewModel saveCompanyDataToAVOS:info Key:@"qiYeMobile"];
    }else if (type==7){
        self.viewModel.comEmail=info;
        [self.viewModel saveCompanyDataToAVOS:info Key:@"qiYeEmail"];
    }else if (type==8){
        self.viewModel.comFileNum=info;
        [self.viewModel saveCompanyDataToAVOS:info Key:@"qiYeLicenseNumber"];
    }else if (type==9){
        self.viewModel.comIndustry=info;
        [self.viewModel saveCompanyDataToAVOS:info Key:@"qiYeIndustry"];
    }else if (type==10){
        self.viewModel.comProperty=info;
        [self.viewModel saveCompanyDataToAVOS:info Key:@"qiYeProperty"];
    }else if (type==11){
        self.viewModel.comScaleNum=info;
        [self.viewModel saveCompanyDataToAVOS:info Key:@"qiYeScale"];
    }
}



- (void)finishSingleSelect:(NSString *)info type:(NSInteger)type{
    
    
    if([info length]>0){
        if (type==11){
            self.comScaleLabel.text=info;
            [self.viewModel saveCompanyDataToAVOS:info Key:@"qiYeScale"];
        }
        else if (type==10){
            self.comPropertyLabel.text=info;
            [self.viewModel saveCompanyDataToAVOS:info Key:@"qiYeProperty"];
        }
        else if (type==9){
            self.comIndustryLabel.text=info;
            [self.viewModel saveCompanyDataToAVOS:info Key:@"qiYeIndustry"];
        }
    }
}


@end
