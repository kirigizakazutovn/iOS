
#import "NotificationsTableViewController.h"

#import "DTConstants.h"
#import "UIScrollView+EmptyDataSet.h"

#import "ContactDetailsViewController.h"
#import "ContactsViewController.h"
#import "ContactRequestsViewController.h"
#import "EmptyStateView.h"
#import "Helper.h"
#import "MainTabBarController.h"
#import "MEGANode+MNZCategory.h"
#import "MEGAReachabilityManager.h"
#import "MEGASDKManager.h"
#import "MEGAStore.h"
#import "MEGA-Swift.h"
#import "MEGAUser+MNZCategory.h"
#import "MEGAUserAlert.h"
#import "MEGAUserAlertList+MNZCategory.h"
#import "NotificationTableViewCell.h"
#import "SharedItemsViewController.h"

@interface NotificationsTableViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, MEGAGlobalDelegate>

@property (nonatomic) NSArray *userAlertsArray;
@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation NotificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    self.navigationItem.title = NSLocalizedString(@"notifications", nil);
    self.userAlertsArray = [MEGASdkManager sharedMEGASdk].userAlertList.mnz_relevantUserAlertsArray;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterLongStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor mnz_separatorForTraitCollection:self.traitCollection];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internetConnectionChanged) name:kReachabilityChangedNotification object:nil];
    
    [[MEGASdkManager sharedMEGASdk] addMEGAGlobalDelegate:self];
    [[MEGAReachabilityManager sharedManager] retryPendingConnections];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[MEGASdkManager sharedMEGASdk] removeMEGAGlobalDelegate:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[MEGASdkManager sharedMEGASdk] acknowledgeUserAlerts];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        self.tableView.separatorColor = [UIColor mnz_separatorForTraitCollection:self.traitCollection];
        [self.tableView reloadData];
    }
}

#pragma mark - Private

- (void)configureTypeLabel:(UILabel *)typeLabel forType:(MEGAUserAlertType)type {
    switch (type) {
        case MEGAUserAlertTypeIncomingPendingContactRequest:
        case MEGAUserAlertTypeIncomingPendingContactCancelled:
        case MEGAUserAlertTypeIncomingPendingContactReminder:
        case MEGAUserAlertTypeContactChangeDeletedYou:
        case MEGAUserAlertTypeContactChangeContactEstablished:
        case MEGAUserAlertTypeContactChangeAccountDeleted:
        case MEGAUserAlertTypeContactChangeBlockedYou:
        case MEGAUserAlertTypeUpdatePendingContactIncomingIgnored:
        case MEGAUserAlertTypeUpdatePendingContactIncomingAccepted:
        case MEGAUserAlertTypeUpdatePendingContactIncomingDenied:
        case MEGAUserAlertTypeUpdatePendingContactOutgoingAccepted:
        case MEGAUserAlertTypeUpdatePendingContactOutgoingDenied:
            typeLabel.text = NSLocalizedString(@"contactsTitle", @"Title of the Contacts section").localizedUppercaseString;
            typeLabel.textColor = [UIColor mnz_turquoiseForTraitCollection:self.traitCollection];
            break;
            
        case MEGAUserAlertTypeNewShare:
        case MEGAUserAlertTypeDeletedShare:
        case MEGAUserAlertTypeNewShareNodes:
        case MEGAUserAlertTypeRemovedSharesNodes:
            typeLabel.text = NSLocalizedString(@"shared", @"Title of the tab bar item for the Shared Items section").localizedUppercaseString;
            typeLabel.textColor = UIColor.systemOrangeColor;
            break;
            
        case MEGAUserAlertTypePaymentSucceeded:
        case MEGAUserAlertTypePaymentFailed:
            typeLabel.text = NSLocalizedString(@"Payment info", @"The header of a notification related to payments").localizedUppercaseString;
            typeLabel.textColor = [UIColor mnz_redForTraitCollection:(self.traitCollection)];
            break;
            
        case MEGAUserAlertTypePaymentReminder:
            typeLabel.text = NSLocalizedString(@"PRO membership plan expiring soon", @"A title for a notification saying the user’s pricing plan will expire soon.").localizedUppercaseString;
            typeLabel.textColor = [UIColor mnz_redForTraitCollection:(self.traitCollection)];
            break;
            
        case MEGAUserAlertTypeTakedown:
            typeLabel.text = NSLocalizedString(@"Takedown notice", @"The header of a notification indicating that a file or folder has been taken down due to infringement or other reason.").localizedUppercaseString;
            typeLabel.textColor = [UIColor mnz_redForTraitCollection:(self.traitCollection)];
            break;
            
        case MEGAUserAlertTypeTakedownReinstated:
            typeLabel.text = NSLocalizedString(@"Takedown reinstated", @"The header of a notification indicating that a file or folder that was taken down has now been restored due to a successful counter-notice.").localizedUppercaseString;
            typeLabel.textColor = [UIColor mnz_redForTraitCollection:(self.traitCollection)];
            break;
            
        default:
            typeLabel.text = nil;
            break;
    }
}

- (void)configureHeadingLabel:(UILabel *)headingLabel forAlert:(MEGAUserAlert *)userAlert {
    switch (userAlert.type) {
        case MEGAUserAlertTypeIncomingPendingContactRequest:
        case MEGAUserAlertTypeIncomingPendingContactCancelled:
        case MEGAUserAlertTypeIncomingPendingContactReminder:
        case MEGAUserAlertTypeContactChangeDeletedYou:
        case MEGAUserAlertTypeContactChangeContactEstablished:
        case MEGAUserAlertTypeContactChangeAccountDeleted:
        case MEGAUserAlertTypeContactChangeBlockedYou:
        case MEGAUserAlertTypeUpdatePendingContactIncomingIgnored:
        case MEGAUserAlertTypeUpdatePendingContactIncomingAccepted:
        case MEGAUserAlertTypeUpdatePendingContactIncomingDenied:
        case MEGAUserAlertTypeUpdatePendingContactOutgoingAccepted:
        case MEGAUserAlertTypeUpdatePendingContactOutgoingDenied:
        case MEGAUserAlertTypeNewShare:
        case MEGAUserAlertTypeDeletedShare:
        case MEGAUserAlertTypeNewShareNodes:
        case MEGAUserAlertTypeRemovedSharesNodes: {
            if (userAlert.email) {
                headingLabel.hidden = NO;
                MOUser *user = [[MEGAStore shareInstance] fetchUserWithEmail:userAlert.email];
                NSString *displayName = user.displayName;
                if (displayName.length > 0) {
                    headingLabel.text = [NSString stringWithFormat:@"%@ (%@)", displayName, user.email];
                } else {
                    headingLabel.text = userAlert.email;
                }
            } else {
                headingLabel.hidden = YES;
                headingLabel.text = nil;
            }
            break;
        }
            
        default: {
            headingLabel.hidden = YES;
            headingLabel.text = nil;
            break;
        }
    }
}

- (void)configureContentLabel:(UILabel *)contentLabel forAlert:(MEGAUserAlert *)userAlert {
    UIFont *boldFont = [UIFont mnz_preferredFontWithStyle:UIFontTextStyleFootnote weight:UIFontWeightBold];
    
    switch (userAlert.type) {
        case MEGAUserAlertTypeIncomingPendingContactRequest:
            contentLabel.text = NSLocalizedString(@"Sent you a contact request", @"When a contact sent a contact/friend request");
            break;
            
        case MEGAUserAlertTypeIncomingPendingContactCancelled:
            contentLabel.text = NSLocalizedString(@"Cancelled their contact request", @"A notification that the other user cancelled their contact request so it is no longer valid. E.g. user@email.com cancelled their contact request.");
            break;
            
        case MEGAUserAlertTypeIncomingPendingContactReminder:
            contentLabel.text = NSLocalizedString(@"Reminder: You have a contact request", @"A reminder notification to remind the user to respond to the contact request.");
            break;
            
        case MEGAUserAlertTypeContactChangeDeletedYou:
            contentLabel.text = NSLocalizedString(@"Deleted you as a contact", @"A notification telling the user that the other user deleted them as a contact. E.g. user@email.com deleted you as a contact.");
            break;
            
        case MEGAUserAlertTypeContactChangeContactEstablished:
            contentLabel.text = NSLocalizedString(@"Contact relationship established", @"A notification telling the user that they are now fully connected with the other user (the users are in each other’s address books).");
            break;
            
        case MEGAUserAlertTypeContactChangeAccountDeleted:
            contentLabel.text = NSLocalizedString(@"Account has been deleted/deactivated", @"A notification telling the user that one of their contact’s accounts has been deleted or deactivated.");
            break;
            
        case MEGAUserAlertTypeContactChangeBlockedYou:
            contentLabel.text = NSLocalizedString(@"Blocked you as a contact", @"A notification telling the user that another user blocked them as a contact (they will no longer be able to contact them). E.g. name@email.com blocked you as a contact.");
            break;
            
        case MEGAUserAlertTypeUpdatePendingContactIncomingIgnored:
            contentLabel.text = NSLocalizedString(@"You ignored a contact request", @"Response text after clicking Ignore on an incoming contact request notification.");
            break;
            
        case MEGAUserAlertTypeUpdatePendingContactIncomingAccepted:
            contentLabel.text = NSLocalizedString(@"You accepted a contact request", @"Response text after clicking Accept on an incoming contact request notification.");
            break;
            
        case MEGAUserAlertTypeUpdatePendingContactIncomingDenied:
            contentLabel.text = NSLocalizedString(@"You denied a contact request", @"Response text after clicking Deny on an incoming contact request notification.");
            break;
            
        case MEGAUserAlertTypeUpdatePendingContactOutgoingAccepted:
            contentLabel.text = NSLocalizedString(@"Accepted your contact request", @"When somebody accepted your contact request");
            break;
            
        case MEGAUserAlertTypeUpdatePendingContactOutgoingDenied:
            contentLabel.text = NSLocalizedString(@"Denied your contact request", @"When somebody denied your contact request");
            break;
            
        case MEGAUserAlertTypeNewShare:
            contentLabel.text = NSLocalizedString(@"newSharedFolder", @"Notification text body shown when you have received a new shared folder");
            break;
            
        case MEGAUserAlertTypeDeletedShare: {
            MEGANode *node = [[MEGASdkManager sharedMEGASdk] nodeForHandle:userAlert.nodeHandle];
            if ([userAlert numberAtIndex:0] == 0) {
                NSAttributedString *nodeName = [[NSAttributedString alloc] initWithString:node.name ?: @""  attributes:@{ NSFontAttributeName : boldFont }];
                NSString *text = NSLocalizedString(@"A user has left the shared folder {0}", @"notification text");
                NSRange range = [text rangeOfString:@"{0}"];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
                [attributedText replaceCharactersInRange:range withAttributedString:nodeName];
                contentLabel.attributedText = attributedText;
            } else {
                contentLabel.text = NSLocalizedString(@"Access to folders was removed.", @"This is shown in the Notification dialog when the email address of a contact is not found and access to the share is lost for some reason (e.g. share removal or contact removal).");
            }
            break;
        }
            
        case MEGAUserAlertTypeNewShareNodes: {
            int64_t fileCount = [userAlert numberAtIndex:1];
            int64_t folderCount = [userAlert numberAtIndex:0];
            NSString *text;
            if ((folderCount > 1) && (fileCount > 1)) {
                text = [[NSLocalizedString(@"Added [A] files and [B] folders", @"Content of a notification that informs how many files and folders have been added to a shared folder") stringByReplacingOccurrencesOfString:@"[A]" withString:[NSString stringWithFormat:@"%lld", fileCount]] stringByReplacingOccurrencesOfString:@"[B]" withString:[NSString stringWithFormat:@"%lld", folderCount]];
            }
            else if ((folderCount > 1) && (fileCount == 1)) {
                text = [NSString stringWithFormat:NSLocalizedString(@"Added 1 file and %lld folders", @"Content of a notification that informs how many files and folders have been added to a shared folder"), folderCount];
            }
            else if ((folderCount == 1) && (fileCount > 1)) {
                text = [NSString stringWithFormat:NSLocalizedString(@"Added %lld files and 1 folder", @"Content of a notification that informs how many files and folders have been added to a shared folder"), fileCount];
            }
            else if ((folderCount == 1) && (fileCount == 1)) {
                text = NSLocalizedString(@"Added 1 file and 1 folder", @"Content of a notification that informs how many files and folders have been added to a shared folder");
            }
            else if (folderCount > 1) {
                text = [NSString stringWithFormat:NSLocalizedString(@"Added %lld folders", @"Content of a notification that informs how many files and folders have been added to a shared folder"), folderCount];
            }
            else if (fileCount > 1) {
                text = [NSString stringWithFormat:NSLocalizedString(@"Added %lld files", @"Content of a notification that informs how many files and folders have been added to a shared folder"), fileCount];
            }
            else if (folderCount == 1) {
                text = NSLocalizedString(@"Added 1 folder", @"Content of a notification that informs how many files and folders have been added to a shared folder");
            }
            else if (fileCount == 1) {
                text = NSLocalizedString(@"Added 1 file", @"Content of a notification that informs how many files and folders have been added to a shared folder");
            } else {
                text = userAlert.title;
            }
            contentLabel.text = text;
            break;
        }
            
        case MEGAUserAlertTypeRemovedSharesNodes: {
            int64_t itemCount = [userAlert numberAtIndex:0];
            if (itemCount == 1) {
                contentLabel.text = NSLocalizedString(@"Removed item from shared folder", @"Notification when on client side when owner of a shared folder removes folder/file from it.");
            } else {
                contentLabel.text = [NSLocalizedString(@"Removed [X] items from a share", @"Notification popup. Notification for multiple removed items from a share. Please keep [X] as it will be replaced at runtime with the number of removed items.") stringByReplacingOccurrencesOfString:@"[X]" withString:[NSString stringWithFormat:@"%lld", itemCount]];
            }
            break;
        }
            
        case MEGAUserAlertTypePaymentSucceeded: {
            NSString *proPlanString = [userAlert stringAtIndex:0] ? [userAlert stringAtIndex:0] : @"";
            NSAttributedString *proPlan = [[NSAttributedString alloc] initWithString:proPlanString attributes:@{ NSFontAttributeName : boldFont }];
            NSString *text = NSLocalizedString(@"Your payment for the %1 plan was received.", @"A notification telling the user that their Pro plan payment was successfully received. The %1 indicates the name of the Pro plan they paid for e.g. Lite, PRO III.");
            NSRange range = [text rangeOfString:@"%1"];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
            [attributedText replaceCharactersInRange:range withAttributedString:proPlan];
            contentLabel.attributedText = attributedText;
            break;
        }
            
        case MEGAUserAlertTypePaymentFailed: {
            NSString *proPlanString = [userAlert stringAtIndex:0] ? [userAlert stringAtIndex:0] : @"";
            NSAttributedString *proPlan = [[NSAttributedString alloc] initWithString:proPlanString attributes:@{ NSFontAttributeName : boldFont }];
            NSString *text = NSLocalizedString(@"Your payment for the %1 plan was unsuccessful.", @"A notification telling the user that their Pro plan payment was unsuccessful. The %1 indicates the name of the Pro plan they were trying to pay for e.g. Lite, PRO II.");
            NSRange range = [text rangeOfString:@"%1"];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
            [attributedText replaceCharactersInRange:range withAttributedString:proPlan];
            contentLabel.attributedText = attributedText;
            break;
        }
            
        case MEGAUserAlertTypePaymentReminder: {
            NSInteger days = ([userAlert timestampAtIndex:1] - [NSDate date].timeIntervalSince1970) / SECONDS_IN_DAY;
            NSString *text;
            if (days == 1) {
                text = NSLocalizedString(@"Your PRO membership plan will expire in 1 day.", @"The professional pricing plan which the user is currently on will expire in one day.");
            } else if (days >= 0) {
                text = [NSLocalizedString(@"Your PRO membership plan will expire in %1 days.", @"The professional pricing plan which the user is currently on will expire in 5 days. The %1 is a placeholder for the number of days and should not be removed.") stringByReplacingOccurrencesOfString:@"%1" withString:[NSString stringWithFormat:@"%td", days]];
            } else if (days == -1) {
                text = NSLocalizedString(@"Your PRO membership plan expired 1 day ago", @"The professional pricing plan which the user was on expired one day ago.");
            } else {
                text = [NSLocalizedString(@"Your PRO membership plan expired %1 days ago", @"The professional pricing plan which the user was on expired %1 days ago. The %1 is a placeholder for the number of days and should not be removed.") stringByReplacingOccurrencesOfString:@"%1" withString:[NSString stringWithFormat:@"%td", days]];
            }
            contentLabel.text = text;
            break;
        }
            
        case MEGAUserAlertTypeTakedown: {
            MEGANode *node = [[MEGASdkManager sharedMEGASdk] nodeForHandle:userAlert.nodeHandle];
            NSString *nodeType = @"";
            if (node.type == MEGANodeTypeFile) {
                nodeType = NSLocalizedString(@"file", nil);
            } else if (node.type == MEGANodeTypeFolder) {
                nodeType = NSLocalizedString(@"folder", nil);
            }
            NSAttributedString *nodeName = [NSAttributedString.alloc initWithString:node.name ?: @"" attributes:@{ NSFontAttributeName : boldFont }];
            NSString *text = NSLocalizedString(@"Your publicly shared %1 (%2) has been taken down.", @"The text of a notification indicating that a file or folder has been taken down due to infringement or other reason. The %1 placeholder will be replaced with the text ‘file’ or ‘folder’. The %2 will be replaced with the name of the file or folder.");
            text = [text stringByReplacingOccurrencesOfString:@"%1" withString:nodeType.lowercaseString];
            NSRange range = [text rangeOfString:@"%2"];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
            [attributedText replaceCharactersInRange:range withAttributedString:nodeName];
            contentLabel.attributedText = attributedText;
            break;
        }
            
        case MEGAUserAlertTypeTakedownReinstated:{
            MEGANode *node = [[MEGASdkManager sharedMEGASdk] nodeForHandle:userAlert.nodeHandle];
            NSString *nodeType = @"";
            if (node.type == MEGANodeTypeFile) {
                nodeType = NSLocalizedString(@"file", nil);
            } else if (node.type == MEGANodeTypeFolder) {
                nodeType = NSLocalizedString(@"folder", nil);
            }
            NSAttributedString *nodeName = [NSAttributedString.alloc initWithString:node.name ?: @"" attributes:@{ NSFontAttributeName : boldFont }];
            NSString *text = NSLocalizedString(@"Your taken down %1 (%2) has been reinstated.", @"The text of a notification indicating that a file or folder that was taken down has now been restored due to a successful counter-notice. The %1 placeholder will be replaced with the text ‘file’ or ‘folder’. The %2 will be replaced with the name of the file or folder.");
            text = [text stringByReplacingOccurrencesOfString:@"%1" withString:nodeType.lowercaseString];
            NSRange range = [text rangeOfString:@"%2"];
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
            [attributedText replaceCharactersInRange:range withAttributedString:nodeName];
            contentLabel.attributedText = attributedText;
            break;
        }
            
        default:
            contentLabel.text = userAlert.title;
            break;
    }
}

- (void)internetConnectionChanged {
    if ([MEGAReachabilityManager isReachable]) {
        self.userAlertsArray = [MEGASdkManager sharedMEGASdk].userAlertList.mnz_relevantUserAlertsArray;
    } else {
        self.userAlertsArray = @[];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userAlertsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationTableViewCell *cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
    
    MEGAUserAlert *userAlert = [self.userAlertsArray objectAtIndex:indexPath.row];
    
    [self configureTypeLabel:cell.typeLabel forType:userAlert.type];
    if (userAlert.isSeen) {
        cell.theNewView.hidden = YES;
        cell.backgroundColor = [UIColor mnz_notificationSeenBackgroundForTraitCollection:self.traitCollection];
    } else {
        cell.theNewView.hidden = NO;
        cell.backgroundColor = [UIColor mnz_tertiaryBackground:self.traitCollection];
    }
    [self configureHeadingLabel:cell.headingLabel forAlert:userAlert];
    [self configureContentLabel:cell.contentLabel forAlert:userAlert];
    cell.dateLabel.textColor = [UIColor mnz_primaryGrayForTraitCollection:self.traitCollection];
    cell.dateLabel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[userAlert timestampAtIndex:0]]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MEGAUserAlert *userAlert = [self.userAlertsArray objectAtIndex:indexPath.row];
    MEGANode *node = [[MEGASdkManager sharedMEGASdk] nodeForHandle:userAlert.nodeHandle];
    UINavigationController *navigationController = self.navigationController;
    
    switch (userAlert.type) {
        case MEGAUserAlertTypeIncomingPendingContactRequest:
        case MEGAUserAlertTypeIncomingPendingContactReminder: {
            if ([[MEGASdkManager sharedMEGASdk] incomingContactRequests].size.intValue) {
                ContactRequestsViewController *contactRequestsVC = [[UIStoryboard storyboardWithName:@"Contacts" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactsRequestsViewControllerID"];
                
                [self.navigationController pushViewController:contactRequestsVC animated:YES];
            }
            break;
        }
            
        case MEGAUserAlertTypeIncomingPendingContactCancelled:
        case MEGAUserAlertTypeContactChangeDeletedYou:
        case MEGAUserAlertTypeContactChangeAccountDeleted:
        case MEGAUserAlertTypeContactChangeBlockedYou:
        case MEGAUserAlertTypeUpdatePendingContactIncomingIgnored:
        case MEGAUserAlertTypeUpdatePendingContactIncomingDenied:
        case MEGAUserAlertTypeUpdatePendingContactOutgoingDenied:
            break;
        
        case MEGAUserAlertTypeContactChangeContactEstablished:
        case MEGAUserAlertTypeUpdatePendingContactIncomingAccepted:
        case MEGAUserAlertTypeUpdatePendingContactOutgoingAccepted: {
            MEGAUser *user = [[MEGASdkManager sharedMEGASdk] contactForEmail:userAlert.email];
            if (user && user.visibility == MEGAUserVisibilityVisible) {
                [navigationController popToRootViewControllerAnimated:NO];
                ContactsViewController *contactsVC = [[UIStoryboard storyboardWithName:@"Contacts" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactsViewControllerID"];
                contactsVC.avoidPresentIncomingPendingContactRequests = YES;
                ContactDetailsViewController *contactDetailsVC = [[UIStoryboard storyboardWithName:@"Contacts" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactDetailsViewControllerID"];
                contactDetailsVC.contactDetailsMode = ContactDetailsModeDefault;
                contactDetailsVC.userEmail = user.email;
                contactDetailsVC.userName = user.mnz_fullName;
                contactDetailsVC.userHandle = user.handle;
                [navigationController pushViewController:contactsVC animated:NO];
                [navigationController pushViewController:contactDetailsVC animated:YES];
            }
            break;
        }
            
        case MEGAUserAlertTypeNewShare:
        case MEGAUserAlertTypeDeletedShare:
        case MEGAUserAlertTypeNewShareNodes:
        case MEGAUserAlertTypeRemovedSharesNodes:
        case MEGAUserAlertTypeTakedown:
        case MEGAUserAlertTypeTakedownReinstated: {
            if (node) {
                [node navigateToParentAndPresent];
            }
            break;
        }
            
        case MEGAUserAlertTypePaymentSucceeded:
        case MEGAUserAlertTypePaymentFailed:
        case MEGAUserAlertTypePaymentReminder: {
            [UpgradeAccountRouter.new pushUpgradeTVCWithNavigationController:self.navigationController];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - DZNEmptyDataSetSource

- (nullable UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    EmptyStateView *emptyStateView = [EmptyStateView.alloc initWithImage:[self imageForEmptyState] title:[self titleForEmptyState] description:[self descriptionForEmptyState] buttonTitle:[self buttonTitleForEmptyState]];
    [emptyStateView.button addTarget:self action:@selector(buttonTouchUpInsideEmptyState) forControlEvents:UIControlEventTouchUpInside];
    
    return emptyStateView;
}

- (NSString *)titleForEmptyState {
    NSString *text = @"";
    if ([MEGAReachabilityManager isReachable]) {
        text = NSLocalizedString(@"No notifications",  @"There are no notifications to display.");
    } else {
        text = NSLocalizedString(@"noInternetConnection",  @"No Internet Connection");
    }
    return text;
}

- (NSString *)descriptionForEmptyState {
    NSString *text = @"";
    if (!MEGAReachabilityManager.isReachable && !MEGAReachabilityManager.sharedManager.isMobileDataEnabled) {
        text = NSLocalizedString(@"Mobile Data is turned off", @"Information shown when the user has disabled the 'Mobile Data' setting for MEGA in the iOS Settings.");
    }
    
    return text;
}

- (UIImage *)imageForEmptyState {
    UIImage *image;
    if ([MEGAReachabilityManager isReachable]) {
        image = [UIImage imageNamed:@"notificationsEmptyState"];
    } else {
        image = [UIImage imageNamed:@"noInternetEmptyState"];
    }
    return image;
}

- (NSString *)buttonTitleForEmptyState {
    NSString *text = @"";
    if (!MEGAReachabilityManager.isReachable && !MEGAReachabilityManager.sharedManager.isMobileDataEnabled) {
        text = NSLocalizedString(@"Turn Mobile Data on", @"Button title to go to the iOS Settings to enable 'Mobile Data' for the MEGA app.");
    }
    
    return text;
}

- (void)buttonTouchUpInsideEmptyState {
    if (!MEGAReachabilityManager.isReachable && !MEGAReachabilityManager.sharedManager.isMobileDataEnabled) {
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }
}

#pragma mark - MEGAGlobalDelegate

- (void)onUserAlertsUpdate:(MEGASdk *)api userAlertList:(MEGAUserAlertList *)userAlertList {
    self.userAlertsArray = api.userAlertList.mnz_relevantUserAlertsArray;
    [self.tableView reloadData];
}

@end
