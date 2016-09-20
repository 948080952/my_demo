//
//  MainViewController.m
//  DPStackViewDemo
//
//  Created by Dai Pei on 2016/8/3.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "MainViewController.h"
#import "DPStackView.h"
#import "DPStackViewCell.h"

@interface MainViewController ()<DPStackViewDataSource, DPStackViewDelegate>

@property (nonatomic, strong) DPStackView *stackView;
@property (nonatomic, strong) NSMutableArray *tmpArray;
@property (nonatomic, strong) UIBarButtonItem *barButtonItem;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = self.barButtonItem;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.tmpArray = [NSMutableArray arrayWithObjects:[UIColor grayColor], [UIColor greenColor], [UIColor yellowColor], [UIColor blueColor], [UIColor orangeColor], [UIColor redColor], [UIColor cyanColor], nil];
    self.stackView.frame = CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 300);
    [self.view addSubview:self.stackView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.stackView finishSetup];
}

#pragma mark - DPStackViewDataSource

- (DPStackViewCell *)stackView:(DPStackView *)stackView cellForItemAtIndex:(NSUInteger)index withReusableCell:(DPStackViewCell *)cell{
    
    cell.backgroundColor = self.tmpArray[index];
    return cell;
}

- (NSUInteger)numberOfItemsInStackView:(DPStackView *)stackView {
    return [self.tmpArray count];
}


#pragma mark - DPStackViewDelegate

- (void)stackView:(DPStackView *)stackView didSelectAtIndex:(NSUInteger)index {
    NSLog(@"index %lu clicked", (unsigned long)index);
}

- (CGSize)stackView:(DPStackView *)stackView sizeForItemAtIndex:(NSUInteger)index {
    if (index == 1) {
        return CGSizeMake(200, 300);
    }else {
        return CGSizeMake(100, 300);
    }
}

- (void)barButtonClicked {
    [self.tmpArray addObject:[UIColor blackColor]];
    [self.stackView reloadData];
}

#pragma mark - Getter

- (DPStackView *)stackView {
    if (!_stackView) {
        _stackView = [[DPStackView alloc] initWithBounds:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300) delegate:self dataSource:self];
        [_stackView registerCellClass:[DPStackViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _stackView;
}

- (UIBarButtonItem *)barButtonItem {
    if (!_barButtonItem) {
        _barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonClicked)];
    }
    return _barButtonItem;
}

@end
