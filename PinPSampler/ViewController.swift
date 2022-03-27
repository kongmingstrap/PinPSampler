import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController, AVPlayerViewControllerDelegate {
    
    lazy var playerController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.willEnterForeground(note:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @IBAction func play(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "sample-5s", ofType: "mp4") else { return }
        let url = NSURL(fileURLWithPath: path)
        let player = AVPlayer(url: url as URL)
        
        playerController.player = player
        playerController.allowsPictureInPicturePlayback = true
        playerController.canStartPictureInPictureAutomaticallyFromInline = true
        playerController.delegate = self
        playerController.player?.play()
        
        self.present(playerController, animated: true, completion : {
            DispatchQueue.main.async {
                if let url = URL(string: "https://google.com") {
                    UIApplication.shared.open(url)
                }
            }
        })
    }
    
    @objc func willEnterForeground(note : NSNotification)  {
        DispatchQueue.main.async { [self] in
            self.playerController.player?.pause()
            self.playerController.player = nil
            self.playerController.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        let currentviewController = navigationController?.visibleViewController
        if currentviewController != playerViewController{
            currentviewController?.present(playerViewController, animated: true, completion: nil)
        }
    }
}
