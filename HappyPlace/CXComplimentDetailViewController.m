//
//  CXComplimentDetailViewController.m
//  HappyPlace
//
//  Created by Cyrus Xi on 9/14/14.
//  Copyright (c) 2014 ___SURYC11___. All rights reserved.
//

#import "CXComplimentDetailViewController.h"
#import "CXComplimentListTableViewController.h"

@interface CXComplimentDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *detailText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation CXComplimentDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailText.text = _complimentText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.saveButton) return;
    if (_detailText.text.length > 0) {
        NSLog(@"Should now update");
        // Get modified compliment for segue.
        _complimentItem = [[CXComplimentItem alloc] init];
        _complimentItem.itemText = _detailText.text;
    }

}

@end
