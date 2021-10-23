//
//  ViewController.swift
//  APNs
//
//  Created by Thisisme Hi on 2021/10/22.
//

import UIKit

class ViewController: UIViewController, CustomActivityDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func button(_ sender: Any) {
        let customActivity = CustomActivity()
        customActivity.delegate = self
        shareContents(shareObject: [textField.text!], custom: [customActivity])
    }
    
    func shareContents(shareObject: [Any], custom: [UIActivity]?) {
        let activityViewController = UIActivityViewController(activityItems: shareObject, applicationActivities: custom)
        
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            if success { // 성공했을 때 작업
                print("공유 성공")
            }  else  { // 실패했을 때 작업
                print("공유 실패")
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func performActionCompletion(activity: CustomActivity) {
        guard let url = URL(string: textField.text!),
              UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
