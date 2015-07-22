//
//  SPCollectionViewController.m
//  SelfPortrait
//
//  Created by Romy on 7/21/15.
//  Copyright © 2015 Romy. All rights reserved.
//

#import "SPCollectionViewController.h"
#import "SPCollectionViewCell.h"
#import "SPLargeCollectionViewCell.h"
#import "SPController.h"
#import "Constants.h"
#import "Photo.h"

static NSString *CollectionCellIdentifier = @"SPCell";
static NSString *LargeCollectionCellIdentifier = @"SPLargeCell";

@interface SPCollectionViewController()
@property (strong, nonatomic) NSString *accessToken;
- (void)refresh;
@end

@implementation SPCollectionViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Selfies";
    self.accessToken = [[SPController shared] getAccessToken];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self refresh];
}

#pragma mark - Custom Methods

- (void)refresh {
    
    __weak typeof(self) weakSelf = self;
    [[SPController shared] loadInstagramPhotosInBackgroundWithTag:@"selfie" withCompletionBlock:^(NSArray *photos, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                typeof(self) strongSelf = weakSelf;
                [strongSelf setPhotos:photos];
                [strongSelf.collectionView reloadData];
            });
        }
    }];
}

#pragma mark - UICollectionViewController Datasource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BOOL isEven = [self isEven:indexPath];
    
    Photo *photo = self.photos[indexPath.row];
    
    if (isEven) {
        SPLargeCollectionViewCell *cell = (SPLargeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:LargeCollectionCellIdentifier forIndexPath:indexPath];
        cell.imageLabel.text = photo.captionText;
        cell.photo = photo;
        cell.delegate = self;
        return cell;
    }
    
    SPCollectionViewCell *cell = (SPCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellIdentifier forIndexPath:indexPath];
    cell.photo = photo;
    cell.delegate = self;
    cell.imageLabel.text = photo.captionText;
    NSLog(@"photo is %@", photo);
    // todo
    return cell;
    
}

- (BOOL)isEven:(NSIndexPath*)indexPath {
    return indexPath.row % 2;
}

#pragma mark - UICollectionViewController Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BOOL isEven = [self isEven:indexPath];
    
    if (isEven) {
        return CGSizeMake(200, 255);
    }
    return CGSizeMake(100, 135);
    
}

#pragma mark - SPCollectionViewCellDelegateProtocol Method(s)

- (void)likeTapped:(void (^)(void))completionBlock {
    // todo
}

@end
