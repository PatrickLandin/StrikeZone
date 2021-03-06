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

class StrikeZoneViewController: UIViewController, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
  
  var delegate : heatMapDelegate?
    
  @IBOutlet var inZoneView: [UIView]!
  @IBOutlet var outZoneView: [UIView]!
  @IBOutlet weak var pitchArea: UIView!
  @IBOutlet weak var strikeZoneView: UIView!
  
  @IBOutlet var infoButton: UIButton!
  
  let alert = UIAlertController(title: "Pitch Type", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
  var pitchLocation = [CGPoint]()
  var pitches = [Pitch]()
  var isTargetLocation = true
  var currentPitch : Pitch!
  let locationView = UIView()
  var selectedPitcher : Pitcher?
  var infoVC : UIViewController?
  var blurView : UIView!
  
  var targetView : StrikeRegion?
  var actualPitchView : StrikeRegion?

  var currentHeatMap : HeatMap?
  var doneButton : UIBarButtonItem!
  var backButton : UIBarButtonItem!
  
  var score : CGFloat?
  
  var zoneColor = UIColor()
  var alphaNumber = 0
  
  var blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
  
    override func viewDidLoad() {
        super.viewDidLoad()
      var blurViews = NSBundle.mainBundle().loadNibNamed("blurInfo", owner: self, options: nil)
      self.blurView = blurViews.first as UIView
      self.blurView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
      self.blurView.backgroundColor = UIColor.clearColor()
      self.navigationController?.view.addSubview(blurView)
      self.blurEffect.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
      self.blurView.insertSubview(blurEffect, atIndex: 0)
      self.view.frame.height
      self.navigationItem.title = selectedPitcher?.name
      self.navigationController?.delegate = self
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "backButtonPressed:")
      self.doneButton = UIBarButtonItem(title: "Detail", style: .Done, target: self, action: "detailButtonPressed:")
      self.doneButton.enabled = false
      self.navigationItem.rightBarButtonItem = doneButton
      strikeZoneView.layer.borderWidth = 3
      strikeZoneView.layer.borderColor = UIColor.blackColor().CGColor
      let tap = UITapGestureRecognizer(target: self, action: ("handleTap:"))
      strikeZoneView.addGestureRecognizer(tap)

      let pitchTypeFastBall = UIAlertAction(title: "FastBall", style: .Default, handler: { (action) -> Void in
        self.currentPitch.pitchType = "Fast Ball"
        self.modifyTemperatureForNewPitch()
        self.distanceBetweenTaps()
        self.finishPitch()
      })
      let pitchTypeOffSpeed = UIAlertAction(title: "Off Speed", style: .Default, handler: { (action) -> Void in
        self.currentPitch.pitchType = "OffSpeed"
        self.modifyTemperatureForNewPitch()
        self.distanceBetweenTaps()
        self.finishPitch()

      })
      let pitchTypeBreaking = UIAlertAction(title: "Breaking Ball", style: .Default, handler: { (action) -> Void in
        self.currentPitch.pitchType = "Breaking Ball"
        self.modifyTemperatureForNewPitch()
        self.distanceBetweenTaps()
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
        self.doneButton.enabled = true
        for item in currentHeatMap!.pitches.allObjects {
          if let pitch = item as? Pitch {
          for view in strikeZoneView.subviews{
            let subView = view as? StrikeRegion
            if pitch.targetZoneLocation == subView!.tag{
              self.currentPitch = pitch
              self.targetView = subView
              self.modifyTemperatureForNewPitch()
            }
            }
          }
        }
      }else{
      }
    }
  
  @IBAction func infoButtonPressed(sender: AnyObject) {
   UIView.animateWithDuration(0.4, animations: { () -> Void in
    self.blurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
   })
  }
  
  @IBAction func doneButtonPressed(sender: AnyObject) {
    println("pressed")
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.blurView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
    })
    
  }
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    currentPitch = PitchService.sharedPitchService.newPitch()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.currentPitch.managedObjectContext?.deleteObject(self.currentPitch)
    
  }
  
  func detailButtonPressed(sender: UIButton) {
    let pitcherDetailVC = PitcherDetailViewController(nibName : "pitcherDetailView" , bundle : NSBundle.mainBundle())
    //self.selectedPitcher?.heatMaps.insert(currentHeatMap!, atIndex: 0)

    pitcherDetailVC.currentPitcher = self.selectedPitcher
    pitcherDetailVC.currentHeatMap = self.currentHeatMap
    
    pitcherDetailVC.newHeatMapHandler = { () in
      self.currentHeatMap = nil
      for view in self.strikeZoneView.subviews{
        if let subView = view as? StrikeRegion{
          subView.alpha = 0
          subView.temperature = 0
        }
      }
    }
    
    self.navigationController?.pushViewController(pitcherDetailVC, animated: true)
  }
  
  func backButtonPressed(sender: UIButton) {
    //self.selectedPitcher?.heatMaps.insert(currentHeatMap!, atIndex: 0)
    //println("this should fire")
    delegate?.setPitcher(selectedPitcher)
    
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func handleTapForTarget(targetTouchLocation: CGPoint) {
    //currentPitch = PitchService.sharedPitchService.newPitch()
    if currentHeatMap == nil {
//      currentHeatMap = HeatMap()
      currentHeatMap = PitchService.sharedPitchService.newHeatMap(selectedPitcher!)

    }
    for subView in self.strikeZoneView.subviews {
      if let zoneView = subView as? StrikeRegion {
        if CGRectContainsPoint(zoneView.frame, targetTouchLocation) {
          currentPitch.targetZoneLocation = NSNumber(integer: zoneView.tag)
          currentPitch.targetX = targetTouchLocation.x
          currentPitch.targetY = targetTouchLocation.y
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
          currentPitch.actualX = actualTouchLocation.x
          currentPitch.actualY = actualTouchLocation.y
          isTargetLocation = true
          self.actualPitchView = zoneView
        }
      }
    }
    if (self.alert.popoverPresentationController != nil) {
        self.alert.popoverPresentationController?.sourceRect = self.actualPitchView!.bounds
        self.alert.popoverPresentationController?.sourceView = self.actualPitchView 
    }
    self.presentViewController(self.alert, animated: true, completion: nil)
  }
  
  func distanceBetweenTaps(){
    
    var targetDistanceX = CGFloat(currentPitch.targetX) / strikeZoneView.frame.width
    var targetDistanceY = CGFloat(currentPitch.targetY) / strikeZoneView.frame.height
    var actualDistanceX = CGFloat(currentPitch.actualX) / strikeZoneView.frame.width
    var actualDistanceY = CGFloat(currentPitch.actualY) / strikeZoneView.frame.height
    var deltaX = abs(targetDistanceX - actualDistanceX)
    var deltaY = abs(targetDistanceY - actualDistanceY)
    var distance = sqrt((deltaX * deltaX) + (deltaY * deltaY))
    self.score = (abs(1 - distance) * 100)
    
    currentPitch.pitchScore = self.score!
    
    let formatString = NSString(format: "%.01f", Float(self.score!))
    
    println("score: \((formatString))")
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
      }
      else{
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
      self.indicateTargetPitch()
      } else  {
      self.handleTapForPitch(tapLocation)
      self.indicateActualPitch()

    }
  }
  
  func finishPitch(){
    
    self.infoButton.hidden = true
    self.doneButton.enabled = true
    
    UIGraphicsBeginImageContext(view.bounds.size);
    self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
    let viewImage = UIGraphicsGetImageFromCurrentImageContext()
    
//  currentHeatMap?.heatMapImage = viewImage
    UIGraphicsEndImageContext()
    
    self.infoButton.hidden = false

    currentPitch.heatMap = currentHeatMap!
    
    currentHeatMap?.date = NSDate()
    currentPitch.date = NSDate()
    
    //println(currentPitch.date)

    
    //let error : NSError?
    PitchService.sharedPitchService.coreDataStack.saveContext()
    PitchService.sharedPitchService.covertAndSaveImageForPitcherHeatMaps(currentHeatMap!, image: viewImage)
    currentPitch = PitchService.sharedPitchService.newPitch()
  }
  
  func indicateTargetPitch(){
    let initialViewColor = self.targetView!.backgroundColor
    let initialViewAlpha = self.targetView!.alpha
    
      self.targetView!.backgroundColor = UIColor.greenColor()
      UIView.animateWithDuration(0.2, animations: { () -> Void in
        self.targetView!.alpha = 0.25
      }, completion: { (finished) -> Void in
        UIView.animateWithDuration(0.2, animations: { () -> Void in
          self.targetView!.alpha = initialViewAlpha
          self.targetView!.backgroundColor = initialViewColor
          }, completion: { (finished) -> Void in
        })
      })
  }
  
  func indicateActualPitch(){
    let initialViewColor = self.actualPitchView!.backgroundColor
    let initialViewAlpha = self.actualPitchView!.alpha
    
    self.actualPitchView!.backgroundColor = UIColor.greenColor()
    UIView.animateWithDuration(0.2, animations: { () -> Void in
      self.actualPitchView!.alpha = 0.25
      }, completion: { (finished) -> Void in
        UIView.animateWithDuration(0.2, animations: { () -> Void in
          self.actualPitchView!.alpha = initialViewAlpha
          self.actualPitchView!.backgroundColor = initialViewColor
          }, completion: { (finished) -> Void in
        })
    })
  }
  
}
      
