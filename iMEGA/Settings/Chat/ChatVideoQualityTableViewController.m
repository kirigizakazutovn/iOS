
#import "ChatVideoQualityTableViewController.h"

#import "MEGA-Swift.h"

#import "ChatVideoUploadQuality.h"

@interface ChatVideoQualityTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *mediumLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalLabel;

@property (weak, nonatomic) NSIndexPath *currentChatVideoQualityIndexPath;

@end

@implementation ChatVideoQualityTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"videoQuality", @"Title that refers to the quality of the chat (Either Online or Offline)");
    
    _lowLabel.text = NSLocalizedString(@"low", @"Low");
    _mediumLabel.text = NSLocalizedString(@"medium", nil);
    _highLabel.text = NSLocalizedString(@"high", @"High");
    _originalLabel.text = NSLocalizedString(@"original", @"Original");
    
    [self updateAppearance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ChatVideoUploadQuality videoQuality = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ChatVideoQuality"] unsignedIntegerValue];
    
    switch (videoQuality) {
        case ChatVideoUploadQualityLow:
            _currentChatVideoQualityIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            break;
            
        case ChatVideoUploadQualityMedium:
            _currentChatVideoQualityIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            break;
            
        case ChatVideoUploadQualityHigh:
            _currentChatVideoQualityIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            break;
            
        case ChatVideoUploadQualityOriginal:
            _currentChatVideoQualityIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            break;
            
        default:
            break;
    }
    
    SelectableTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentChatVideoQualityIndexPath];
    cell.redCheckmarkImageView.hidden = NO;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self updateAppearance];
    }
}

#pragma mark - Private

- (void)updateAppearance {
    self.tableView.separatorColor = [UIColor mnz_separatorForTraitCollection:self.traitCollection];
    self.tableView.backgroundColor = [UIColor mnz_backgroundGroupedForTraitCollection:self.traitCollection];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor mnz_secondaryBackgroundGrouped:self.traitCollection];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.currentChatVideoQualityIndexPath == indexPath) {
        return;
    } else {
        SelectableTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentChatVideoQualityIndexPath];
        cell.redCheckmarkImageView.hidden = YES;
        self.currentChatVideoQualityIndexPath = indexPath;
    }
    
    switch (indexPath.row) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:@(ChatVideoUploadQualityLow) forKey:@"ChatVideoQuality"];
            break;
            
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:@(ChatVideoUploadQualityMedium) forKey:@"ChatVideoQuality"];
            break;
            
        case 2:
            [[NSUserDefaults standardUserDefaults] setObject:@(ChatVideoUploadQualityHigh) forKey:@"ChatVideoQuality"];
            break;
            
        case 3:
            [[NSUserDefaults standardUserDefaults] setObject:@(ChatVideoUploadQualityOriginal) forKey:@"ChatVideoQuality"];
            break;
            
        default:
            break;
    }
        
    SelectableTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.redCheckmarkImageView.hidden = NO;
}

@end
