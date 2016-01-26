//
//  HomeViewController.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-21.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomButton.h"
#import "ViewController.h"
#import "UINavigationController+ CompletionHandler.h"
@interface HomeViewController (){
    
    NSTimer *timer;
    int floatVal;
}

@property (nonatomic, weak) IBOutlet CustomButton *workButton;
@property (nonatomic, weak) IBOutlet CustomButton *passButton;
@property (nonatomic, weak) IBOutlet CustomButton *tempButton;
@property (nonatomic, weak) IBOutlet CustomButton *quickButton;
@property (nonatomic, weak) IBOutlet CustomButton *personalButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    floatVal=0;
    // Do any additional setup after loading the view.
    
    [self addButtonsAndCustomiseView];
    
}

-(void)addButtonsAndCustomiseView{
    
    self.view.backgroundColor=[UIColor colorWithRed:102/255.0 green:169/255.0 blue:251/255.0 alpha:1];
    _workButton.butTitle=@"Work";
    _workButton.textSize=CGSizeMake(100, 30);
    _workButton.butTitleColor=[UIColor blackColor];
    _workButton.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:220/255.0 alpha:1];
    _workButton.backColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:220/255.0 alpha:1];
    [_workButton setNeedsDisplay];
    
    _passButton.butTitle=@"Password";
    _passButton.textSize=CGSizeMake(100, 30);
    _passButton.butTitleColor=[UIColor blackColor];
    _passButton.backgroundColor=[UIColor colorWithRed:134/255.0 green:198/255.0 blue:124/255.0 alpha:1];
    _passButton.backColor=[UIColor colorWithRed:134/255.0 green:198/255.0 blue:124/255.0 alpha:1];
    [_passButton setNeedsDisplay];
    
    _tempButton.butTitle=@"Temporary";
    _tempButton.textSize=CGSizeMake(100, 30);
    _tempButton.butTitleColor=[UIColor blackColor];
    _tempButton.backgroundColor=[UIColor colorWithRed:242/255.0 green:71/255.0 blue:63/255.0 alpha:1];
    _tempButton.backColor=[UIColor colorWithRed:242/255.0 green:71/255.0 blue:63/255.0 alpha:1];
    [_tempButton setNeedsDisplay];
    
    _quickButton.butTitle=@"QuickNote";
    _quickButton.textSize=CGSizeMake(100, 30);
    _quickButton.butTitleColor=[UIColor blackColor];
    _quickButton.backgroundColor=[UIColor colorWithRed: 0.296 green: 0.463 blue: 0.767 alpha: 1];
    _quickButton.backColor=[UIColor colorWithRed: 0.296 green: 0.463 blue: 0.767 alpha: 1];
    [_quickButton setNeedsDisplay];
    
    _personalButton.butTitle=@"Personal";
    _personalButton.textSize=CGSizeMake(100, 30);
    _personalButton.butTitleColor=[UIColor whiteColor];
    _personalButton.backgroundColor=[UIColor colorWithRed:54/255.0 green:11/255.0 blue:88/255.0 alpha:1];
    _personalButton.backColor=[UIColor colorWithRed:54/255.0 green:11/255.0 blue:88/255.0 alpha:1];
    [_personalButton setNeedsDisplay];

}

-(void)rotate{
    
    floatVal=floatVal+1;
    _workButton.floatVal=floatVal;
    [_workButton setNeedsDisplay];
    
    _personalButton.floatVal=floatVal+50;
    [_personalButton setNeedsDisplay];
    
    _tempButton.floatVal=floatVal-50;
    [_tempButton setNeedsDisplay];
    
    _quickButton.floatVal=floatVal+130;
    [_quickButton setNeedsDisplay];
    
    _passButton.floatVal=floatVal-130;
    [_passButton setNeedsDisplay];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"touched");
    
    //need to remove the timer here,
    //TODO: place the timer in viewWillAppear later
   timer= [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rotate) userInfo:nil repeats:YES];
    
    
    
    if (CGRectContainsPoint(_workButton.bounds, [touches.anyObject locationInView:_workButton])) {
        
        [self presentWorkLabelNotesController];
    }
    
    if (CGRectContainsPoint(_passButton.bounds, [touches.anyObject locationInView:_passButton])) {
        
        [self presentPassLabelNotesController];
    }
    
    if (CGRectContainsPoint(_tempButton.bounds, [touches.anyObject locationInView:_tempButton])) {
        
        [self presentTempLabelNotesController];
    }
    
    if (CGRectContainsPoint(_quickButton.bounds, [touches.anyObject locationInView:_quickButton])) {
        
        [self presentQuickLabelNotesController];
    }
    
    if (CGRectContainsPoint(_personalButton.bounds, [touches.anyObject locationInView:_personalButton])) {
        
        [self presentPersoLabelNotesController];
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [timer invalidate];
    NSLog(@"lifted");
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

-(void)presentWorkLabelNotesController{
    
    ViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.tableName=@"WorkTable";
    [self.navigationController completionhandler_pushViewController:vc animated:YES completion:^{
       
        NSLog(@"oush completed");
        [timer invalidate];
        
    }];
    
}

-(void)presentTempLabelNotesController{
    
    ViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.tableName=@"TempTable";
    [self.navigationController completionhandler_pushViewController:vc animated:YES completion:^{
        
        NSLog(@"oush completed");
        [timer invalidate];
        
    }];
    
}

-(void)presentQuickLabelNotesController{
    
    ViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.tableName=@"QuickTable";
    [self.navigationController completionhandler_pushViewController:vc animated:YES completion:^{
        
        NSLog(@"oush completed");
        [timer invalidate];
        
    }];
    
}

-(void)presentPersoLabelNotesController{
    
    ViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.tableName=@"PersoTable";
    [self.navigationController completionhandler_pushViewController:vc animated:YES completion:^{
        
        NSLog(@"oush completed");
        [timer invalidate];
        
    }];
    
}

-(void)presentPassLabelNotesController{
    
    ViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.tableName=@"PassTable";
    [self.navigationController completionhandler_pushViewController:vc animated:YES completion:^{
        
        NSLog(@"oush completed");
        [timer invalidate];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)incrementValue{
    
    NSLog(@"button pressed");
    
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
