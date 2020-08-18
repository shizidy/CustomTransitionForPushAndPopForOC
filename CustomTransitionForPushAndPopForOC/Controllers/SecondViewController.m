//
//  SecondViewController.m
//  CustomTransitionForPushAndPopForOC
//
//  Created by wdyzmx on 2020/8/17.
//  Copyright © 2020 wdyzmx. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:({
        UIButton *pushBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        pushBtn.center = self.view.center;
        [pushBtn setTitle:@"POP" forState:UIControlStateNormal];
        [pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        pushBtn.backgroundColor = [UIColor redColor];
        [pushBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        pushBtn;
    })];
    
    // Do any additional setup after loading the view.
}

- (void)buttonAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
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
