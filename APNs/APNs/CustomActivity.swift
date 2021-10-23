//
//  CustomActivity.swift
//  APNs
//
//  Created by Thisisme Hi on 2021/10/23.
//

import UIKit

protocol CustomActivityDelegate: NSObjectProtocol {
    func performActionCompletion(activity: CustomActivity)
}

class CustomActivity: UIActivity {
    
    weak var delegate: CustomActivityDelegate?
    
    override var activityType: UIActivity.ActivityType? { return .none }
    override class var activityCategory: UIActivity.Category { return .action }
    override var activityTitle: String? { return "Open in Safari" }
    override var activityImage: UIImage? { return UIImage(systemName: "home.fill") }
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    override func prepare(withActivityItems activityItems: [Any]) {
        
    }
    
    // 추가 UI 사용하지 않고 서비스 수행
    override func perform() {
        self.delegate?.performActionCompletion(activity: self)
        activityDidFinish(true) // activity가 잘 되면 꼭 호출되는 것
    }
}
