//
//  AZLFileListViewController.m
//  ALExampleTest
//
//  Created by yangming on 2018/9/19.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AZLFileListViewController.h"
#import "AZLFileHelper.h"
//#import "AZLPopupFactory.h"
#import "AZLFileTextViewController.h"

@interface AZLFileListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AZLFileObject *fileObject;


@property (nonatomic, strong) UIImage *folderImg;
@property (nonatomic, strong) UIImage *fileImg;


@property (nonatomic, strong) NSDateFormatter *fileDateFormatter;

@end

@implementation AZLFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fileDateFormatter = [[NSDateFormatter alloc] init];
    [self.fileDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AZLFileHelper" ofType:@"bundle"]];
    
    self.folderImg = [[UIImage alloc] initWithContentsOfFile:[bundle pathForResource:@"folder" ofType:@"png"]];
    self.fileImg = [[UIImage alloc] initWithContentsOfFile:[bundle pathForResource:@"file" ofType:@"png"]];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.rowHeight = 44;
    self.tableView.sectionHeaderHeight = 44;
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    if (self.folderPath == nil) {
        self.folderPath = [AZLFileHelper sandBoxPath];
    }
    
    self.fileObject = [AZLFileHelper fileObjectAtPath:self.folderPath isAll:NO];
    
    [self.tableView reloadData];
    
    self.title = self.fileObject.name;
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(createFileOrFolder)];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createFileOrFolder{
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //添加取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionController addAction:cancelAction];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"新建文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self createFile];
        
    }];
    [actionController addAction:action];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"新建文件夾" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self createFolder];
        
    }];
    [actionController addAction:action2];
    
    
    [self presentViewController:actionController animated:YES completion:nil];
    
}


- (void)createFile{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"新建文件" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入文件名字";
    }];
    
    //添加取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *content = [alertController.textFields[0] text];
        if (content.length > 0) {
            for (AZLFileObject *enuObject in self.fileObject.subPaths) {
                if ([enuObject.name isEqualToString:content]) {
                    return;
                }
            }
            NSString *newPath = [AZLFileHelper createFileAtPath:self.folderPath fileName:content];
            if (newPath) {
                AZLFileObject *fileObject = [[AZLFileObject alloc] init];
                fileObject.name = content;
                fileObject.fullPath = newPath;
                fileObject.type = AZLFileTypeFile;
                fileObject.subPaths = @[];
                NSMutableArray *mutArray = [[NSMutableArray alloc] initWithArray:self.fileObject.subPaths];
                [mutArray addObject:fileObject];
                self.fileObject.subPaths = mutArray;
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:mutArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                
            }
        }

    }];
    [alertController addAction:okAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)createFolder{

UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"新建文件夹" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入文件夹名字";
    }];
    
    //添加取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *content = [alertController.textFields[0] text];
        if (content.length > 0) {
            for (AZLFileObject *enuObject in self.fileObject.subPaths) {
                if ([enuObject.name isEqualToString:content]) {
                    return;
                }
            }
            NSString *newPath = [AZLFileHelper createFolderAtPath:self.folderPath folderName:content];
            if (newPath) {
                AZLFileObject *fileObject = [[AZLFileObject alloc] init];
                fileObject.name = content;
                fileObject.fullPath = newPath;
                fileObject.type = AZLFileTypeFolder;
                fileObject.subPaths = @[];
                NSMutableArray *mutArray = [[NSMutableArray alloc] initWithArray:self.fileObject.subPaths];
                [mutArray addObject:fileObject];
                self.fileObject.subPaths = mutArray;
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:mutArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                
            }
        }
    }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.fileObject.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.fileObject.subPaths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FileCell"];
    }
    
    AZLFileObject *fileObject = self.fileObject.subPaths[indexPath.row];
    
    cell.textLabel.text = fileObject.name;
    cell.detailTextLabel.text = [self.fileDateFormatter stringFromDate:fileObject.modifyDate];
    if (fileObject.type == AZLFileTypeFolder) {
        cell.imageView.image = self.folderImg;
    }else{
        cell.imageView.image = self.fileImg;
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    AZLFileObject *fileObject = self.fileObject.subPaths[indexPath.row];
    
    if (fileObject.type == AZLFileTypeFolder) {
        AZLFileListViewController *controller = [[AZLFileListViewController alloc] init];
        controller.folderPath = fileObject.fullPath;
        
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        AZLFileTextViewController *controller = [[AZLFileTextViewController alloc] init];
        controller.filePath = fileObject.fullPath;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath\
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"刪除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AZLFileObject *fileObject = self.fileObject.subPaths[indexPath.row];
        
        BOOL isSuccess = [AZLFileHelper deleteWithPath:fileObject.fullPath];
        if (isSuccess) {
            NSMutableArray *mutArray = [[NSMutableArray alloc] initWithArray:self.fileObject.subPaths];
            
            [mutArray removeObjectAtIndex:indexPath.row];
            self.fileObject.subPaths = mutArray;
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
