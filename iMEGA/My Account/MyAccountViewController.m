/**
 * @file MyAccountViewController.m
 * @brief View controller to see and manage your account details.
 *
 * (c) 2013-2015 by Mega Limited, Auckland, New Zealand
 *
 * This file is part of the MEGA SDK - Client Access Engine.
 *
 * Applications using the MEGA API must present a valid application key
 * and comply with the the rules set forth in the Terms of Service.
 *
 * The MEGA SDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * @copyright Simplified (2-clause) BSD License.
 *
 * You should have received a copy of the license along with this
 * program.
 */

#import "UIImage+GKContact.h"
#import "SVProgressHUD.h"

#import "MEGASdkManager.h"
#import "MEGAReachabilityManager.h"
#import "Helper.h"

#import "MyAccountViewController.h"
#import "UsageViewController.h"
#import "SettingsTableViewController.h"

@interface MyAccountViewController () <MEGARequestDelegate> {
    BOOL isAccountDetailsAvailable;
    
    long long availableSize;
    
    NSNumber *localSize;
    NSNumber *cloudDriveSize;
    NSNumber *rubbishBinSize;
    NSNumber *incomingSharesSize;
    NSNumber *usedStorage;
    NSNumber *maxStorage;
    
    NSByteCountFormatter *byteCountFormatter;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutBarButtonItem;

@property (weak, nonatomic) IBOutlet UIButton *usageButton;
@property (weak, nonatomic) IBOutlet UILabel *usageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UILabel *localLabel;
@property (weak, nonatomic) IBOutlet UILabel *localUsedSpaceLabel;

@property (weak, nonatomic) IBOutlet UILabel *usedLabel;
@property (weak, nonatomic) IBOutlet UILabel *usedSpaceLabel;

@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableSpaceLabel;

@property (weak, nonatomic) IBOutlet UIView *freeView;
@property (weak, nonatomic) IBOutlet UILabel *freeStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *upgradeToProButton;

@property (weak, nonatomic) IBOutlet UIView *proView;
@property (weak, nonatomic) IBOutlet UILabel *proStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *proExpiryDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *purchasesHistoryButton;

@property (strong, nonatomic) NSString *fullname;
@property (nonatomic) MEGAAccountType megaAccountType;
@property (strong, nonatomic) MEGAPricing *pricing;

@end

@implementation MyAccountViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userAvatarImageView.layer.cornerRadius = self.userAvatarImageView.frame.size.width/2;
    self.userAvatarImageView.layer.masksToBounds = YES;
    
    self.upgradeToProButton.layer.borderWidth = 2.0f;
    self.upgradeToProButton.layer.borderColor =[megaRed CGColor];
    self.upgradeToProButton.layer.cornerRadius = 6;
    self.upgradeToProButton.layer.masksToBounds = YES;
    
    _fullname = @"";
    
    [self.navigationItem setTitle:AMLocalizedString(@"myAccount", @"Title of the app section where you can see your account details")];
    
    [self.logoutBarButtonItem setTitle:AMLocalizedString(@"logoutLabel", nil)];
    
    [self.usageLabel setText:AMLocalizedString(@"usage", nil)];
    [self.settingsLabel setText:AMLocalizedString(@"settingsTitle", nil)];
    
    [self.localLabel setText:AMLocalizedString(@"localLabel", @"Local")];
    [self.usedLabel setText:AMLocalizedString(@"usedSpaceLabel", @"Used")];
    [self.availableLabel setText:AMLocalizedString(@"availableLabel", @"Available")];
    
    [self.freeStatusLabel setText:AMLocalizedString(@"free", nil)];
    [self.upgradeToProButton setTitle:AMLocalizedString(@"upgradeAccount", nil) forState:UIControlStateNormal];
    
    [self.purchasesHistoryButton setTitle:AMLocalizedString(@"purchasesHistory", @"Purchases history") forState:UIControlStateNormal];
    
    isAccountDetailsAvailable = NO;
    byteCountFormatter = [[NSByteCountFormatter alloc] init];
    [byteCountFormatter setCountStyle:NSByteCountFormatterCountStyleMemory];
    
    [_emailLabel setText:[[MEGASdkManager sharedMEGASdk] myEmail]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    long long thumbsSize = [Helper sizeOfFolderAtPath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"thumbnailsV3"]];
    long long previewsSize = [Helper sizeOfFolderAtPath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"previewsV3"]];
    long long offlineSize = [Helper sizeOfFolderAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    
    localSize = [NSNumber numberWithLongLong:(thumbsSize + previewsSize + offlineSize)];
    
    NSString *stringFromByteCount = [byteCountFormatter stringFromByteCount:[localSize longLongValue]];
    [_localUsedSpaceLabel setAttributedText:[self textForSizeLabels:stringFromByteCount]];
    
    _fullname = @"";
    
    [[MEGASdkManager sharedMEGASdk] getUserAttibuteType:MEGAUserAttributeFirstname delegate:self];
    [[MEGASdkManager sharedMEGASdk] getUserAttibuteType:MEGAUserAttributeLastname delegate:self];
    
    [[MEGASdkManager sharedMEGASdk] getPricingWithDelegate:self];
    [[MEGASdkManager sharedMEGASdk] getAccountDetailsWithDelegate:self];
    
    [self setUserAvatar];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Private

- (void)setUserAvatar {
    MEGAUser *user = [[MEGASdkManager sharedMEGASdk] contactForEmail:self.emailLabel.text];
    NSString *avatarFilePath = [Helper pathForUser:user searchPath:NSCachesDirectory directory:@"thumbnailsV3"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:avatarFilePath];
    
    if (!fileExists) {
        [self.userAvatarImageView setImage:[UIImage imageForName:[user email].uppercaseString size:CGSizeMake(88, 88)]];
        [[MEGASdkManager sharedMEGASdk] getAvatarUser:user destinationFilePath:avatarFilePath delegate:self];
    } else {
        [self.userAvatarImageView setImage:[UIImage imageWithContentsOfFile:avatarFilePath]];
    }
}

- (NSMutableAttributedString *)textForSizeLabels:(NSString *)stringFromByteCount {
    
    NSMutableAttributedString *firstPartMutableAttributedString;
    NSMutableAttributedString *secondPartMutableAttributedString;
    
    NSString *firstPartString = [self stringWithoutUnit:stringFromByteCount];
    NSRange firstPartRange;
    
    NSArray *stringComponentsArray = [firstPartString componentsSeparatedByString:@","];
    NSString *secondPartString;
    if ([stringComponentsArray count] > 1) {
        NSString *integerPartString = [stringComponentsArray objectAtIndex:0];
        NSString *fractionalPartString = [stringComponentsArray objectAtIndex:1];
        firstPartMutableAttributedString = [[NSMutableAttributedString alloc] initWithString:integerPartString];
        firstPartRange = [integerPartString rangeOfString:integerPartString];
        secondPartString = [NSString stringWithFormat:@".%@ %@", fractionalPartString, [self stringWithoutCount:stringFromByteCount]];
    } else {
        firstPartMutableAttributedString = [[NSMutableAttributedString alloc] initWithString:firstPartString];
        firstPartRange = [firstPartString rangeOfString:firstPartString];
        secondPartString = [NSString stringWithFormat:@" %@", [self stringWithoutCount:stringFromByteCount]];
    }
    NSRange secondPartRange = [secondPartString rangeOfString:secondPartString];
    secondPartMutableAttributedString = [[NSMutableAttributedString alloc] initWithString:secondPartString];
    
    [firstPartMutableAttributedString addAttribute:NSFontAttributeName
                                             value:[UIFont fontWithName:kFont size:20.0]
                                             range:firstPartRange];
    
    [secondPartMutableAttributedString addAttribute:NSFontAttributeName
                                              value:[UIFont fontWithName:kFont size:12.0]
                                              range:secondPartRange];
    
    [firstPartMutableAttributedString appendAttributedString:secondPartMutableAttributedString];
    
    return firstPartMutableAttributedString;
}

- (NSString *)stringWithoutUnit:(NSString *)stringFromByteCount {
    
    NSString *string = [[stringFromByteCount componentsSeparatedByString:@" "] objectAtIndex:0];
    if ([string isEqualToString:@"Zero"] || ([string length] == 0)) {
        string = @"0";
    }
    return string;
}

- (NSString *)stringWithoutCount:(NSString *)stringFromByteCount {
    
    NSArray *componentsSeparatedByStringArray = [stringFromByteCount componentsSeparatedByString:@" "];
    NSString *string;
    
    if (componentsSeparatedByStringArray.count == 1) {
        string = @"KB";
    } else {
        string = [componentsSeparatedByStringArray objectAtIndex:1];
        
        if ([string isEqualToString:@"bytes"] || ([string length] == 0)) {
            string = @"KB";
        }
    }
    
    return string;
}

#pragma mark - IBActions

- (IBAction)logoutTouchUpInside:(UIBarButtonItem *)sender {
    if ([MEGAReachabilityManager isReachable]) {
        [[MEGASdkManager sharedMEGASdk] logout];
    } else {
        [SVProgressHUD showImage:[UIImage imageNamed:@"hudForbidden"] status:AMLocalizedString(@"noInternetConnection", nil)];
    }
}

- (IBAction)usageTouchUpInside:(UIButton *)sender {
    
    if (isAccountDetailsAvailable) {
        NSArray *sizesArray = @[cloudDriveSize, rubbishBinSize, incomingSharesSize, usedStorage, maxStorage];
        
        UsageViewController *usageVC = [[UIStoryboard storyboardWithName:@"MyAccount" bundle:nil] instantiateViewControllerWithIdentifier:@"UsageViewControllerID"];
        [self.navigationController pushViewController:usageVC animated:YES];
        
        [usageVC setSizesArray:sizesArray];
    }
}

- (IBAction)settingsTouchUpInside:(UIButton *)sender {
    [Helper changeToViewController:[SettingsTableViewController class] onTabBarController:self.tabBarController];
}

#pragma mark - MEGARequestDelegate

- (void)onRequestStart:(MEGASdk *)api request:(MEGARequest *)request {
}

- (void)onRequestFinish:(MEGASdk *)api request:(MEGARequest *)request error:(MEGAError *)error {
    if ([error type]) {
        return;
    }
    
    switch ([request type]) {
        case MEGARequestTypeGetAttrUser: {
            //If paramType = 1 or 2 we are receiving the firstname or the lastname
            if (request.paramType) {
                if (request.paramType == MEGAUserAttributeLastname) {
                    _fullname = [_fullname stringByAppendingString:@" "];
                }
                
                if(request.text){
                    _fullname = [_fullname stringByAppendingString:request.text];
                }
                [self.nameLabel setText:_fullname];
            } else {
                [self setUserAvatar];
            }
            break;
        }
            
        case MEGARequestTypeAccountDetails: {
            self.megaAccountType = [[request megaAccountDetails] type];
            
            cloudDriveSize = [[request megaAccountDetails] storageUsedForHandle:[[[MEGASdkManager sharedMEGASdk] rootNode] handle]];
            rubbishBinSize = [[request megaAccountDetails] storageUsedForHandle:[[[MEGASdkManager sharedMEGASdk] rubbishNode] handle]];
            
            MEGANodeList *incomingShares = [[MEGASdkManager sharedMEGASdk] inShares];
            NSUInteger count = [incomingShares.size unsignedIntegerValue];
            long long incomingSharesSizeLongLong = 0;
            for (NSUInteger i = 0; i < count; i++) {
                MEGANode *node = [incomingShares nodeAtIndex:i];
                incomingSharesSizeLongLong += [[[MEGASdkManager sharedMEGASdk] sizeForNode:node] longLongValue];
            }
            incomingSharesSize = [NSNumber numberWithLongLong:incomingSharesSizeLongLong];
            
            usedStorage = [request.megaAccountDetails storageUsed];
            maxStorage = [request.megaAccountDetails storageMax];
            
            NSString *usedStorageString = [byteCountFormatter stringFromByteCount:[usedStorage longLongValue]];
            NSString *availableStorageString = [byteCountFormatter stringFromByteCount:([maxStorage longLongValue] - [usedStorage longLongValue])];
            
            [_usedSpaceLabel setAttributedText:[self textForSizeLabels:usedStorageString]];
            [_availableSpaceLabel setAttributedText:[self textForSizeLabels:availableStorageString]];
            
            NSString *expiresString;
            if ([request.megaAccountDetails type]) {
                [_freeView setHidden:YES];
                [_proView setHidden:NO];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy'-'MM'-'dd'"];
                NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                [formatter setLocale:locale];
                NSDate *expireDate = [[NSDate alloc] initWithTimeIntervalSince1970:[request.megaAccountDetails proExpiration]];
                
                expiresString = [NSString stringWithFormat:AMLocalizedString(@"expiresOn", @"(Expires on %@)"), [formatter stringFromDate:expireDate]];
            } else {
                [_proView setHidden:YES];
                [_freeView setHidden:NO];
            }
            
            switch ([request.megaAccountDetails type]) {
                case MEGAAccountTypeFree: {
                    break;
                }
                    
                case MEGAAccountTypeLite: {
                    [_proStatusLabel setText:[NSString stringWithFormat:@"PRO LITE"]];
                    [_proExpiryDateLabel setText:[NSString stringWithFormat:@"%@", expiresString]];
                    break;
                }
                    
                case MEGAAccountTypeProI: {
                    [_proStatusLabel setText:[NSString stringWithFormat:@"PRO I"]];
                    [_proExpiryDateLabel setText:[NSString stringWithFormat:@"%@", expiresString]];
                    break;
                }
                    
                case MEGAAccountTypeProII: {
                    [_proStatusLabel setText:[NSString stringWithFormat:@"PRO II"]];
                    [_proExpiryDateLabel setText:[NSString stringWithFormat:@"%@", expiresString]];
                    break;
                }
                    
                case MEGAAccountTypeProIII: {
                    [_proStatusLabel setText:[NSString stringWithFormat:@"PRO III"]];
                    [_proExpiryDateLabel setText:[NSString stringWithFormat:@"%@", expiresString]];
                    break;
                }
                    
                default:
                    break;
            }
            
            isAccountDetailsAvailable = YES;
            
            break;
        }
            
        case MEGARequestTypeGetPricing: {
            self.pricing = [request pricing];
            [_upgradeToProButton setUserInteractionEnabled:YES];
            break;
        }
            
        default:
            break;
    }
}

@end
