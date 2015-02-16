//
//  MasterViewController.m
//  W6D1-CloudKit
//
//  Created by Daniel Mathews on 2015-02-15.
//  Copyright (c) 2015 com.lighthouse-labs. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <CloudKit/CloudKit.h>

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
   
    /*Saving a record from public Database
    CKRecordID *wellKnownID = [[CKRecordID alloc] initWithRecordName:@"WellKnownID1"];

    CKRecord *event = [[CKRecord alloc] initWithRecordType:@"Event" recordID:wellKnownID];
    
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];

    [publicDatabase saveRecord:event completionHandler:^(CKRecord *record, NSError *error) {
        //
        
        if (error){
            NSLog(@"ERROR!, %@", error.description);
        }else{
            NSLog(@"NO ERROR");
        }
    }];*/
    
    /*Fetching a record from public Database
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    
    CKRecordID *wellKnownID = [[CKRecordID alloc] initWithRecordName:@"WellKnownID1"];
    
    [publicDatabase fetchRecordWithID:wellKnownID completionHandler:^(CKRecord *record, NSError *error) {
        
        if (error){
            NSLog(@"ERROR!, %@", error.description);
        }else{
            NSLog(@"NO ERROR, %@", record.recordType);
        }
    }];*/
    
    //Fetching a record from private Database
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    CKDatabase *privateDatabase = [defaultContainer privateCloudDatabase];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Event1" predicate:[NSPredicate predicateWithValue:YES]];
    
    [privateDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (error){
            NSLog(@"ERROR!, %@", error.description);
        }else{            
            for (CKRecord *record in results){
                NSLog(@"record is %@", record.description);
            }
            
            self.objects = [results mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    CKRecord *object = self.objects[indexPath.row];
    cell.textLabel.text = [object objectForKey:@"name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
