//
//  CXComplimentDetailViewController.m
//  HappyPlace
//
//  Created by Cyrus Xi on 9/14/14.
//  Copyright (c) 2014 ___SURYC11___. All rights reserved.
//

#import "CXComplimentDetailViewController.h"
#import "CXComplimentListTableViewController.h"

@interface CXComplimentDetailViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *detailText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation CXComplimentDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

// This and shouldChangeTextInRange() are from:
// http://iosdevelopertips.com/cocoa/how-to-dismiss-the-keyboard-when-using-a-uitextview.html
- (id) init {
    if (self = [super init]) {
        // define the area and location for the UITextView
        CGRect tfFrame = CGRectMake(10, 10, 300, 100);
        messageTextView = [[UITextView alloc] initWithFrame:tfFrame];
        // make sure that it is editable
        messageTextView.editable = YES;
        
        // add the controller as the delegate
        messageTextView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailText.text = _complimentText;
    [self.detailText setReturnKeyType:UIReturnKeyDone];
    self.detailText.delegate = self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidEndEditing {
    [self.detailText resignFirstResponder];
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
