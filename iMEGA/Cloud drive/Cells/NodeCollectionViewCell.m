
#import "NodeCollectionViewCell.h"

#import "NSString+MNZCategory.h"
#import "UIImage+MNZCategory.h"

#import "Helper.h"
#import "MEGAGetThumbnailRequestDelegate.h"
#import "MEGANode+MNZCategory.h"
#import "MEGASdkManager.h"
#import "UIImageView+MNZCategory.h"
#import "MEGAStore.h"
#import "MEGA-Swift.h"

static NSString *kFileName = @"kFileName";
static NSString *kFileSize = @"kFileSize";
static NSString *kDuration = @"kDuration";

@interface NodeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *topNodeIconsView;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailIconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIImageView *labelImageView;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *favouriteView;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteImageView;
@property (weak, nonatomic) IBOutlet UIView *versionedView;
@property (weak, nonatomic) IBOutlet UIImageView *versionedImageView;
@property (weak, nonatomic) IBOutlet UIView *linkView;
@property (weak, nonatomic) IBOutlet UIImageView *linkImageView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downloadedImageView;
@property (weak, nonatomic) IBOutlet UIView *downloadedView;

@property (strong, nonatomic) MEGANode *node;
@property (nonatomic, weak) id<NodeCollectionViewCellDelegate> delegate;

@end

@implementation NodeCollectionViewCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.moreButton.hidden && selected) {
        self.selectImageView.image = [UIImage imageNamed:@"thumbnail_selected"];
        self.contentView.layer.borderColor = [UIColor mnz_fromHexString:@"00A886"].CGColor;
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"checkBoxUnselected"];
        switch (self.traitCollection.userInterfaceStyle) {
            case UIUserInterfaceStyleUnspecified:
            case UIUserInterfaceStyleLight: {
                self.contentView.layer.borderColor = [UIColor mnz_fromHexString:@"F7F7F7"].CGColor;
            }
                break;
            case UIUserInterfaceStyleDark: {
                self.contentView.layer.borderColor = [UIColor mnz_fromHexString:@"545458"].CGColor;
            }
        }
    }
}

- (void)configureCellForNode:(MEGANode *)node allowedMultipleSelection:(BOOL)multipleSelection sdk:(MEGASdk *)sdk delegate:(id<NodeCollectionViewCellDelegate> _Nullable)delegate {
    self.node = node;
    self.delegate = delegate;
    if (node.hasThumbnail) {
        NSString *thumbnailFilePath = [Helper pathForNode:node inSharedSandboxCacheDirectory:@"thumbnailsV3"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:thumbnailFilePath]) {
            self.thumbnailImageView.image = [UIImage imageWithContentsOfFile:thumbnailFilePath];
        } else {
            MEGAGetThumbnailRequestDelegate *getThumbnailRequestDelegate = [[MEGAGetThumbnailRequestDelegate alloc] initWithCompletion:^(MEGARequest *request) {
                if (request.nodeHandle == self.node.handle) {
                    self.thumbnailImageView.image = [UIImage imageWithContentsOfFile:request.file];
                }
            }];
            [sdk getThumbnailNode:node destinationFilePath:thumbnailFilePath delegate:getThumbnailRequestDelegate];
            [self.thumbnailImageView mnz_imageForNode:node];
        }
        self.thumbnailIconView.hidden = YES;
    } else {
        self.thumbnailIconView.hidden = NO;
        [self.thumbnailIconView mnz_imageForNode:node];
        self.thumbnailImageView.image = nil;
    }
    
    if (node.isTakenDown) {
        self.nameLabel.attributedText = [node mnz_attributedTakenDownNameWithHeight:self.nameLabel.font.capHeight];
        self.nameLabel.textColor = [UIColor mnz_redForTraitCollection:(self.traitCollection)];
    } else {
        self.nameLabel.text = node.name;
        if (node.isFile) {
            self.infoLabel.text = [Helper sizeForNode:node api:sdk];
        } else if (node.isFolder) {
            self.infoLabel.text = node.isBackupRootNode ? [node numberOfDevicesWithSdk:sdk] : [Helper filesAndFoldersInFolderNode:node api:sdk];
        }
    }
    
    self.labelView.hidden = (node.label == MEGANodeLabelUnknown);
    if (node.label != MEGANodeLabelUnknown) {
        NSString *labelString = [[MEGANode stringForNodeLabel:node.label] stringByAppendingString:@"Small"];
        self.labelImageView.image = [UIImage imageNamed:labelString];
    }
    
    BOOL favouriteIsHidden = !node.isFavourite;
    self.favouriteView.hidden = favouriteIsHidden;
    BOOL versionedIsHidden = ![MEGASdkManager.sharedMEGASdk hasVersionsForNode:node];
    self.versionedView.hidden = versionedIsHidden;
    BOOL linkIsHidden = !node.isExported;
    self.linkView.hidden = linkIsHidden;
    self.topNodeIconsView.hidden = favouriteIsHidden && versionedIsHidden && linkIsHidden;
    
    self.durationLabel.hidden = !node.name.mnz_isVideoPathExtension;
    if (!self.durationLabel.hidden) {
        self.durationLabel.layer.cornerRadius = 4;
        self.durationLabel.layer.masksToBounds = true;
        self.durationLabel.text = node.name.mnz_isVideoPathExtension ? [NSString mnz_stringFromTimeInterval:node.duration] : @"";
    }
    
    if (self.downloadedView != nil) {
        self.downloadedImageView.hidden = self.downloadedView.hidden = !(node.isFile && [[MEGAStore shareInstance] offlineNodeWithNode:node]);
    } else {
        self.downloadedImageView.hidden = !(node.isFile && [[MEGAStore shareInstance] offlineNodeWithNode:node]);
    }

    self.selectImageView.hidden = !multipleSelection;
    self.moreButton.hidden = multipleSelection;
    
    [self setupAppearance];
}

- (void)configureCellForOfflineItem:(NSDictionary *)item itemPath:(NSString *)pathForItem allowedMultipleSelection:(BOOL)multipleSelection sdk:(nonnull MEGASdk *)sdk delegate:(id<NodeCollectionViewCellDelegate> _Nullable)delegate {
    self.favouriteView.hidden = self.linkView.hidden = self.versionedView.hidden = self.topNodeIconsView.hidden = YES;
    self.labelView.hidden = self.downloadedImageView.hidden = self.downloadedView.hidden = YES;
    self.delegate = delegate;
    
    NSString *nameString = item[kFileName];
    
    MOOfflineNode *offNode = [[MEGAStore shareInstance] fetchOfflineNodeWithPath:[Helper pathRelativeToOfflineDirectory:pathForItem]];
    
    self.nameLabel.text = nameString;
    
    NSString *handleString = [offNode base64Handle];
    
    BOOL isDirectory;
    [[NSFileManager defaultManager] fileExistsAtPath:pathForItem isDirectory:&isDirectory];
    if (isDirectory) {
        self.thumbnailIconView.image = UIImage.mnz_folderImage;
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^(void){
            // heavy non-UI work
            FolderContentStat *folderContentStat = [[NSFileManager defaultManager] mnz_folderContentStatWithPathForItem:pathForItem];
            NSInteger files = folderContentStat.fileCount;
            NSInteger folders = folderContentStat.folderCount;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                // update UI
                self.infoLabel.text = [NSString mnz_stringByFiles:files andFolders:folders];
            });
        });
    } else {
        self.infoLabel.text = [Helper memoryStyleStringFromByteCount:[item[kFileSize] longLongValue]];
        NSString *extension = nameString.pathExtension.lowercaseString;
        
        if (!handleString) {
            NSString *fpLocal = [sdk fingerprintForFilePath:pathForItem];
            if (fpLocal) {
                MEGANode *node = [sdk nodeForFingerprint:fpLocal];
                if (node) {
                    handleString = node.base64Handle;
                    [[MEGAStore shareInstance] insertOfflineNode:node api:sdk path:[[Helper pathRelativeToOfflineDirectory:pathForItem] decomposedStringWithCanonicalMapping]];
                }
            }
        }
        
        NSString *thumbnailFilePath = [Helper pathForSharedSandboxCacheDirectory:@"thumbnailsV3"];
        thumbnailFilePath = [thumbnailFilePath stringByAppendingPathComponent:handleString];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:thumbnailFilePath] && handleString) {
            UIImage *thumbnailImage = [UIImage imageWithContentsOfFile:thumbnailFilePath];
            if (thumbnailImage) {
                self.thumbnailImageView.image = thumbnailImage;
            }
            self.thumbnailIconView.hidden = YES;
        } else {
            if (nameString.mnz_isImagePathExtension) {
                if (![[NSFileManager defaultManager] fileExistsAtPath:thumbnailFilePath]) {
                    [sdk createThumbnail:pathForItem destinatioPath:thumbnailFilePath];
                }
                self.thumbnailIconView.hidden = YES;
            } else {
                self.thumbnailIconView.hidden = NO;
                [self.thumbnailIconView mnz_setImageForExtension:extension];
                self.thumbnailImageView.image = nil;
            }
        }
        
    }
    self.nameLabel.text = [sdk unescapeFsIncompatible:nameString destinationPath:[NSHomeDirectory() stringByAppendingString:@"/"]];
    
    self.selectImageView.hidden = !multipleSelection;
    self.moreButton.hidden = multipleSelection;
    self.durationLabel.hidden = !nameString.mnz_isVideoPathExtension;
    if (!self.durationLabel.hidden) {
        self.durationLabel.layer.cornerRadius = 4;
        self.durationLabel.layer.masksToBounds = YES;
        self.durationLabel.text = nameString.mnz_isVideoPathExtension ? [NSString mnz_stringFromTimeInterval:[item[kDuration] doubleValue]] : @"";
    }
    
    self.thumbnailImageView.accessibilityIgnoresInvertColors = YES;
    [self setupAppearance];
}

- (void)configureCellForFolderLinkNode:(MEGANode *)node allowedMultipleSelection:(BOOL)multipleSelection sdk:(nonnull MEGASdk *)sdk delegate:(id<NodeCollectionViewCellDelegate> _Nullable)delegate {
    [self configureCellForNode:node allowedMultipleSelection:multipleSelection sdk:sdk delegate:delegate];
    
    if (self.downloadedImageView != nil) {
        if ([node isFile] && [MEGAStore.shareInstance offlineNodeWithNode:node] != nil) {
            self.downloadedImageView.hidden = NO;
        } else {
            self.downloadedImageView.hidden = YES;
        }
    }
}

- (NSString *)itemName {
    return self.nameLabel.text;
}

- (void)setupAppearance {
    [self setSelected:NO];
    
    switch (self.traitCollection.userInterfaceStyle) {
        case UIUserInterfaceStyleUnspecified:
        case UIUserInterfaceStyleLight: {
            self.topNodeIconsView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
            self.thumbnailImageView.backgroundColor = [UIColor mnz_fromHexString:@"F7F7F7"];
        }
            break;
        case UIUserInterfaceStyleDark: {
            self.topNodeIconsView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            self.thumbnailImageView.backgroundColor = [UIColor mnz_fromHexString:@"1C1C1E"];
        }
    }
}
- (IBAction)optionButtonAction:(id)sender {
    [self.delegate infoTouchUpInside:sender];
}

@end
