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
#import "AssistView.h"
#import <AVFoundation/AVFoundation.h>

@interface WriteNotesController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>{
    
    BOOL    textChanged;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    
}

@property (nonatomic,strong) SuperNoteManager *myManager; //weak property causes nil when go back
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (strong,nonatomic) NSString *filePath;
@property (strong,nonatomic) AssistView *asstView;
@property (strong,nonatomic) UIButton *camButton;
@property (strong,nonatomic) UIButton *audioButton;

@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;
@end

@implementation WriteNotesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myManager=[SuperNoteManager sharedInstance];
    _textView.delegate=self;
    
    [self addAssistView];
    [self setUpAudio];
    
    [self addCameraButtonToNavbar];
    
    if (_myManager.dataBaseCreated) {
        NSLog(@"data base is created ? - %d",_myManager.dataBaseCreated);
       
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    
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

-(void)setUpAudio{
    
    NSString *filename = [NSString stringWithFormat:@"%@.mp3",[NSDate date]];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               filename,
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEGLayer3] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];

}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
//    _lastContentOffsetY = keyboardFrame.size.height;
    CGRect asstFrame = CGRectMake(keyboardFrame.size.width-_asstView.frame.size.width-10, keyboardFrame.origin.y-_asstView.frame.size.height-10, _asstView.frame.size.width, _asstView.frame.size.height);
    _asstView.frame = asstFrame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView commitAnimations];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
}

-(void)addAssistView{
    
    _asstView =[[AssistView alloc]initWithFrame:CGRectMake(0,200, 30, 30)];
    _asstView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_asstView];
    
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.lpgr.minimumPressDuration = 0.5f;
    self.lpgr.allowableMovement = 100.0f;
    
    [_asstView addGestureRecognizer:self.lpgr];
    
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:self.lpgr]) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            NSLog(@"long pressed");
            [self showButtons];
        }
    }
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self.view];
    _asstView.center = pt;
}

-(void)showButtons{
    
    
    CGRect newRect = CGRectMake(_asstView.frame.origin.x, _asstView.frame.origin.y
                                , _camButton.frame.size.width, _camButton.frame.size.height);
    _audioButton.frame = newRect;
    _camButton.frame=newRect;
    
   _camButton = [[UIButton alloc]init];
    CGRect butFrame = CGRectMake(_asstView.frame.origin.x, _asstView.frame.origin.y-50, _asstView.frame.size.width, _asstView.frame.size.height);
//    UIView *cam =[[UIView alloc]initWithFrame:butFrame];
//    _camButton.frame=_asstView.frame;
    _camButton.backgroundColor=[UIColor clearColor];
    [_camButton addTarget:self action:@selector(butPressed) forControlEvents:UIControlEventTouchUpInside];
    [_camButton setBackgroundImage:[UIImage imageNamed:@"Camera Filled-50"] forState:UIControlStateNormal];
    [self.view addSubview:_camButton];
    
    _audioButton = [[UIButton alloc]init];
    CGRect audFrame = CGRectMake(_asstView.frame.origin.x-50, _asstView.frame.origin.y, _asstView.frame.size.width, _asstView.frame.size.height);
    //    UIView *cam =[[UIView alloc]initWithFrame:butFrame];
//    _audioButton.frame=_asstView.frame;
    _audioButton.backgroundColor=[UIColor clearColor];
     [_audioButton addTarget:self action:@selector(butPressed) forControlEvents:UIControlEventTouchUpInside];
    [_audioButton setBackgroundImage:[UIImage imageNamed:@"Microphone-52"] forState:UIControlStateNormal];
    [self.view addSubview:_audioButton];

    [UIView animateWithDuration:0.2
                     animations:^{
                         _audioButton.frame = audFrame;
                         _camButton.frame=butFrame;
                     }
                     completion:^(BOOL finished){
                         
                     }];

    
    
}

-(void)removeButtons{
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGRect newRect = CGRectMake(_asstView.frame.origin.x, _asstView.frame.origin.y
                                                     , _camButton.frame.size.width, _camButton.frame.size.height);
                         _audioButton.frame = newRect;
                         _camButton.frame=newRect;
                     }
                     completion:^(BOOL finished){
                         [_audioButton removeFromSuperview];
                         [_camButton removeFromSuperview];
                     }];
    
   
}

-(void)butPressed{
    
    [self removeButtons];
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
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//   textView.inputAccessoryView=_asstView;
    return YES;
}
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
