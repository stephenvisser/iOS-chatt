//
//  AMBViewController.m
//  Chat
//
//  Created by Stephen Visser on 2014-03-15.
//  Copyright (c) 2014 Stephen Visser. All rights reserved.
//

#import "AMBViewController.h"
#import <Parse/Parse.h>

@interface AMBViewController ()
@property NSArray *results;
@property IBOutlet UITextField *text;
@property IBOutlet UITableView *tableView;

- (IBAction)submit:(id)sender;

@end

@implementation AMBViewController

- (void) reload {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query addDescendingOrder:@"_created_at"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.results = objects;
        [self.tableView reloadData];
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.results = [NSArray array];
    [self reload];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
	// Do any additional setup after loading the view, typically from a nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    NSDictionary *obj = [self.results objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj objectForKey:@"text"];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    PFObject *newObj = [PFObject objectWithClassName:@"Message"];
    [newObj setObject:self.text.text forKey:@"text"];
    [newObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self reload];
    }];
}
@end
