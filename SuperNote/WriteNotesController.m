//
//  WriteNotesController.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-14.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "WriteNotesController.h"
#import "SuperNoteManager.h"
#import "NSString+DateFormatter.h"


@interface WriteNotesController ()<UITextViewDelegate>{
    
    BOOL    textChanged;
}

@property (nonatomic,weak) SuperNoteManager *myManager;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation WriteNotesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myManager=[SuperNoteManager sharedInstance];
    _textView.delegate=self;
    
    
    if (_myManager.dataBaseCreated) {
        NSLog(@"data base is created ? - %d",_myManager.dataBaseCreated);
       
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_textView becomeFirstResponder];
    
    //get the notes from datatabse
    if ([_notesStatus isEqualToString:@"UpdateNotes"]) {
        
        _textView.text=[_myManager getStringForRowWithId:_notesID];
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ((_myManager.currentTableName==(id)[NSNull null])||_myManager.currentTableName.length==0) {
        [self showAlert];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        NSLog(@"going back");
        [self insertTextintoDatabase];
    }
    
}

-(void)insertTextintoDatabase{
    
    if (![_textView.text isEqualToString:@""]) {
        
        if ([_notesStatus isEqualToString:@"NewNotes"]) {
            
            _myManager.queryMode=10;
            [_myManager insertDataWithValues:_textView.text :[NSString stringWithFormat:@"%@",[NSString formatDateString:[NSDate date]]]];
            
        }else if ([_notesStatus isEqualToString:@"UpdateNotes"]) {
            
            if (textChanged) {
                 _myManager.queryMode=13;
                [_myManager updateRecordWithRowID:_notesID withText:_textView.text withDate:[NSString stringWithFormat:@"%@",[NSString formatDateString:[NSDate date]]]];
               
            }
        }
        
    }
}


-(void)showAlert{
    
    UIAlertController *aC=[UIAlertController alertControllerWithTitle:@"Chose Label" message:@"Kindly choose the label you want his note to be categorised as" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *work=[UIAlertAction actionWithTitle:@"Work" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        _myManager.currentTableName=@"WorkTable";
        [aC dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *temp=[UIAlertAction actionWithTitle:@"Temporary" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        _myManager.currentTableName=@"TempTable";
        [aC dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *pass=[UIAlertAction actionWithTitle:@"Password" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        _myManager.currentTableName=@"PassTable";
        [aC dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *perso=[UIAlertAction actionWithTitle:@"Personal" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        _myManager.currentTableName=@"PersoTable";
        [aC dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [aC addAction:work];
    [aC addAction:temp];
    [aC addAction:pass];
    [aC addAction:perso];
    
    [self presentViewController:aC animated:YES completion:nil];
   
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma Text view delegate methods
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    textChanged=YES;
    return YES;
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

@end
