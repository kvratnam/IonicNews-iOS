//
//  IonProfileViewController.m
//  IonNews
//
//  Created by Himanshu Rajput on 10/04/17.
//  Copyright © 2017 mantraLabsGlobal. All rights reserved.
//

#import "IonProfileViewController.h"
#import "Ionconstant.h"


@interface IonProfileViewController ()<UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation IonProfileViewController
{

    NSDictionary *user_detail;
    NSArray *pickerArray;
     NSString *role_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pickerArray  =[[NSArray alloc] init];
    
    [[requestHandler sharedInstance]getuserGroupresponseMethod:nil viewcontroller:self withHandler:^(id  _Nullable response) {
        pickerArray = response;
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.profileImage.layer.borderWidth = 2.0;
    self.profileImage.clipsToBounds = YES;
    
    
    self.rolepicker = [[UIPickerView alloc] init];
    self.rolepicker.delegate = self;
    self.rolepicker.dataSource = self;
    self.rolepicker.showsSelectionIndicator = YES;
    self.role.inputView = self.rolepicker;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     self.rolepicker.frame.size.height-50, self.view.frame.size.width, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"updateProfileImg"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"updateProfileImg"] isEqualToString:@""]) {
        NSURL * URL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"updateProfileImg"]];
        [[ion_imageUrlrequest shared]setImageWithUrl:URL withHandler:^(id  _Nullable image, NSError * _Nullable error) {
            self.profileImage.image = image;
        }];
    }else{
    
        self.profileImage.image = [UIImage imageNamed:@"edit_profile"];
    }

    
    user_detail = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_detail"];
    
    self.firstNameTxtField.text = [user_detail objectForKey:@"first_name"];
    self.lastNameTxtField.text = [user_detail objectForKey:@"last_name"];
    self.phoneTxtField.text = [user_detail objectForKey:@"phone"];
    self.emailNameTxtField.text = [user_detail objectForKey:@"email"];
    self.orgTxtField.text = [user_detail objectForKey:@"company"];
    self.desgTxtField.text = [user_detail objectForKey:@"designation"];
    self.role.text = [user_detail objectForKey:@"role"];
    
    
    [self.firstNameTxtField designTextField];
    [self.lastNameTxtField designTextField];
    [self.phoneTxtField designTextField];
    [self.emailNameTxtField designTextField];
    [self.orgTxtField designTextField];
    [self.desgTxtField designTextField];
    [self.role designTextField];

      self.emailNameTxtField.enabled = NO;
    self.phoneTxtField.enabled = NO;
 //   self.role.enabled = NO;
    
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(BOOL)prefersStatusBarHidden{

    return YES;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
    
    
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    [self.role setText:[[pickerArray objectAtIndex:row] valueForKey:@"slug"]];
    role_id = [[pickerArray objectAtIndex:row] valueForKey:@"id"];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [[pickerArray objectAtIndex:row] valueForKey:@"slug"];
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    self.profileImage.image = image;
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    if (base64){
        NSDictionary *param = @{
                                @"profileImg" : base64
                                };
        
        [[requestHandler sharedInstance] updateImageresponseMethod:param viewcontroller:self withHandler:^(id  _Nonnull response) {
            [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"profileImg"] forKey:@"updateProfileImg"];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    

}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action

- (IBAction)profileImgBtnPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)saveBtnPressed:(id)sender {
    NSString * errMsg = [self validationMethodOnLoginButtonClick];
    if (errMsg != nil) {
        [self dismissKeyboard];
        [[IonUtility sharedInstance] alertView:errMsg viewController:self];
    }else{
        NSDictionary * paramDict =  @{
                                      @"first_name": self.firstNameTxtField.text,
                                      @"last_name": self.lastNameTxtField.text,
                                      @"company": self.orgTxtField.text,
                                      @"designation": self.desgTxtField.text,
                                      @"role":self.role.text,
                                      @"role_id":role_id
                                      };
        
        [[requestHandler sharedInstance] updateProfileresponseMethod:paramDict viewcontroller:self withHandler:^(id  _Nonnull response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setObject:response forKey:@"user_detail"];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }
    NSLog(@"pressed");
}

- (IBAction)cancelBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - methods

-(void)dismissKeyboard
{
    [self.firstNameTxtField resignFirstResponder];
    [self.lastNameTxtField resignFirstResponder];
    [self.phoneTxtField resignFirstResponder];
    [self.emailNameTxtField resignFirstResponder];
    [self.orgTxtField resignFirstResponder];
    [self.desgTxtField resignFirstResponder];
    [self.role resignFirstResponder];
}

-(void)done:(id)sender{
    [sender resignFirstResponder];
    
}

- (NSString *)validationMethodOnLoginButtonClick
{
    if (self.firstNameTxtField.text.length == 0)
    {
        return @"First Name cannot be empty";
    }
    else if(self.firstNameTxtField.text.length > 0 && ![self.firstNameTxtField.text isValidName]){
        return @"First Name is invalid";
    }
    else if (self.lastNameTxtField.text.length == 0)
    {
        return @"Last Name cannot be empty";
    }
    else if(self.lastNameTxtField.text.length > 0 && ![self.lastNameTxtField.text isValidName]){
        return @"Last Name is invalid";
    }
    
    else{
        return   nil;
    }
}



@end
