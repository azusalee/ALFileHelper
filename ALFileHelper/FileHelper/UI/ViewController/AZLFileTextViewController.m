//
//  AZLFileTextViewController.m
//  ALExampleTest
//
//  Created by yangming on 2018/9/19.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AZLFileTextViewController.h"

@interface AZLFileTextViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation AZLFileTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.editable = NO;
    [self.view addSubview:self.textView];
    if ([self.filePath hasSuffix:@".plist"]) {
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:self.filePath];
        if (dict) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
            NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.textView.text = content;
        }
        
    }else{
        NSString *content = [[NSString alloc] initWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
        if (content) {
            self.textView.text = content;
        }else{
            self.textView.text = @"!!未能正確解析文件!!";
        }
        
    }
    
    
    
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
