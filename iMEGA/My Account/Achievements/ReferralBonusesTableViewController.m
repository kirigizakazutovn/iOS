
#import "ReferralBonusesTableViewController.h"

#import "NSDate+DateTools.h"

#import "Helper.h"
#import "MEGAGetAttrUserRequestDelegate.h"
#import "MEGASdkManager.h"
#import "MEGAStore.h"
#import "MEGAUser+MNZCategory.h"
#import "UIImageView+MNZCategory.h"

#import "AchievementsTableViewCell.h"

@interface ReferralBonusesTableViewController () <UITableViewDataSource>

@property (nonatomic) NSMutableArray *inviteAchievementsIndexesMutableArray;
@property (nonatomic) NSMutableArray *inviteAchievementsEmailsMutableArray;

@end

@implementation ReferralBonusesTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView.alloc initWithFrame:CGRectZero];
    
    self.navigationItem.title = NSLocalizedString(@"account.achievement.referralBonus.title", nil);
    
    self.inviteAchievementsIndexesMutableArray = [[NSMutableArray alloc] init];
    NSUInteger awardsCount = self.achievementsDetails.awardsCount;
    for (NSUInteger i = 0; i < awardsCount; i++) {
        MEGAAchievement achievementClass = [self.achievementsDetails awardClassAtIndex:i];
        if (achievementClass == MEGAAchievementInvite) {
            [self.inviteAchievementsIndexesMutableArray addObject:[NSNumber numberWithInteger:i]];
        }
    }
    
    self.inviteAchievementsEmailsMutableArray = [[NSMutableArray alloc] init];
    for (NSNumber *index in self.inviteAchievementsIndexesMutableArray) {
        MEGAStringList *stringList = [self.achievementsDetails awardEmailsAtIndex:index.unsignedIntegerValue];
        NSString *email = [stringList stringAtIndex:0];
        [self.inviteAchievementsEmailsMutableArray addObject:email];
    }
    
    [self updateAppearance];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self updateAppearance];
        
        [self.tableView reloadData];
    }
}

#pragma mark - Private

- (void)updateAppearance {
    self.view.backgroundColor = UIColor.mnz_background;
    self.tableView.separatorColor = [UIColor mnz_separatorForTraitCollection:self.traitCollection];
}

- (void)setStorageQuotaRewardsForCell:(AchievementsTableViewCell *)cell withAwardId:(NSInteger)awardId {
    long long classStorageReward = [self.achievementsDetails rewardStorageByAwardId:awardId];
    
    cell.storageQuotaRewardView.backgroundColor = cell.storageQuotaRewardLabel.backgroundColor = ((classStorageReward == 0) ? [UIColor mnz_tertiaryGrayForTraitCollection:self.traitCollection] : [UIColor mnz_blueForTraitCollection:self.traitCollection]);
    cell.storageQuotaRewardLabel.text = (classStorageReward == 0) ? @"— GB" : [Helper memoryStyleStringFromByteCount:classStorageReward];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.inviteAchievementsEmailsMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"ContactReferralAchievementTableViewCellID";
    AchievementsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AchievementsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString *email = [self.inviteAchievementsEmailsMutableArray objectAtIndex:indexPath.row];
    MEGAUser *user = [[MEGASdkManager sharedMEGASdk] contactForEmail:email];
    
    if (user) {
        [cell.avatarImageView mnz_setImageForUserHandle:user.handle];
        cell.titleLabel.text = user.mnz_displayName;
    } else {
        MOUser *moUser = [[MEGAStore shareInstance] fetchUserWithEmail:email];
        if (moUser) {
            [cell.avatarImageView mnz_setImageForUserHandle:MEGAInvalidHandle name:moUser.fullName];
            cell.titleLabel.text = moUser.displayName;
        } else {
            [cell.avatarImageView mnz_setImageForUserHandle:MEGAInvalidHandle];
            cell.titleLabel.text = @"";
            MEGAGetAttrUserRequestDelegate *delegate = [[MEGAGetAttrUserRequestDelegate alloc] initWithCompletion:^(MEGARequest *request) {
                [tableView reloadData];
            }];
            [[MEGASdkManager sharedMEGASdk] getUserAttributeForEmailOrHandle:email type:MEGAUserAttributeFirstname delegate:delegate];
            [[MEGASdkManager sharedMEGASdk] getUserAttributeForEmailOrHandle:email type:MEGAUserAttributeLastname delegate:delegate];
        }
    }
    
    NSInteger inviteIndexPath = [[self.inviteAchievementsIndexesMutableArray objectAtIndex:indexPath.row] integerValue];
    NSInteger awardId = [self.achievementsDetails awardIdAtIndex:inviteIndexPath];
    [self setStorageQuotaRewardsForCell:cell withAwardId:awardId];
    
    NSDate *awardExpirationdDate = [self.achievementsDetails awardExpirationAtIndex:inviteIndexPath];
    cell.daysLeftTrailingLabel.text = [NSString stringWithFormat:NSLocalizedString(@"account.achievement.complete.valid.cell.subtitle", nil), [NSString stringWithFormat:@"%td", awardExpirationdDate.daysUntil]];
    cell.daysLeftTrailingLabel.textColor = (awardExpirationdDate.daysUntil <= 15) ? [UIColor mnz_redForTraitCollection:(self.traitCollection)] : [UIColor mnz_primaryGrayForTraitCollection:self.traitCollection];
    
    return cell;
}

@end
