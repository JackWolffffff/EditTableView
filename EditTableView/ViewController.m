//
//  ViewController.m
//  EditTableView
//
//  Created by RongJun on 15/10/16.
//  Copyright © 2015年 RJ. All rights reserved.
//

#import "ViewController.h"
#import "MyCell.h"
#import "MyCell2.h"


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *ttableView;

@end

@implementation ViewController

{

    NSInteger selectedIndex; //存储当前展开的cell的indexpath
    NSInteger selectedSection;
    BOOL isChoosing; //记录展开按钮是否被点击
    CGFloat wholeTextHeight; //全文本高度
    CGSize size; //内容size
    CGRect cellFrame; //存储当前要展开的cell的frame
    
    NSString * sourceString; //要显示的字符串
    
    NSInteger cellCount; //存储返回的cell的个数
}

@synthesize ttableView;

-(void) initTableView {

    ttableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30) style:(UITableViewStylePlain)];
    
    ttableView.delegate = self;
    ttableView.dataSource = self;
    
    [ttableView registerClass:[MyCell class] forCellReuseIdentifier:@"cell"];
    [ttableView registerClass:[MyCell2 class] forCellReuseIdentifier:@"cell2"];
    
    ttableView.editing = NO;
    
    ttableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:ttableView];

}

-(void) initData {

    selectedIndex = -1;
    sourceString =  @"222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222";
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton * insertCellBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width/2, 30)];
    insertCellBtn.tag = 1;
    [insertCellBtn setTitle:@"插入cell" forState:(UIControlStateNormal)];
    [insertCellBtn.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
    insertCellBtn.backgroundColor = [UIColor greenColor];
    
    [insertCellBtn addTarget:self action:@selector(insertOrDelItem:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [self.view addSubview:insertCellBtn];
    
    UIButton * delCellBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 64, self.view.frame.size.width/2, 30)];
    delCellBtn.tag = 2;
    [delCellBtn setTitle:@"删除cell" forState:(UIControlStateNormal)];
    [delCellBtn.titleLabel setTextAlignment:(NSTextAlignmentCenter)];
    delCellBtn.backgroundColor = [UIColor redColor];
    
    [delCellBtn addTarget:self action:@selector(insertOrDelItem:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [self.view addSubview:delCellBtn];
    
    cellCount = 20;

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewCellEditingStyleInsert;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableViewDelegate&TableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return cellCount;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    MyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[MyCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        
    }
    __weak typeof (cell) weakCell = cell;
    
    if (selectedIndex != indexPath.row) {
        
        cell.myString = [sourceString substringToIndex:21];
        
    } else {
        
        cell.myString = sourceString;

    }

//    防止循环引用
    
    cell.myBlock = ^(NSInteger tag) {
        
        if (selectedIndex != -1 && selectedIndex != indexPath.row) {
            isChoosing = NO;
            [tableView reloadData];
            selectedIndex = -1;
        } else {
        
            NSArray * array = @[indexPath];
            selectedIndex = indexPath.row;
            
            NSLog(@"contentViewHeight:%.2f", weakCell.frame.size.height);
            
            if (cell.frame.size.height > 44) {
                
                size = [[sourceString substringToIndex:20] boundingRectWithSize:CGSizeMake(cell.frame.size.width, MAXFLOAT) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
                
                cellFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 44);
                
                NSLog(@"contentViewHeight:%.2f", weakCell.frame.size.height);
                
                isChoosing = NO;
                wholeTextHeight = 44;
                selectedIndex = -1;
                selectedSection = -1;
                
                weakCell.myString = sourceString;
                weakCell.isOpen = isChoosing;
                weakCell.frame = cellFrame;
                
                [UIView animateWithDuration:0.5 animations:^{
//                    weakCell.myButton.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            } else {
                
                size = [sourceString boundingRectWithSize:CGSizeMake(cell.frame.size.width/2, MAXFLOAT) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
                
                cellFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, size.height);
                
                NSLog(@"contentViewHeight:%.2f", weakCell.frame.size.height);
            
                selectedIndex = indexPath.row;
                selectedSection = indexPath.section;
                isChoosing = YES;
                wholeTextHeight = size.height;
                
                weakCell.myString = sourceString;
                weakCell.isOpen = isChoosing;
                weakCell.frame = cellFrame;
                
                [UIView animateWithDuration:0.5 animations:^{
                   
//                    weakCell.myButton.transform = CGAffineTransformMakeRotation(0);
                    
                }];
                
            }
    
//            [self.ttableView reloadRowsAtIndexPaths:array withRowAnimation:(UITableViewRowAnimationNone)];
            [ttableView reloadData];
        }
        
        
    
    };
    
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (isChoosing && selectedIndex == indexPath.row) {
        
        return wholeTextHeight;
        
    } else {
    
        return 44;
        
    }
    return wholeTextHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //如果当前是选中状态，点击cell之后重置tableview
    if (isChoosing) {
    
        NSIndexPath * ii = [NSIndexPath indexPathForRow:selectedIndex inSection:selectedSection];
        
        [tableView reloadRowsAtIndexPaths:@[ii] withRowAnimation:(UITableViewRowAnimationFade)];
    
        selectedIndex = -1;
        isChoosing = NO;
        [tableView reloadData];
    }

}

-(void) insertOrDelItem:(UIButton *)sender {

    //插入cell之前先重新加载tableview
    [ttableView reloadData];
    
    NSIndexPath * i = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    
    NSArray * indexArray = @[i];
    
    if (sender.tag != cellCount-1) {
        [ttableView beginUpdates];
        
        if (sender.tag == 1) {
            cellCount ++;
            [ttableView insertRowsAtIndexPaths:indexArray withRowAnimation:(UITableViewRowAnimationNone)];
        } else {
            cellCount--;
            [ttableView deleteRowsAtIndexPaths:indexArray withRowAnimation:(UITableViewRowAnimationNone)];
            
        }
        
        [ttableView endUpdates];
        
        if (sender.tag == 1) {
            [ttableView reloadRowsAtIndexPaths:indexArray withRowAnimation:(UITableViewRowAnimationNone)];
            
        } else {
            
            [ttableView reloadRowsAtIndexPaths:indexArray withRowAnimation:(UITableViewRowAnimationNone)];
            
        }
    }
    
}



@end
