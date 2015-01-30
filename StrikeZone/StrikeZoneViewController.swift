//
//  StrikeZoneViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

protocol heatMapDelegate{
  func setPitcher(pitcher : Pitcher?) -> (Void)
}

class StrikeZoneViewController: UIViewController, UINavigationControllerDelegate, PitcherDetailDelegate {
  
  var delegate : heatMapDelegate?
  
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
  
  var targetView : StrikeRegion?
  var currentHeatMap : HeatMap?
  var doneButton : UIBarButtonItem!
  var backButton : UIBarButtonItem!
  
  var zoneColor = UIColor()
  var alphaNumber = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationItem.title = selectedPitcher?.name
      self.navigationController?.delegate = self
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "backButtonPressed:")
      self.doneButton = UIBarButtonItem(title: "Detail", style: .Done, target: self, action: "detailButtonPressed:")
      //self.navigationItem.leftBarButtonItem = backButton
      self.navigationItem.rightBarButtonItem = doneButton
      strikeZoneView.layer.borderWidth = 3
      strikeZoneView.layer.borderColor = UIColor.blackColor().CGColor
      let tap = UITapGestureRecognizer(target: self, action: ("handleTap:"))
      strikeZoneView.addGestureRecognizer(tap)
      let pitchTypeFastBall = UIAlertAction(title: "FastBall", style: .Default, handler: { (action) -> Void in
        self.currentPitch.pitchType = "Fast Ball"
        self.modifyTemperatureForNewPitch()
        self.finishPitch()
      })
      let pitchTypeOffSpeed = UIAlertAction(title: "OffSpeed", style: .Default, handler: { (action) -> Void in
        self.currentPitch.pitchType = "OffSpeed"
        self.modifyTemperatureForNewPitch()
        self.finishPitch()

      })
      let pitchTypeBreaking = UIAlertAction(title: "Breaking Ball", style: .Default, handler: { (action) -> Void in
        self.currentPitch.pitchType = "Breaking Ball"
        self.modifyTemperatureForNewPitch()
        self.finishPitch()

      })
      let pitchCancel = UIAlertAction(title: "Cancel Pitch", style: UIAlertActionStyle.Destructive) { (action) -> Void in
        println()
      }
      self.alert.addAction(pitchTypeFastBall)
      self.alert.addAction(pitchTypeOffSpeed)
      self.alert.addAction(pitchTypeBreaking)
      self.alert.addAction(pitchCancel)
      
      for view in strikeZoneView.subviews{
        let subView = view as? UIView
        subView!.alpha = 0
      }
      self.navigationItem.title = self.selectedPitcher?.name
      
      // Do any additional setup after loading the view.
      
      if currentHeatMap != nil{
        for pitch in currentHeatMap!.allPitches{
          for view in strikeZoneView.subviews{
            let subView = view as? StrikeRegion
            if pitch.targetZoneLocation == subView!.tag{
              self.currentPitch = pitch
              self.targetView = subView
              self.modifyTemperatureForNewPitch()
            }
          }
        }
        currentPitch = Pitch()
      }else{
        currentHeatMap = HeatMap()
        self.selectedPitcher?.heatMaps.insert(currentHeatMap!, atIndex: 0)
      }

    }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

  }
  
  func detailButtonPressed(sender: UIButton) {
    let pitcherDetailVC = PitcherDetailViewController(nibName : "pitcherDetailView" , bundle : NSBundle.mainBundle())
    //self.selectedPitcher?.heatMaps.insert(currentHeatMap!, atIndex: 0)

    pitcherDetailVC.currentPitcher = self.selectedPitcher
    pitcherDetailVC.currentHeatMap = self.currentHeatMap
    
    pitcherDetailVC.delegate = self
        
    self.navigationController?.pushViewController(pitcherDetailVC, animated: true)
  }
  
  func backButtonPressed(sender: UIButton) {
    //self.selectedPitcher?.heatMaps.insert(currentHeatMap!, atIndex: 0)
    println("this should fire")
    delegate?.setPitcher(selectedPitcher)
    
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func handleTapForTarget(targetToouchLocation: CGPoint) {
    if currentHeatMap == nil {
      currentHeatMap = HeatMap()
    }
    for subView in self.strikeZoneView.subviews {
      if let zoneView = subView as? StrikeRegion {
        if CGRectContainsPoint(zoneView.frame, targetToouchLocation) {
          currentPitch.targetZoneLocation = zoneView.tag
          currentPitch.targetLocation = targetToouchLocation
          self.targetView = zoneView
          isTargetLocation = false
          return
        }
      }
    }
  }
  func handleTapForPitch(actualTouchLocation: CGPoint) {
    for subView in self.strikeZoneView.subviews {
      if let zoneView = subView as? StrikeRegion {
        if CGRectContainsPoint(zoneView.frame, actualTouchLocation) {
          currentPitch.actualZoneLocation = zoneView.tag
          currentPitch.actualLocation = actualTouchLocation
          isTargetLocation = true
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
        self.targetView!.alpha = self.targetView!.alpha + 0.05
        self.targetView!.backgroundColor = self.zoneColor
        self.targetView!.temperature++
        self.currentPitch.wasGoodPitch = true

        
      }
      else //Handle a bad pitch
      {
        self.zoneColor = UIColor.blueColor()
        self.targetView!.alpha = self.targetView!.alpha + 0.05
        self.targetView!.backgroundColor = self.zoneColor
        self.targetView!.temperature--
        self.currentPitch.wasGoodPitch = false

      }
    }
    else if self.targetView!.temperature > 0
    {
      if self.currentPitch.actualZoneLocation == self.currentPitch.targetZoneLocation{
        self.targetView!.alpha = self.targetView!.alpha + 0.05
        self.targetView!.temperature++
        self.currentPitch.wasGoodPitch = true

      }
      else{
        self.targetView!.alpha = self.targetView!.alpha - 0.05
        self.targetView!.temperature--
        self.currentPitch.wasGoodPitch = false

      }
    }
    else {
      if self.currentPitch.actualZoneLocation == self.currentPitch.targetZoneLocation{
        self.targetView!.alpha = self.targetView!.alpha - 0.05
        self.targetView!.temperature++
        self.currentPitch.wasGoodPitch = true

      } else{
        self.targetView!.alpha = self.targetView!.alpha + 0.05
        self.targetView!.temperature--
        self.currentPitch.wasGoodPitch = false

      }
    }
  
  }
  
  func handleTap(gesture: UITapGestureRecognizer) {
    let tapLocation = gesture.locationInView(strikeZoneView)
   
    if isTargetLocation  {
      self.handleTapForTarget(tapLocation)
          } else  {
          handleTapForPitch(tapLocation)
    }
  }
  
  func finishPitch(){
    currentHeatMap?.allPitches.append(currentPitch)
    UIGraphicsBeginImageContext(view.bounds.size);
    self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
    let viewImage = UIGraphicsGetImageFromCurrentImageContext()
    currentHeatMap?.heatMapImage = viewImage
    UIGraphicsEndImageContext()
    currentPitch = Pitch()
  }
  
  
  func setPitcher(pitcher : Pitcher?){
    //self.selectedPitcher = pitcher
  }
  func setHeatMap(heatmap: HeatMap?){
    self.currentHeatMap = heatmap
    
    for view in strikeZoneView.subviews{
      let subView = view as? UIView
      subView!.alpha = 0
      
    }
  }
}
      
