//
//  UiViewController + Extension.swift
//  ShiftSync
//
//  Created by Nidhi Khanpara on 2023-12-24.
//


import Foundation
import UIKit

extension UIViewController {
    
    //     To  Hide Keyboard When TappedAround
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //     Load Controller
    func loadViewController(Storyboard:StoryBoardIdentifiers,ViewController:ViewControllerIdentifiers) -> UIViewController {
        let storyBoard = UIStoryboard(name: Storyboard.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: ViewController.rawValue)
        return vc
    }

    
    func pushViewController( controllerID : ViewControllerIdentifiers,storyBoardID : StoryBoardIdentifiers , completion: (() -> Void)? = nil) {
        let storyBoard = UIStoryboard(name: storyBoardID.rawValue, bundle: nil)
        let viewController = storyBoard.instantiateViewController(identifier: controllerID.rawValue)
        CATransaction.begin()
        self.navigationController?.pushViewController(viewController, animated: true)
        CATransaction.setCompletionBlock(completion)
        CATransaction.commit()

    }
    
    //   navigate To Present Cotroller
    func presentViewController(controllerID : ViewControllerIdentifiers,storyBoardID : StoryBoardIdentifiers) {
        let storyBoard = UIStoryboard(name: storyBoardID.rawValue, bundle: nil)
        let viewController = storyBoard.instantiateViewController(identifier: controllerID.rawValue)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    //     navigate To Previous View Controller
    func popViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //    dismiss View Controller
    func dismissViewController(){
        self.dismiss(animated: true, completion: nil)
    }

}


extension UINavigationController {
    func getViewController<T: UIViewController>(of type: T.Type) -> UIViewController? {
        return self.viewControllers.first(where: { $0 is T })
    }

    func popToViewController<T: UIViewController>(of type: T.Type, animated: Bool) {
        guard let viewController = self.getViewController(of: type) else { return }
        self.popToViewController(viewController, animated: animated)
    }
}


