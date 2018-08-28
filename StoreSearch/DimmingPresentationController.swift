//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Aurélien Schneberger on 27/08/2018.
//  Copyright © 2018 Aurélien Schneberger. All rights reserved.
//

import UIKit
class DimmingPresentationController: UIPresentationController {
    
    lazy var dimingView = GradientView(frame: CGRect.zero)
    
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        dimingView.frame = containerView!.bounds
        containerView!.insertSubview(dimingView, at: 0)
        
        // Animate background gradient view
        dimingView.alpha = 0
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimingView.alpha = 1
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin()  {
        if let coordinator =
            presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimingView.alpha = 0
            }, completion: nil)
        }
    }
}
