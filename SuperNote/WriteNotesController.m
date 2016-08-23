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


@interface WriteNotesController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    BOOL    textChanged;
}

@property (nonatomic,strong) SuperNoteManager *myManager; //weak property causes nil when go back
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (strong,nonatomic) NSString *filePath;
@end

@implementation WriteNotesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myManager=[SuperNoteManager sharedInstance];
    _textView.delegate=self;
    
    [self addCameraButtonToNavbar];
    
    if (_myManager.dataBaseCreated) {
        NSLog(@"data base is created ? - %d",_myManager.dataBaseCreated);
       
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_textView becomeFirstResponder];
    
    //get the notes from datatabse
    if ([_notesStatus isEqualToString:@"UpdateNotes"]) {
        
        _myManager.queryMode=11;
        NSMutableDictionary *dic=[_myManager getStringForRowWithId:_notesID];
         _filePath=dic[@"notesPath"];
//        _filePath=[self getAbsolutePathFromRelativePath:dic[@"notesPath"]];
        _textView.attributedText=[self getAttributedStringFromPath:_filePath];
//        _textView.text=dic[@"notes"];
        NSLog(@"filepath in viewWillAppear is %@",_filePath);
        
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
//        [self insertTextintoDatabase];
        [self saveAttributedString:_textView.attributedText];
    }
    
}


-(void)saveAttributedString:(NSAttributedString *)atrString{
    
    _filePath = [[self applicationDocumentsDirectory].path
                 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%d.txt",_myManager.currentTableName,_notesID]];
//    _filePath =[self getRelativePath];
    
    BOOL success =[NSKeyedArchiver archiveRootObject:atrString toFile:_filePath];
    
    if (success) {
        NSLog(@"attributed string saved");
        [self insertTextintoDatabase];
    }else{
        NSLog(@"attributed string saved");
    }
    
}

-(NSString *)getRelativePath{
    
    NSString *documentsDirectory = _myManager.currentTableName;
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%d.txt",_myManager.currentTableName,_notesID]];
   return documentsDirectory;
}

-(NSString *)getAbsolutePathFromRelativePath:(NSString *)relativePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
    return [fullCachePath stringByAppendingPathComponent:relativePath];
}

-(NSAttributedString *)getAttributedStringFromPath:(NSString *)path{
    
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
    
}

-(NSString *)getDocPath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
   return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}
-(void)addCameraButtonToNavbar{
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Camera" style:UIBarButtonItemStylePlain target:self action:@selector(startCamera)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

-(void)startCamera{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.navigationBar.barTintColor = [UIColor colorWithRed:0.147 green:0.413 blue:0.737 alpha:1];
    picker.navigationBar.tintColor = [UIColor whiteColor];
    picker.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self presentViewController:picker animated:YES completion:NULL];
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    
    return YES;
}

#pragma camera picker delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    [self updateTextViewWithImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)updateTextViewWithImage:(UIImage *)image{
    
    UIImage *img=[self imageWithImage:image scaledToSize:CGSizeMake(100, 100)];
    
   // UITextView *textView = [[UITextView alloc] initWithFrame:_textView.frame];
    NSMutableAttributedString *attributedString = [_textView.attributedText mutableCopy];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = img;
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString replaceCharactersInRange:NSMakeRange(_textView.text.length, 0) withAttributedString:attrStringWithImage];
    //textView.attributedText = attributedString;
    _textView.attributedText=attributedString;
   // [_textView addSubview:textView];
    
    [self saveAttributedString:_textView.attributedText];
    
    
}


-(void)insertTextintoDatabase{
    
    if (![_textView.text isEqualToString:@""]) {
        
        if ([_notesStatus isEqualToString:@"NewNotes"]) {
            
            _myManager.queryMode=10;
            [_myManager insertDataWithText:_textView.text withDate:[NSString stringWithFormat:@"%@",[NSString formatDateString:[NSDate date]]] withFilePath:_filePath];
            
        }else if ([_notesStatus isEqualToString:@"UpdateNotes"]) {
            
            if (textChanged) {
                 _myManager.queryMode=13;
                [_myManager updateRecordWithRowID:_notesID withText:_textView.text withDate:[NSString stringWithFormat:@"%@",[NSString formatDateString:[NSDate date]]] withFilePath:_filePath];
               
            }
        }
        
    }
}


-(void)showAlert{
    
    UIAlertController *aC=[UIAlertController alertControllerWithTitle:@"Chose Label" message:@"Kindly choose the label you want his note to be categorised as" preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Presenting the great... Hulk Hogan!"];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:50.0]
                  range:NSMakeRange(24, 11)];
    [aC setValue:hogan forKey:@"attributedTitle"];

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
