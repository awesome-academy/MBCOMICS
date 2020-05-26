//
//  UIImageViewExtension.swift
//
//  Created by HoaPQ on 9/11/19.
//

import UIKit
import Kingfisher

extension UIImageView {
    @IBInspectable var imageTintColor: UIColor! {
        get {
            return self.tintColor
        }
        set {
            self.image = self.image?.withRenderingMode(.alwaysTemplate)
            self.tintColor = newValue
        }
    }

//    func setImage(urlString: String,
//                  placeholder: Placeholder? = nil,
//                  options: KingfisherOptionsInfo? = nil,
//                  progressBlock: DownloadProgressBlock? = nil,
//                  completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
//        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
//            let url = URL(string: urlString)
//            self.kf.setImage(with: url,
//                             placeholder: placeholder,
//                             options: options,
//                             progressBlock: progressBlock,
//                             completionHandler: completionHandler)
//        }
//    }
    
//    func setImage(urlString: String,
//                  placeholder: Placeholder? = nil,
//                  header: [String: Any]? = nil,
//                  progressBlock: DownloadProgressBlock? = nil,
//                  completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
//        var options: KingfisherOptionsInfo? = nil
//        if let header = header {
//            let modifier = AnyModifier { request in
//                var r = request
//                // replace "Access-Token" with the field name you need, it's just an example
//                for itemHeader in header {
//                    let value = String(describing: itemHeader.value)
//                    r.setValue(value, forHTTPHeaderField: itemHeader.key)
//                }
//                return r
//            }
//            options = [.requestModifier(modifier)]
//        }
//        
//        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
//            let url = URL(string: urlString)
//            self.kf.setImage(with: url,
//                             placeholder: placeholder,
//                             options: options,
//                             progressBlock: progressBlock,
//                             completionHandler: completionHandler)
//        }
//    }
//    
    
}
