//
//  TViewController.m
//  TFoundation
//
//  Created by i19850511@gmail.com on 03/10/2020.
//  Copyright (c) 2020 i19850511@gmail.com. All rights reserved.
//

#import "TViewController.h"
#import <TFoundation/TAudioPlayer.h>

@interface TViewController ()

@end

@implementation TViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)playSound:(id)sender {
	[TAudioPlayer playSoundWithFileName:@"refresh_music.m4a"
							 bundleName:nil
								 ofType:nil
							   andAlert:NO];
}
@end
