struct NodeActionRepository: NodeActionRepositoryProtocol {
    private let sdk: MEGASdk
    private let nodeHandle: MEGAHandle?
    
    init(sdk: MEGASdk, nodeHandle: MEGAHandle?) {
        self.sdk = sdk
        self.nodeHandle = nodeHandle
    }
    
    func nodeAccessLevel() -> NodeAccessTypeEntity {
        guard let nodeHandle = nodeHandle, let node = sdk.node(forHandle: nodeHandle) else {
            return .unknown
        }
        return NodeAccessTypeEntity(shareAccess: sdk.accessLevel(for: node)) ?? .unknown
    }
    
    func downloadToOffline() {
        guard let nodeHandle = nodeHandle, let node = sdk.node(forHandle: nodeHandle) else {
            return
        }
        node.mnz_downloadNode()
    }
    
    func labelString(label: NodeLabelTypeEntity) -> String {
        let nodeLabel = MEGANodeLabel(nodeLabelTypeEntity: label) ?? .unknown
        return MEGANode.string(for: nodeLabel) ?? "" + "Small"
    }
    
    func getFilesAndFolders() -> (childFileCount: Int, childFolderCount: Int) {
        guard let nodeHandle = nodeHandle, let node = sdk.node(forHandle: nodeHandle) else {
            return (0, 0)
        }
        
        let numberOfFiles = sdk.numberChildFiles(forParent: node)
        let numberOfFolders = sdk.numberChildFolders(forParent: node)
        
        return (numberOfFiles, numberOfFolders)
    }
    
    func hasVersions() -> Bool {
        guard let nodeHandle = nodeHandle, let node = sdk.node(forHandle: nodeHandle) else {
            return false
        }
        
        return sdk.hasVersions(for: node)
    }
    
    func isBeingDownloaded() -> Bool {
        guard let nodeHandle = nodeHandle else {
            return false
        }
        
        if (Helper.downloadingNodes().object(forKey: nodeHandle) != nil) {
            return true
        } else {
            return false
        }
    }
    
    func isDownloaded() -> Bool {
        guard let nodeHandle = nodeHandle, let node = sdk.node(forHandle: nodeHandle) else {
            return false
        }
        
        return (MEGAStore.shareInstance().offlineNode(with: node) != nil)
    }
}
