//
//  Extensions.swift
//  ShiftSync
//
//  Created by Nidhi Khanpara on 2023-12-24.
//

import Foundation
import UIKit

extension UITextField {
    func addUnderline(color: UIColor) {
        let underline = CALayer()
        underline.backgroundColor = color.cgColor
        underline.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        layer.addSublayer(underline)
    }
}


extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = maskPath.cgPath

        layer.mask = shapeLayer
    }
    
    func addShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }


}




extension UIViewController {
 
    
    func showTost(message: String, onCompletion: (() -> Void)? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            
            let controller = UIAlertController(title: message, message: "", preferredStyle: .actionSheet)
            controller.view.tintColor = UIWindow.appearance().tintColor
            controller.popoverPresentationController?.sourceView = self?.view
            self?.present(controller, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                controller.dismiss(animated: true) {
                    
                    onCompletion?()
                }
            }
            
        }
    }
    
    
}
