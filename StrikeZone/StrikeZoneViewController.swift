//
//  StrikeZoneViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class StrikeZoneViewController: UIViewController{
  
  @IBOutlet var inZoneView: [UIView]!
  @IBOutlet var outZoneView: [UIView]!
  @IBOutlet weak var pitchArea: UIView!
  @IBOutlet weak var strikeZoneView: UIView!
  
  var pitchLocation = [CGPoint]()
  var pitches = [Pitch]()
  var isTargetLocation = true
  var currentPitch = Pitch()
  let locationView = UIView()
  var selectedPitcher : Pitcher?
  var targetView : UIView?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationItem.title = selectedPitcher?.name
      
//      locationView.frame = CGRect(x: -150, y: -150, width: 100, height: 100)
//      locationView.tag = 19
//      self.view.addSubview(locationView)
//      zoneOutlineView.layer.borderWidth = 5
//      zoneOutlineView.layer.borderColor = UIColor.blackColor().CGColor
      //zoneOutlineView.layer.zPosition = 0
      strikeZoneView.layer.borderWidth = 3
      strikeZoneView.layer.borderColor = UIColor.blackColor().CGColor
      let tap = UITapGestureRecognizer(target: self, action: ("handleTap:"))
      strikeZoneView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }

  func handleTap(gesture: UITapGestureRecognizer) {
    let tapLocation = gesture.locationInView(strikeZoneView)
    println("Ryan is a big fat shhhupid idiot")
   
    for subView in self.strikeZoneView.subviews {
      if let zoneView = subView as? UIView {
        if CGRectContainsPoint(zoneView.frame, tapLocation) {
         
          if isTargetLocation  {
            currentPitch.targetZoneLocation = zoneView.tag
            currentPitch.targetLocation = tapLocation
            self.targetView = zoneView
            isTargetLocation = false
            
          } else {
            currentPitch.actualZoneLocation = zoneView.tag
            currentPitch.actualLocation = tapLocation
            isTargetLocation = true
             pitches.append(currentPitch)
          
            var zoneColor : UIColor!
            if self.currentPitch.actualZoneLocation == self.currentPitch.targetZoneLocation {
              zoneColor = UIColor.redColor()
            } else {
              zoneColor = UIColor.blueColor()
            }
            
            currentPitch = Pitch()
            if self.targetView!.alpha == 1 {
              self.targetView!.alpha = 0.12
            }
            
            UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: { () -> Void in
            }, completion: { (finished) -> Void in
              self.targetView!.alpha = self.targetView!.alpha + 0.01
              self.targetView!.backgroundColor = zoneColor
              
            })
          }
        }
      }
    }
  }
}
