//
//  MNSDemoTableViewController.m
//  Mensa
//
//  Created by Jonathan Wight on 7/26/13.
//  Copyright (c) 2013 toxicsoftware. All rights reserved.
//

#import "MNSDemoTableViewController.h"
#import "MNSDemoViewController.h"
#import "MNSHostingTableViewCell.h"

#define NUMBER_OF_ROWS 100
#define FONT_SIZE_MAX 105

@interface MNSDemoTableViewController ()

@property (nonatomic) MNSHostingTableViewCell *metricsCell;

@end

@implementation MNSDemoTableViewController

static NSString *cellIdentifier = @"MNSDemoTableViewCell";

- (void)_populateCell:(MNSHostingTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat fontSize = FONT_SIZE_MAX - indexPath.row;
    MNSDemoViewController *viewController = (MNSDemoViewController *)cell.hostedViewController;
    viewController.demoLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    viewController.demoLabel.font = [viewController.demoLabel.font fontWithSize:fontSize];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // MNSHostingTableViewCell dynamically generates a subclass of itself that automatically hosts a view controller of a specific class.
    Class class = [MNSHostingTableViewCell subclassWithViewControllerClass:[MNSDemoViewController class]];
    [self.tableView registerClass:class forCellReuseIdentifier:cellIdentifier];

    // Instead of storing a metrics cell we could just dequeue them as needed off of the table view. But due to the way our hosted cells work we can’t do that here
    self.metricsCell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [self.metricsCell loadHostedView];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // We need to adjust the metrics cell’s frame to handle table width changes (e.g. rotations)
    CGRect theFrame = self.metricsCell.frame;
    theFrame.size.width = self.tableView.bounds.size.width;
    self.metricsCell.frame = theFrame;

    // Set up the metrics cell using real populated content
    [self _populateCell:self.metricsCell forRowAtIndexPath:indexPath];

    // Force a layout
    [self.metricsCell layoutSubviews];

    // Get the layout size; we ignore the width, in fact the width *could* conceivably be zero
    // Note: Using content view is intentional
    CGSize size = [self.metricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return NUMBER_OF_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNSHostingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.parentViewController = self;
    [self _populateCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

@end