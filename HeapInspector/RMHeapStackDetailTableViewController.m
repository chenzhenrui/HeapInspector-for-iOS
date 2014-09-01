//
//  RMHeapStackDetailTableViewController.m
//  HeapInspectorExample
//
//  Created by Christian Menschel on 29.08.14.
//  Copyright (c) 2014 tapwork. All rights reserved.
//

#import "RMHeapStackDetailTableViewController.h"
#import "RMHeapStackInspector.h"
#import "RMResponderChainViewController.h"
#import "RMShowViewController.h"
#import "RMTableViewCell.h"
#import "RMClassDumpTableViewController.h"

static NSString *const kCellTitleShow = @"Show";
static NSString *const kCellTitleResponderChain = @"Responder Chain";
static NSString *const kCellTitlMethods = @"Methods";
static NSString *const kCellTitlIvars = @"iVars";
static NSString *const kCellTitlProperties = @"Properties";

@interface RMHeapStackDetailTableViewController ()

@end

@implementation RMHeapStackDetailTableViewController
{
    id _inspectingObject;
    NSArray *_dataSource;
}

- (instancetype)initWithPointerString:(NSString *)pointer
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
         // Retrieve a real object from the pointer
        _inspectingObject = [RMHeapStackInspector objectForPointer:pointer];
    }
    return self;
}

- (instancetype)initWithObject:(id)object
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Retrieve a real object from the pointer
        _inspectingObject = object;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[RMTableViewCell class] forCellReuseIdentifier:kTableViewCellIdent];
    [self prepareDataSource];
}

- (void)prepareDataSource
{
    NSMutableArray *dataSource = [@[] mutableCopy];
    
    if ([_inspectingObject isKindOfClass:[UIResponder class]]) {
        [dataSource addObject:kCellTitleResponderChain];
    }
    if ([_inspectingObject isKindOfClass:[UIView class]] ||
        [_inspectingObject isKindOfClass:[UIViewController class]]) {
        [dataSource addObject:kCellTitleShow];
    }
    [dataSource addObject:kCellTitlMethods];
    [dataSource addObject:@"properties & iVars"];
    [dataSource addObject:@"Class hierarchy"];
    
    _dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdent
                                                            forIndexPath:indexPath];
    
    NSString *item = _dataSource[indexPath.row];
    cell.textLabel.text = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *targetController = nil;
    NSString *item = _dataSource[indexPath.row];
    if ([item isEqualToString:kCellTitleResponderChain]) {
        targetController = [[RMResponderChainViewController alloc] initWithObject:_inspectingObject];
    } else if ([item isEqualToString:kCellTitleShow]) {
        targetController = [[RMShowViewController alloc] initWithObject:_inspectingObject];
    } else if ([item isEqualToString:kCellTitlMethods]) {
        targetController = [[RMClassDumpTableViewController alloc] initWithObject:_inspectingObject type:RMClassDumpMethods];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:targetController animated:YES];
}


@end