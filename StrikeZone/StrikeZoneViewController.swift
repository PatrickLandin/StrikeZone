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
  
  let alert = UIAlertController(title: "Pitch Type", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
  var pitchLocation = [CGPoint]()
  var pitches = [Pitch]()
  var isTargetLocation = true
  var currentPitch = Pitch()
  let locationView = UIView()
  var selectedPitcher : Pitcher?
  
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
      let pitchTypeFastBall = UIAlertAction(title: "FastBall", style: .Default, handler: { (action) -> Void in
        self.currentPitch.pitchType = "Fast Ball"
        self.currentPitch.wasGoodPitch = true
        self.modifyTemperatureForNewPitch()
      })
      let pitchTypeOffSpeed = UIAlertAction(title: "OffSpeed", style: .Default, handler: { (action) -> Void in
        self.currentPitch.pitchType = "OffSpeed"
        self.currentPitch.wasGoodPitch = true
        self.modifyTemperatureForNewPitch()
      })
      let pitchTypeBreaking = UIAlertAction(title: "Breaking Ball", style: .Default, handler: { (action) -> Void in
        self.currentPitch.pitchType = "Breaking Ball"
        self.currentPitch.wasGoodPitch = true
        self.modifyTemperatureForNewPitch()
      })
      let pitchCancel = UIAlertAction(title: "Cancel Pitch", style: UIAlertActionStyle.Destructive) { (action) -> Void in
        println()
       self.currentPitch.wasGoodPitch = false
      }
      self.alert.addAction(pitchTypeFastBall)
      self.alert.addAction(pitchTypeOffSpeed)
      self.alert.addAction(pitchTypeBreaking)
      self.alert.addAction(pitchCancel)

        // Do any additional setup after loading the view.
      
      for view in strikeZoneView.subviews{
        let subView = view as? UIView
        subView!.alpha = 0
        
      }

      self.navigationItem.title = self.selectedPitcher?.name

    }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if currentHeatMap == nil {
      currentHeatMap = HeatMap()
    }
    
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
    self.presentViewController(self.alert, animated: true, completion: nil)
  }
  
  func modifyTemperatureForNewPitch() {
    if self.targetView!.temperature == 0{
      if self.currentPitch.actualZoneLocation == self.currentPitch.targetZoneLocation {
        //heres how we handle a good pitch
        self.zoneColor = UIColor.redColor()
        self.targetView!.alpha = self.targetView!.alpha + 0.1
        self.targetView!.backgroundColor = self.zoneColor
        self.targetView!.temperature++
      }
      else //Handle a bad pitch
      {
        self.zoneColor = UIColor.blueColor()
        self.targetView!.alpha = self.targetView!.alpha + 0.1
        self.targetView!.backgroundColor = self.zoneColor
        self.targetView!.temperature--
      }
    }
    else if self.targetView!.temperature > 0
    {
      if self.currentPitch.actualZoneLocation == self.currentPitch.targetZoneLocation{
        self.targetView!.alpha = self.targetView!.alpha + 0.1
        self.targetView!.temperature++
      }
      else{
        self.targetView!.alpha = self.targetView!.alpha - 0.1
        self.targetView!.temperature--
      }
    }
    else
    {
      if self.currentPitch.actualZoneLocation == self.currentPitch.targetZoneLocation{
        self.targetView!.alpha = self.targetView!.alpha - 0.1
        self.targetView!.temperature++
      }
      else{
        self.targetView!.alpha = self.targetView!.alpha + 0.1
        self.targetView!.temperature--
      }
    }
    if currentPitch.wasGoodPitch == true {
      currentHeatMap?.allPitches.append(currentPitch)
    }
    UIGraphicsBeginImageContext(view.bounds.size);
    self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
    let viewImage = UIGraphicsGetImageFromCurrentImageContext()
    currentHeatMap?.heatMapImage = viewImage
    UIGraphicsEndImageContext()
    currentPitch = Pitch()
  }
  
  func handleTap(gesture: UITapGestureRecognizer) {
    let tapLocation = gesture.locationInView(strikeZoneView)
   
    if isTargetLocation  {
      self.handleTapForTarget(tapLocation)
          } else  {
          handleTapForPitch(tapLocation)
    }
    
    
    
    

          }
        }
      
