//
//  StrikeZoneViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class StrikeZoneViewController: UIViewController, UINavigationControllerDelegate {
  
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
  var currentHeatMap : HeatMap?
  var doneButton : UIBarButtonItem!
  var backButton : UIBarButtonItem!
  
  //this

  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationItem.title = selectedPitcher?.name
      self.navigationController?.delegate = self
      self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "backButtonPressed:")
      self.doneButton = UIBarButtonItem(title: "Detail", style: .Done, target: self, action: "detailButtonPressed:")
      self.navigationItem.leftBarButtonItem = backButton
      self.navigationItem.rightBarButtonItem = doneButton
      strikeZoneView.layer.borderWidth = 3
      strikeZoneView.layer.borderColor = UIColor.blackColor().CGColor
      let tap = UITapGestureRecognizer(target: self, action: ("handleTap:"))
      strikeZoneView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    self.selectedPitcher?.heatMaps.append(currentHeatMap!)
  }
  
  func detailButtonPressed(sender: UIButton) {
     let pitcherDetailVC = PitcherDetailViewController(nibName : "pitcherDetailView" , bundle : NSBundle.mainBundle())
    if currentHeatMap != nil {
      self.selectedPitcher?.heatMaps.append(currentHeatMap!)
    }
    pitcherDetailVC.currentPitcher = self.selectedPitcher
    self.navigationController?.pushViewController(pitcherDetailVC, animated: true)
  }
  
  func backButtonPressed(sender: UIButton) {
    let pitcherMenuVC = PitcherMenuViewController()
    if currentHeatMap != nil {
      self.selectedPitcher?.heatMaps.append(currentHeatMap!)
    }
    self.navigationController?.popToRootViewControllerAnimated(true)
  }
  
  
  
  
  func handleTap(gesture: UITapGestureRecognizer) {
    let tapLocation = gesture.locationInView(strikeZoneView)
   
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
            currentHeatMap?.allPitches!.append(currentPitch)
          
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
            
            UIView.animateWithDuration(0.7, delay: 0.0, options: nil, animations: { () -> Void in
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
