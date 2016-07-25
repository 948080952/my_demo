//
//  ViewController.m
//  FontTest
//
//  Created by Dai Pei on 16/7/25.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initView];
}

#pragma mark - ConfigView

- (void)initView {
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [UIFont familyNames].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *familyName = [[UIFont familyNames] objectAtIndex:section];
    
    return [UIFont fontNamesForFamilyName:familyName].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSString *familyName = [[UIFont familyNames] objectAtIndex:indexPath.section];
    NSString *fontName = [[UIFont fontNamesForFamilyName:familyName] objectAtIndex:indexPath.row];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:fontName size:18];
    label.text = [NSString stringWithFormat:@"DaiPei \n%@", fontName];
    label.frame = CGRectMake(20, 0, self.view.frame.size.width - 20, 80);
    
    [cell.contentView addSubview:label];
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *familyName = [[UIFont familyNames] objectAtIndex:section];
    UILabel *header = [[UILabel alloc] init];
    
    header.font = [UIFont systemFontOfSize:15];
    header.text = familyName;
    
    return header;
}

#pragma mark - UITableViewDelegate


#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80.f;
        _tableView.sectionHeaderHeight = 20.f;
        _tableView.frame = self.view.frame;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
