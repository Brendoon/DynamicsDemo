//
//  ViewController.swift
//  DynamicsDemo
//
//  Created by Brendoon Ryos on 16/05/17.
//  Copyright © 2017 Brendoon Ryos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var firstContact: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        square.backgroundColor = UIColor.gray
        self.view.addSubview(square)
        
        let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        barrier.backgroundColor = UIColor.red
        self.view.addSubview(barrier)
        
        let rightEdge = CGPoint(x: barrier.frame.origin.x + barrier.frame.size.width, y: barrier.frame.origin.y)
        
        
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: [square])
        
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: [square])
        collision.collisionDelegate = self
        collision.addBoundary(withIdentifier: "barrier" as NSCopying, from: barrier.frame.origin, to: rightEdge)
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        collision.action = {
            NSLog("%@, %@", NSStringFromCGAffineTransform(square.transform), NSStringFromCGPoint(square.center))
        }
        
        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.6
        animator.addBehavior(itemBehaviour)
        
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print("Boundary contact occured - \(String(describing: identifier))")
        let view = item as! UIView
        view.backgroundColor = UIColor.yellow
        UIView.animate(withDuration: 0.3, animations: { view.backgroundColor = UIColor.gray })
        
        if(!firstContact){
            
            firstContact = true
            let square = UIView(frame: CGRect(x: 30, y: 0, width: 100, height: 100))
            square.backgroundColor = UIColor.gray
            self.view.addSubview(square)
            collision.addItem(square)
            gravity.addItem(square)
            
            let attach = UIAttachmentBehavior(item: view, attachedTo: square)
            animator.addBehavior(attach)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

