//
//  CXComplimentListTableViewController.m
//  HappyPlace
//
//  Created by Cyrus Xi on 9/11/14.
//  Copyright (c) 2014 ___SURYC11___. All rights reserved.
//

#import "CXComplimentListTableViewController.h"
#import "CXComplimentItem.h"
#import "CXAddComplimentViewController.h"
#import "CXComplimentDetailViewController.h"

#define ARC4RANDOM_MAX 0x100000000

@interface CXComplimentListTableViewController ()

@property NSMutableArray *complimentItems;
@property CXComplimentItem *complimentItem;
@property NSString *complimentDetail;
@property NSDate *lastDate;
@property NSMutableArray *listDates;

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
        if ([self.complimentItems count] == 1) {
            [self setRandomNotification];
        }
        //[self setRandomNotification];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
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

// Set random notification when enter background, not when enter foreground or become active,
// to guard against edge case where user deletes last compliment but still gets sent it as a
// notification.
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSInteger notificationsCount = [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
    
    NSLog(@"Number of notifications: %ld", (long)notificationsCount);
    NSLog(@"Number of compliments: %lu", (unsigned long)[self.complimentItems count]);
    
    if ( ([self.complimentItems count] >= 1) && (notificationsCount == 0) ) {
        NSLog(@"Setting random notif");
        [self setRandomNotification];
    }
    
}

// Set local notification 2 days from last scheduled notification at random time with random
// compliment body.
-(void)setRandomNotification {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // Could probably simplify this.
    NSDate *startDate = [[NSDate alloc] init];
    NSDate *endDate = [[NSDate alloc] init];
    NSDate *randomDate = [[NSDate alloc] init];
    NSTimeInterval randomInterval = 1;
    
    NSInteger lowerBound = 0;
    NSInteger upperBound = [self.complimentItems count];
    NSInteger randomInt = lowerBound + arc4random() % (upperBound - lowerBound);
    
    // Test random integer.
    NSLog(@"Random int: %ld", (long)randomInt);
    
    // If first time setting notification, use date 2 days from now.
    if (self.lastDate == nil) {
        randomDate = [randomDate initWithTimeIntervalSinceNow:172800];
    }
    else {
        // First establish boundaries: earliest at 2 days - 4 hrs from last date and latest
        // at 2 days + 4 hrs from last date. Then use that interval to get a random interval.
        // Finally, add the random interval to the earliest date boundary to get a random
        // date.
        startDate = [startDate initWithTimeInterval:158400 sinceDate:self.lastDate];
        endDate = [endDate initWithTimeInterval:187200 sinceDate:self.lastDate];
        NSTimeInterval intervalTimeBlock = [endDate timeIntervalSinceDate:startDate];
        randomInterval = ((NSTimeInterval)arc4random() / ARC4RANDOM_MAX) * intervalTimeBlock;
        randomDate = [startDate dateByAddingTimeInterval:randomInterval];
    }
    
    NSLog(@"Last date: %@", self.lastDate);
    self.lastDate = randomDate;
    
    NSLog(@"Start date: %@", startDate);
    NSLog(@"End date: %@", endDate);
    NSLog(@"Random interval: %f", randomInterval);
    NSLog(@"Random date: %@", randomDate);
    NSLog(@"New last date: %@", self.lastDate);
    
    NSDate *test = [[NSDate alloc] init];
    test = [test initWithTimeIntervalSinceNow:20];
    self.lastDate = test;
    
    localNotification.fireDate = randomDate;
    //localNotification.fireDate = test;
    CXComplimentItem *randomCompliment = [self.complimentItems objectAtIndex:randomInt];
    localNotification.alertBody = randomCompliment.itemText;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //localNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

/*
 - (IBAction)setNotification:(id)sender {
 UILocalNotification *localNotification = [[UILocalNotification alloc] init];
 
 // Could probably simplify this.
 NSDate *startDate = [[NSDate alloc] init];
 NSDate *endDate = [[NSDate alloc] init];
 NSDate *randomDate = [[NSDate alloc] init];
 NSTimeInterval randomInterval = 1;
 
 // If first time setting notification, use date 2 days from now.
 if (self.lastDate == nil) {
 randomDate = [randomDate initWithTimeIntervalSinceNow:172800];
 }
 else {
 // First establish boundaries: earliest at 2 days - 4 hrs from last date and latest
 // at 2 days + 4 hrs from last date. Then use that interval to get a random interval.
 // Finally, add the random interval to the earliest date boundary to get a random
 // date.
 startDate = [startDate initWithTimeInterval:158400 sinceDate:self.lastDate];
 endDate = [endDate initWithTimeInterval:187200 sinceDate:self.lastDate];
 NSTimeInterval intervalTimeBlock = [endDate timeIntervalSinceDate:startDate];
 randomInterval = ((NSTimeInterval)arc4random() / ARC4RANDOM_MAX) * intervalTimeBlock;
 randomDate = [startDate dateByAddingTimeInterval:randomInterval];
 }
 
 NSLog(@"Last date: %@", self.lastDate);
 self.lastDate = randomDate;
 
 NSLog(@"Start date: %@", startDate);
 NSLog(@"End date: %@", endDate);
 NSLog(@"Random interval: %f", randomInterval);
 NSLog(@"Random date: %@", randomDate);
 NSLog(@"New last date: %@", self.lastDate);
 
 NSDate *test = [[NSDate alloc] init];
 test = [test initWithTimeIntervalSinceNow:20];
 self.lastDate = test;
 //localNotification.fireDate = randomDate;
 localNotification.fireDate = test;
 CXComplimentItem *lastCompliment = [self.complimentItems objectAtIndex:[self.complimentItems count]-1];
 localNotification.alertBody = lastCompliment.itemText;
 localNotification.soundName = UILocalNotificationDefaultSoundName;
 //localNotification.applicationIconBadgeNumber = 1;
 [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
 
 }
 */

- (IBAction)writeToFile:(id)sender {
    [self writeToPlistFile];
}

-(void)dealloc {
    NSLog(@"Deallocating notif center");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

@end
