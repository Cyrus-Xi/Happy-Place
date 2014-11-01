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
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailText.text = _complimentText;
    //self.complimentItem =[[CXComplimentItem alloc] init];

    NSLog(@"Index of compliment: %ld", self.indexCompliment);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
    [super setEditing:flag animated:animated];
    if (flag == YES){
        _detailText.editable = YES;
        // Change views to edit mode.
    }
    else {
        // Save the changes if needed and change the views to noneditable.
        _detailText.editable = NO;
    }
}*/


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
    if (sender != self.saveButton) return;
    if (_detailText.text.length > 0) {
        NSLog(@"Should now update");
        // Update modified compliment in array of compliments.
        _complimentItem = [[CXComplimentItem alloc] init];
        _complimentItem.itemText = _detailText.text;
        NSLog(@"New text: %@", _complimentItem.itemText);
        //[self.complimentItems insertObject:_complimentItem atIndex:_indexCompliment];
    }

}
 

@end
