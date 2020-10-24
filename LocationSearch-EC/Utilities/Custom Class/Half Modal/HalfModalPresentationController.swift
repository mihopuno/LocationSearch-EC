//
//  HalfModalPresentationController.swift
//  LocationSearch-EC
//
//  Created by Mac Mini 2 on 10/24/20.
//

import UIKit

class HalfModalPresentationController : UIPresentationController {
    var isMaximized: Bool = false
    
    private var _dimmingView: UIView?
    var dimmingView: UIView {
        if let dimmedView = _dimmingView {
            return dimmedView
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height))
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        view.addSubview(backgroundView)
        
        _dimmingView = view
        
        return view
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: containerView!.bounds.height / 2, width: containerView!.bounds.width, height: containerView!.bounds.height / 2)
    }
    
    override func presentationTransitionWillBegin() {
        let dimmedView = dimmingView
        
        if let containerView = self.containerView {
            
            dimmedView.alpha = 0
            containerView.addSubview(dimmedView)
            dimmedView.addSubview(presentedViewController.view)
            dimmedView.alpha = 1
        }
        
        dimmingView.addTapGesture(target: self, action: #selector(dismiss(_:)))
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { (context) -> Void in
                self.dimmingView.alpha = 0
                self.presentingViewController.view.transform = CGAffineTransform.identity
            }, completion: { (completed) -> Void in
                print("done dismiss animation")
            })
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        print("dismissal did end: \(completed)")
        
        if completed {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
            dimmingView.removeGestureRecognizer(gestureRecognizer)
            dimmingView.removeFromSuperview()
            _dimmingView = nil
            isMaximized = false
        }
    }
}

extension HalfModalPresentationController {
    @objc private func dismiss(_ sender: Any) {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
