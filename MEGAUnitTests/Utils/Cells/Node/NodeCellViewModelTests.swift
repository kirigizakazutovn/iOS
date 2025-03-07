import XCTest
@testable import MEGA

final class NodeCellViewModelTests: XCTestCase {
    
    func testAction_initForReuse() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .initForReuse,
             expectedCommands: [.config(mockNodeModel)])
    }
    
    func testAction_manageLabel_unknown() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .manageLabel,
             expectedCommands: [.hideLabel(true)])
        XCTAssertEqual(mockNodeModel.label, .unknown)
    }
    
    func testAction_manageLabel_red() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity(label: .red)
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.labelString = Asset.Images.Labels.redSmall.name
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .manageLabel,
             expectedCommands: [.hideLabel(false),
                                .setLabel(mockNodeActionUC.labelString)])
        XCTAssertEqual(mockNodeModel.label, .red)
    }
    
    func testAction_manageLabel_orange() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity(label: .orange)
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.labelString = Asset.Images.Labels.orangeSmall.name
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .manageLabel,
             expectedCommands: [.hideLabel(false),
                                .setLabel(mockNodeActionUC.labelString)])
        XCTAssertEqual(mockNodeModel.label, .orange)
    }
    
    func testAction_manageLabel_yellow() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity(label: .yellow)
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.labelString = Asset.Images.Labels.yellowSmall.name
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .manageLabel,
             expectedCommands: [.hideLabel(false),
                                .setLabel(mockNodeActionUC.labelString)])
        XCTAssertEqual(mockNodeModel.label, .yellow)
    }
    
    func testAction_manageLabel_green() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity(label: .green)
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.labelString = Asset.Images.Labels.greenSmall.name
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .manageLabel,
             expectedCommands: [.hideLabel(false),
                                .setLabel(mockNodeActionUC.labelString)])
        XCTAssertEqual(mockNodeModel.label, .green)
    }
    
    func testAction_manageLabel_blue() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity(label: .blue)
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.labelString = Asset.Images.Labels.blueSmall.name
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .manageLabel,
             expectedCommands: [.hideLabel(false),
                                .setLabel(mockNodeActionUC.labelString)])
        XCTAssertEqual(mockNodeModel.label, .blue)
    }
    
    func testAction_manageLabel_purple() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity(label: .purple)
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.labelString = Asset.Images.Labels.purpleSmall.name
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .manageLabel,
             expectedCommands: [.hideLabel(false),
                                .setLabel(mockNodeActionUC.labelString)])
        XCTAssertEqual(mockNodeModel.label, .purple)
    }
    
    func testAction_manageLabel_grey() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity(label: .grey)
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.labelString = Asset.Images.Labels.greySmall.name
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .manageLabel,
             expectedCommands: [.hideLabel(false),
                                .setLabel(mockNodeActionUC.labelString)])
        XCTAssertEqual(mockNodeModel.label, .grey)
    }
    
    func testAction_manageThumbnail_isFolder() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity(isFolder: true)
        let mockNodeActionUC = MockNodeActionUseCase()
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .manageThumbnail,
             expectedCommands: [.hideVideoIndicator(true),
                                .setIcon("folder")])
    }
    
    func testAction_manageThumbnail_isFile_noThumbnail() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity(isFile: true)
        let mockNodeActionUC = MockNodeActionUseCase()
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .manageThumbnail,
             expectedCommands: [.hideVideoIndicator(true),
                                .setIcon("generic")])
    }
    
    func testAction_manageThumbnail_isFile_hasThumbnail() throws {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity(isFile: true, hasThumbnail: true)
        let mockNodeActionUC = MockNodeActionUseCase()
        let thumbnailPath = "file://thumbnail/abc"
        let mockNodeThumbnailUC = MockThumbnailUseCase(loadThumbnailResult: .success(try XCTUnwrap(URL(string: thumbnailPath))))
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        test(viewModel: viewModel,
             action: .manageThumbnail,
             expectedCommands: [.hideVideoIndicator(true),
                                .setThumbnail("/abc")])
    }
    
    func testAction_getFilesAndFolders_emptyFolder() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        let secondaryLabelText = Strings.Localizable.emptyFolder
        test(viewModel: viewModel,
             action: .getFilesAndFolders,
             expectedCommands: [.setSecondaryLabel(secondaryLabelText)])
    }
    
    func testAction_getFilesAndFolders_oneFile() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.filesAndFolders = (1 , 0)
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        let filesAndFoldersString = Strings.Localizable.oneFile(mockNodeActionUC.filesAndFolders.0)
        test(viewModel: viewModel,
             action: .getFilesAndFolders,
             expectedCommands: [.setSecondaryLabel(filesAndFoldersString)])
    }
    
    func testAction_getFilesAndFolders_fiveFiles() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.filesAndFolders = (5 , 0)
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        let filesAndFoldersString = Strings.Localizable.files(mockNodeActionUC.filesAndFolders.0)
        test(viewModel: viewModel,
             action: .getFilesAndFolders,
             expectedCommands: [.setSecondaryLabel(filesAndFoldersString)])
    }
    
    func testAction_getFilesAndFolders_oneFolder() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.filesAndFolders = (0 , 1)
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        let filesAndFoldersString = Strings.Localizable.oneFolder(mockNodeActionUC.filesAndFolders.1)
        test(viewModel: viewModel,
             action: .getFilesAndFolders,
             expectedCommands: [.setSecondaryLabel(filesAndFoldersString)])
    }
    
    func testAction_getFilesAndFolders_threeFolders() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.filesAndFolders = (0 , 3)
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        let filesAndFoldersString = Strings.Localizable.folders(mockNodeActionUC.filesAndFolders.1)
        test(viewModel: viewModel,
             action: .getFilesAndFolders,
             expectedCommands: [.setSecondaryLabel(filesAndFoldersString)])
    }
    
    func testAction_getFilesAndFolders_oneFileAndOneFolder() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.filesAndFolders = (1 , 1)
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        let filesAndFoldersString = Strings.Localizable.folderAndFile
        test(viewModel: viewModel,
             action: .getFilesAndFolders,
             expectedCommands: [.setSecondaryLabel(filesAndFoldersString)])
    }
    
    func testAction_getFilesAndFolders_oneFileAndTwoFolders() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.filesAndFolders = (1 , 2)
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        let filesAndFoldersString = Strings.Localizable.foldersAndFile(mockNodeActionUC.filesAndFolders.1)
        test(viewModel: viewModel,
             action: .getFilesAndFolders,
             expectedCommands: [.setSecondaryLabel(filesAndFoldersString)])
    }
    
    func testAction_getFilesAndFolders_twoFilesAndOneFolder() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.filesAndFolders = (2 , 1)
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        let filesAndFoldersString = Strings.Localizable.folderAndFiles(mockNodeActionUC.filesAndFolders.0)
        test(viewModel: viewModel,
             action: .getFilesAndFolders,
             expectedCommands: [.setSecondaryLabel(filesAndFoldersString)])
    }
    
    func testAction_getFilesAndFolders_threeFilesAndThreeFolders() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.filesAndFolders = (3 , 3)
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        var filesAndFoldersString = Strings.Localizable.foldersAndFiles
        filesAndFoldersString = filesAndFoldersString.replacingOccurrences(of: "[A]", with: String(mockNodeActionUC.filesAndFolders.0))
        filesAndFoldersString = filesAndFoldersString.replacingOccurrences(of: "[B]", with: String(mockNodeActionUC.filesAndFolders.1))
        test(viewModel: viewModel,
             action: .getFilesAndFolders,
             expectedCommands: [.setSecondaryLabel(filesAndFoldersString)])
    }
    
    func testAction_hasVersions_false() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .hasVersions,
             expectedCommands: [.setVersions(mockNodeActionUC.hasVersions())])
    }
    
    func testAction_hasVersions_true() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.versions = true
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .hasVersions,
             expectedCommands: [.setVersions(mockNodeActionUC.hasVersions())])
    }
    
    func testAction_isDownloaded_false() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .isDownloaded,
             expectedCommands: [.setDownloaded(mockNodeActionUC.isDownloaded())])
    }
    
    func testAction_isDownloaded_true() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity(isFile: true)
        let mockNodeActionUC = MockNodeActionUseCase()
        mockNodeActionUC.downloaded = true
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        test(viewModel: viewModel,
             action: .isDownloaded,
             expectedCommands: [.setDownloaded(mockNodeActionUC.isDownloaded())])
    }
    
    func testAction_moreTouchUpInside() {
        let nodeOpener = NodeOpener(navigationController: UINavigationController())
        let mockNodeModel = NodeEntity()
        let mockNodeActionUC = MockNodeActionUseCase()
        let mockNodeThumbnailUC = MockThumbnailUseCase()
        let mockAccountUC = MockAccountUseCase()
        
        let viewModel = NodeCellViewModel(nodeOpener: nodeOpener,
                                          nodeModel: mockNodeModel,
                                          nodeActionUseCase: mockNodeActionUC,
                                          nodeThumbnailUseCase: mockNodeThumbnailUC,
                                          accountUseCase: mockAccountUC)
        
        let sender = UIView()
        test(viewModel: viewModel,
             action: .moreTouchUpInside(sender),
             expectedCommands: [])
    }
}
