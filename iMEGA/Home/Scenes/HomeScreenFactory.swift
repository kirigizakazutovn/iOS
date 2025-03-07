import Foundation

@objc
final class HomeScreenFactory: NSObject {

    @objc func createHomeScreen(from tabBarController: MainTabBarController) -> UIViewController {
        let homeViewController = HomeViewController()
        let navigationController = MEGANavigationController(rootViewController: homeViewController)

        let myAvatarViewModel = MyAvatarViewModel(
            megaNotificationUseCase: MEGANotificationUseCase(
                userAlertsClient: .live
            ),
            megaAvatarUseCase: MEGAavatarUseCase(
                megaAvatarClient: .live,
                avatarFileSystemClient: .live,
                megaUserClient: .live,
                fileRepo: FileSystemRepository.default
            ),
            megaAvatarGeneratingUseCase: MEGAAavatarGeneratingUseCase(
                storeUserClient: .live,
                megaAvatarClient: .live,
                megaUserClient: .live
            )
        )

        let uploadViewModel = HomeUploadingViewModel(
            uploadFilesUseCase: HomeUploadFileUseCase(
                uploadFromAlbum: .live,
                uploadFromURL: .live,
                uploadFromLocalPath: .live
            ),
            devicePermissionUseCase: DevicePermissionRequestUseCase(
                photoPermission: .live,
                devicePermission: .live
            ),
            reachabilityUseCase: ReachabilityUseCase(),
            router: FileUploadingRouter(navigationController: navigationController, baseViewController: homeViewController)
        )

        homeViewController.myAvatarViewModel = myAvatarViewModel
        homeViewController.uploadViewModel = uploadViewModel
        homeViewController.startConversationViewModel = StartConversationViewModel(
            reachabilityUseCase: ReachabilityUseCase(),
            router: NewChatRouter(
                navigationController: navigationController,
                tabBarController: tabBarController
            )
        )
        homeViewController.recentsViewModel = HomeRecentActionViewModel(
            devicePermissionUseCase: .live,
            nodeFavouriteActionUseCase: NodeFavouriteActionUseCase(
                nodeFavouriteRepository: NodeFavouriteActionRepository()
            )
        )
        homeViewController.bannerViewModel = HomeBannerViewModel(
            userBannerUseCase: UserBannerUseCase(
                userBannerRepository: BannerRepository(sdk: MEGASdkManager.sharedMEGASdk())
            ),
            router: HomeBannerRouter(navigationController: navigationController)
        )

        homeViewController.quickAccessWidgetViewModel = QuickAccessWidgetViewModel(offlineFilesUseCase: OfflineFilesUseCase(repo: OfflineFilesRepository(store: MEGAStore.shareInstance())))
        
        navigationController.tabBarItem = UITabBarItem(title: nil, image: Asset.Images.TabBarIcons.home.image, selectedImage: nil)

        homeViewController.searchResultViewController = createSearchResultViewController(with: navigationController)

        let router = HomeRouter(navigationController: navigationController, tabBarController: tabBarController)
        homeViewController.router = router

        return navigationController
    }

    private func createSearchResultViewController(
        with navigationController: UINavigationController
    ) -> HomeSearchResultViewController {

        let searchResultViewModel = HomeSearchResultViewModel(
            searchFileUseCase: SearchFileUseCase(
                nodeSearchClient: .live,
                searchFileHistoryUseCase: SearchFileHistoryUseCase(
                    fileSearchHistoryRepository: .live
                )
            ),
            searchFileHistoryUseCase: SearchFileHistoryUseCase(
                fileSearchHistoryRepository: .live
            ),
            nodeDetailUseCase: NodeDetailUseCase(
                sdkNodeClient: .live,
                nodeThumbnailHomeUseCase: NodeThumbnailHomeUseCase(
                    sdkNodeClient: .live,
                    fileSystemClient: .live,
                    fileRepo: FileSystemRepository.default
                )
            ),
            router: HomeSearchResultRouter(
                navigationController: navigationController,
                nodeActionViewControllerDelegate: NodeActionViewControllerGenericDelegate(
                viewController: navigationController
                )
            )
        )

        let homeSearchResultViewController = HomeSearchResultViewController()
        homeSearchResultViewController.viewModel = searchResultViewModel
        homeSearchResultViewController.resultTableViewDataSource
            = TableViewProxy<HomeSearchResultFileViewModel>(
                cellIdentifier: "SearchResultFile",
                emptyStateConfiguration: .searchResult,
                configureCell: { cell, model in
                    (cell as? SearchResultFileTableViewCell)?.configure(with: model)
                },
                selectionAction: { selectedNode in
                    searchResultViewModel.didSelectNode(selectedNode.handle)
                }
            )


        homeSearchResultViewController.hintTableViewDataSource = TableViewProxy<HomeSearchHintViewModel>(
            cellIdentifier: "SearchHint",
            emptyStateConfiguration: .searchHints,
            configureCell: { cell, model in
                (cell as? SearchHintTableViewCell)?.configure(with: model)
            },
            selectionAction: { selectedSearchHint in
                searchResultViewModel.didSelectHint(selectedSearchHint.text)
            }
        )
        return homeSearchResultViewController
    }
}
