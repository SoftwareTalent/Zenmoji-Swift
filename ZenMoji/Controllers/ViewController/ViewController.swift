//
//  ViewController.swift
//  ZenEmoji
//
//  Created by CSPC143 on 15/05/17.
//  Copyright © 2017 CSPC143. All rights reserved.
//

import UIKit
import MessageUI
import Foundation


class ViewController: AbstractControl,MFMailComposeViewControllerDelegate,UIPopoverPresentationControllerDelegate {

    var catImageArray = NSArray()
     var CategoryArray = NSArray()
     var priceArray = NSArray()
    

    @IBOutlet weak var homeTableView: UITableView!
    

    @IBOutlet weak var sendEmojiBtnClicked: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //popupView.isHidden = true
        let tap = UITapGestureRecognizer(target:self,  action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        
    }
    func handleTap()
    {
      
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func ShareBtnClick(_ sender: Any) {
        shareData()
    }
    
    @IBAction func sendEmojiBtnClicked(_ sender: UIButton) {
    
        shareData()
    }
    
    @IBAction func tutorialBtnClicked(_ sender: Any) {
        let control = storyboard?.instantiateViewController(withIdentifier: "TutorialViewController")
        navigationController?.pushViewController(control!, animated: false)
    }
    
    @IBAction func moreInfoBtnClicked(_ sender: UIButton) {
        sendEmailBtnTapped()
    }
   
    @IBAction func rateUSBtnClicked(_ sender: UIButton) {
        
        rateApp(appId:"https://itunes.apple.com/us/app/zenmoji-unique-fun-zen-emojis/id1220710449?ls=1&mt=8", completion: { (Bool) in
            
                  })
    }
    
   
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "https://itunes.apple.com/us/app/zenmoji-unique-fun-zen-emojis-and-stickers/id1220710449?ls=1&mt=8") else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
   
    func btnrate()  {
        rateApp(appId: "asdad") { (Bool) in
            
        }
    }

 func shareData() {
        let someText :String = "ZenMojis"
        let objectToshare : URL = URL(string: "https://itunes.apple.com/us/app/zenmoji-unique-fun-zen-emojis-and-stickers/id1220710449?ls=1&mt=8")!
        let sharedObjects :  [AnyObject] = [objectToshare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems: sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivityType.airDrop,UIActivityType.postToTwitter,UIActivityType.postToFacebook,UIActivityType.mail]
        self.present(activityViewController, animated: true, completion: nil)
 }
    
// send supporting email 

    func sendEmailBtnTapped()
    {
        guard let url = URL(string: "https://www.facebook.com/RealityBytesCreative") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
//        let mailComposeViewController = configuredMailComposeViewController()
//        if MFMailComposeViewController.canSendMail()
//        {
//            self.present(mailComposeViewController, animated: true, completion: nil)
//        }
//        else
//        {
//            self.showSendMailErrorAlert()
//        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["dyanne.eckdahl@gmail.com"])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self,       cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }


}

