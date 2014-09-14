//
//  ComplimentListTableViewController.m
//  HappyPlace
//
//  Created by Cyrus Xi on 9/11/14.
//  Copyright (c) 2014 ___SURYC11___. All rights reserved.
//

#import "CXComplimentListTableViewController.h"
#import "CXComplimentItem.h"
#import "CXAddComplimentViewController.h"
#import "CXComplimentDetailViewController.h"

@interface CXComplimentListTableViewController ()

@property NSMutableArray *complimentItems;
@property CXComplimentItem *complimentItem;
@property NSString *complimentDetail;

@end

@implementation CXComplimentListTableViewController

// To simplify code. Returns documents directory path.
-(NSString *)docsDir {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

- (void)loadInitialData {
    listPath = [[self docsDir]stringByAppendingPathComponent:@"Data.plist"];
    NSLog(@"listPath = %@", listPath);
    
    // If plist file not there, must be in main bundle -- and must be the first launch.
    // Copy to docs directory to make it write-capable.
    if (![[NSFileManager defaultManager]fileExistsAtPath:listPath]) {
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"Data" ofType:@"plist"] toPath:listPath error:nil];
    }
    
    // Check that it works.
    listCompliments = [[NSMutableArray alloc] initWithContentsOfFile:listPath];
    NSLog(@"listCompliments: %@\n", listCompliments);
    NSLog(@"complimentItems: %@\n", self.complimentItems);
    
    // Convert the strings in listCompliments to complimentItems.
    for (NSString *text in listCompliments) {
        self.complimentItem = [[CXComplimentItem alloc] init];
        self.complimentItem.itemText = text;
        [self.complimentItems addObject:self.complimentItem];
    }
    
    NSLog(@"complimentItems: %@\n", self.complimentItems);
    NSLog(@"listCompliments: %@\n", listCompliments);
    
    NSLog(@"Count: %lu", (unsigned long)[listCompliments count]);
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    CXAddComplimentViewController *source = [segue sourceViewController];
    CXComplimentItem *item = source.complimentItem;
    if (item != nil) {
        [self.complimentItems addObject:item];
        [self.tableView reloadData];
        [self writeToFile:item];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.complimentItems = [[NSMutableArray alloc] init];
    
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.complimentItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    CXComplimentItem *complimentItem = [self.complimentItems objectAtIndex:indexPath.row];
    cell.textLabel.text = complimentItem.itemText;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Update data.
        [self.complimentItems removeObjectAtIndex:indexPath.row];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    [tableView endUpdates];
    // Update plist file.
    [self writeToPlistFile];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Get text of the selected compliment.
    CXComplimentItem *compliment = [self.complimentItems objectAtIndex:[indexPath row]];
    self.complimentDetail = compliment.itemText;
    
    // Perform segue.
    [self performSegueWithIdentifier:@"DetailViewController" sender:self];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CXComplimentDetailViewController class]]) {
        // Configure ComplimentDetailViewController.
        [(CXComplimentDetailViewController *)segue.destinationViewController setComplimentText:self.complimentDetail];
        
        // Reset compliment detail.
        self.complimentDetail = nil;
    }
}

-(void)writeToPlistFile {
    NSLog(@"listPath = %@", listPath);
    NSMutableArray *newListCompliments = [[NSMutableArray alloc] init];
    NSString *newComplimentString = [[NSString alloc] init];
    
    // Convert complimentItems back to strings for writing to plist file.
    for (CXComplimentItem *item in self.complimentItems) {
        newComplimentString = item.itemText;
        [newListCompliments addObject:newComplimentString];
    }
    
    NSLog(@"newListCompliments: %@", newListCompliments);
    
    // Check that it successfully wrote to plist file.
    BOOL didItWork = [newListCompliments writeToFile:listPath atomically:YES];
    NSLog(@" %s", didItWork ? "yes" : "no");

}

- (IBAction)writeToFile:(id)sender {
    [self writeToPlistFile];
}
@end
