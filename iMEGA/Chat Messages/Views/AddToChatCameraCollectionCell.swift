
import UIKit

class AddToChatCameraCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var liveFeedView: UIView!
    @IBOutlet weak var cameraIconImageView: UIImageView!

    var previewLayer: AVCaptureVideoPreviewLayer!
    var isCurrentShowingLiveFeed = false
    
    enum LiveFeedError: Error {
        case askForPermission
        case captureDeviceInstantiationFailed
        case captureDeviceInputInstantiationFailed
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateAppearance()
    }
    
    func showLiveFeed() throws {
        if DevicePermissionsHelper.shouldAskForVideoPermissions() {
            updateCameraIconImageView()
            throw LiveFeedError.askForPermission
        }
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        liveFeedView.isHidden = false
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        liveFeedView.layer.addSublayer(previewLayer)
       
        let deviceDiscoverySession = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                             for: AVMediaType.video,
                                                             position: .back)
        
        guard let captureDevice = deviceDiscoverySession else {
            throw LiveFeedError.captureDeviceInstantiationFailed
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            throw LiveFeedError.captureDeviceInputInstantiationFailed
        }
        
        captureSession.startRunning()
        liveFeedView.isHidden = false
        isCurrentShowingLiveFeed = true
        updateCameraIconImageView()
    }
    
    func hideLiveFeedView() {
        liveFeedView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addCornerRadius()
        guard let previewLayer = previewLayer else {
            return
        }
        
        previewLayer.frame = liveFeedView.layer.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *),
            traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateAppearance()
        }
    }
    
    private func addCornerRadius() {
        layer.cornerRadius = 4.0
        
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft],
                                    cornerRadii: CGSize(width: 8.0, height: 0.0))

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    private func updateCameraIconImageView() {
        if #available(iOS 12.0, *) {
            cameraIconImageView.image = (traitCollection.userInterfaceStyle == .dark) ? #imageLiteral(resourceName: "cameraIconWhite") : (DevicePermissionsHelper.isVideoPermissionAuthorized() ? #imageLiteral(resourceName: "cameraIconWhite") : #imageLiteral(resourceName: "cameraIcon"))
        } else {
            cameraIconImageView.image = DevicePermissionsHelper.isVideoPermissionAuthorized() ? #imageLiteral(resourceName: "cameraIconWhite") : #imageLiteral(resourceName: "cameraIcon")
        }
    }
    
    private func updateAppearance() {
        backgroundColor = .mnz_inputbarButtonBackground(traitCollection)
        liveFeedView.backgroundColor = .mnz_inputbarButtonBackground(traitCollection)
        updateCameraIconImageView()
    }
}
