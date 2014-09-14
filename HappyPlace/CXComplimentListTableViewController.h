//
//  ComplimentListTableViewController.h
//  HappyPlace
//
//  Created by Cyrus Xi on 9/11/14.
//  Copyright (c) 2014 ___SURYC11___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXComplimentItem.h"

@interface CXComplimentListTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSString *listPath;
    NSMutableArray *listCompliments;
    //ComplimentItem *complimentItem;
}

//- (IBAction)addItem:(id)sender;
- (IBAction)writeToFile:(id)sender;

//@property (nonatomic, strong) NSMutableArray *complimentList;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
