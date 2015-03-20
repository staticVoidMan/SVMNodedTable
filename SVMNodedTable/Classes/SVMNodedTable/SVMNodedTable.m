//
//  SVMNodedTable.m
//  SVMNodedTable
//
//  Created by staticVoidMan on 18/03/15.
//  Copyright (c) 2015 staticVoidMan. All rights reserved.
//

#import "SVMNodedTable.h"
#import "SVMFolderCell.h"
#import "SVMDataCell.h"

@interface SVMNodedTable () <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableView_Noded;
    
    NSMutableDictionary *dictNodes;
    NSMutableArray *arrDatasource;
}
@end

@implementation SVMNodedTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createData];
//    [self logDataAsJSON];
    [self createDatasource];
}

-(void)createData {
    dictNodes = [self createNodeWithTitle:nil
                                   cellID:nil
                                  payload:nil
                               asExpanded:YES];
    
    [self addBaseNode:[self createNodeWithTitle:@"A"
                                         cellID:@"SVMFolderCell"
                                        payload:nil
                                     asExpanded:NO]];
    [self addChildNode:[self createNodeWithTitle:@" A-1"
                                          cellID:@"SVMFolderCell"
                                         payload:nil
                                      asExpanded:NO]
                toNode:dictNodes[@"content"][0]];
    [self addChildNode:[self createNodeWithTitle:@"  A-1-A"
                                          cellID:@"SVMDataCell"
                                         payload:@{@"firstKey":@"1",
                                                   @"secondKey":@"2"}
                                      asExpanded:NO]
                toNode:dictNodes[@"content"][0][@"content"][0]];
    [self addChildNode:[self createNodeWithTitle:@"  A-1-B"
                                          cellID:@"SVMDataCell"
                                         payload:@{@"firstKey":@"3",
                                                   @"secondKey":@"4"}
                                      asExpanded:NO]
                toNode:dictNodes[@"content"][0][@"content"][0]];
    [self addChildNode:[self createNodeWithTitle:@" A-2"
                                          cellID:@"SVMFolderCell"
                                         payload:@{@"firstKey":@"5",
                                                   @"secondKey":@"6"}
                                      asExpanded:NO]
                toNode:dictNodes[@"content"][0]];
    [self addChildNode:[self createNodeWithTitle:@"  A-2-A"
                                          cellID:@"SVMDataCell"
                                         payload:@{@"firstKey":@"7",
                                                   @"secondKey":@"8"}
                                      asExpanded:NO]
                toNode:dictNodes[@"content"][0][@"content"][1]];
    [self addChildNode:[self createNodeWithTitle:@"  A-2-B"
                                          cellID:@"SVMDataCell"
                                         payload:@{@"firstKey":@"9",
                                                   @"secondKey":@"10"}
                                      asExpanded:NO]
                toNode:dictNodes[@"content"][0][@"content"][1]];
    
    [self addBaseNode:[self createNodeWithTitle:@"B"
                                         cellID:@"SVMFolderCell"
                                        payload:nil
                                     asExpanded:NO]];
    [self addChildNode:[self createNodeWithTitle:@" B-1"
                                          cellID:@"SVMFolderCell"
                                         payload:nil
                                      asExpanded:NO]
                toNode:dictNodes[@"content"][1]];
    [self addChildNode:[self createNodeWithTitle:@"  B-1-A"
                                          cellID:@"SVMDataCell"
                                         payload:@{@"firstKey":@"11",
                                                   @"secondKey":@"12"}
                                      asExpanded:NO]
                toNode:dictNodes[@"content"][1][@"content"][0]];
    [self addChildNode:[self createNodeWithTitle:@"  B-1-B"
                                          cellID:@"SVMDataCell"
                                         payload:@{@"firstKey":@"13",
                                                   @"secondKey":@"14"}
                                      asExpanded:NO]
                toNode:dictNodes[@"content"][1][@"content"][0]];
    [self addChildNode:[self createNodeWithTitle:@" B-2"
                                          cellID:@"SVMFolderCell"
                                         payload:nil
                                      asExpanded:NO]
                toNode:dictNodes[@"content"][1]];
    [self addChildNode:[self createNodeWithTitle:@"  B-2-A"
                                          cellID:@"SVMDataCell"
                                         payload:@{@"firstKey":@"15",
                                                   @"secondKey":@"16"}
                                      asExpanded:NO]
                toNode:dictNodes[@"content"][1][@"content"][1]];
    [self addChildNode:[self createNodeWithTitle:@"  B-2-B"
                                          cellID:@"SVMDataCell"
                                         payload:@{@"firstKey":@"17",
                                                   @"secondKey":@"18"}
                                      asExpanded:NO]
                toNode:dictNodes[@"content"][1][@"content"][1]];
}

#pragma mark - Node Methods
-(NSMutableDictionary *)createNodeWithTitle:(NSString *)strTitle cellID:(NSString *)strCellID payload:(NSDictionary *)payload asExpanded:(BOOL)isExpanded {
    if(strTitle == nil) {
        strTitle = @"";
    }
    if (strCellID == nil) {
        strCellID = @"";
    }
    if (payload == nil) {
        payload = @{};
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:strTitle forKey:@"title"];
    [dictionary setObject:strCellID forKey:@"cellID"];
    [dictionary setObject:@(isExpanded) forKey:@"isExpanded"];
    [dictionary setObject:[payload mutableCopy] forKey:@"payload"];
    [dictionary setObject:[[NSMutableArray alloc] init] forKey:@"content"];
    
    return dictionary;
}

-(void)addBaseNode:(NSMutableDictionary *)node {
    [dictNodes[@"content"] addObject:node];
}

-(void)addChildNode:(NSMutableDictionary *)nodeChild toNode:(NSMutableDictionary *)nodeParent {
    NSMutableArray *array = nodeParent[@"content"];
    [array addObject:nodeChild];
}

#pragma mark - Helper Methods
-(void)createDatasource {
    arrDatasource = nil;
    arrDatasource = [[NSMutableArray alloc] init];
    
    [self flattenNodesFrom:dictNodes];
    [arrDatasource removeObjectAtIndex:0];
}

//Recursive DFS Method
-(void)flattenNodesFrom:(NSMutableDictionary *)dictionary {    
    [arrDatasource addObject:dictionary];
    
    if([dictionary[@"isExpanded"] boolValue]) {
        NSMutableArray *array = dictionary[@"content"];
        for (int i = 0; i < array.count; i++) {
            [self flattenNodesFrom:array[i]];
        }
    }
}

-(void)logDataAsJSON {
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:dictNodes options:0 error:nil];
    NSString *strJSON = [[NSString alloc] initWithData:dataJSON encoding:NSStringEncodingConversionAllowLossy];
    
    NSLog(@"%@",strJSON);
}

#pragma mark - UITableView Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrDatasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *strClassName = arrDatasource[indexPath.row][@"cellID"];
    
    if ([strClassName isEqualToString:@"SVMFolderCell"]) {
        SVMFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SVMFolderCell"];
        
        [cell.lblTitle setText:arrDatasource[indexPath.row][@"title"]];
        
        if ([arrDatasource[indexPath.row][@"isExpanded"] boolValue]) {
            [cell.lblIndicator setText:@"🔽"];
        }
        else {
            [cell.lblIndicator setText:@"▶️"];
        }
        
        return cell;
    }
    else if([strClassName isEqualToString:@"SVMDataCell"]) {
        SVMDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SVMDataCell"];
        
        [cell.lblTitle setText:arrDatasource[indexPath.row][@"title"]];
        [cell.lbl_1 setText:arrDatasource[indexPath.row][@"payload"][@"firstKey"]];
        [cell.lbl_2 setText:arrDatasource[indexPath.row][@"payload"][@"secondKey"]];
        
        return cell;
    }
    
    UITableViewCell *cell;
    return cell;
}

#pragma mark - UITableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL test = [arrDatasource[indexPath.row][@"isExpanded"] boolValue];
    [arrDatasource[indexPath.row] setObject:@(!test) forKey:@"isExpanded"];
    
    [self createDatasource];
    [tableView reloadData];
}

@end
