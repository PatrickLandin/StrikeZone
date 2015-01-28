//
//  StrikeZoneViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class StrikeZoneViewController: UIViewController{

  @IBOutlet weak var outZoneView: UIView!
  
  @IBOutlet weak var inZoneView: UIView!
  
  var pitchLocation = [CGPoint]()
  let locationView = UIView()
  var selectedPitcher = Pitcher?()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationItem.title = selectedPitcher?.name
      
      locationView.backgroundColor = UIColor.brownColor()
      locationView.frame = CGRect(x: -150, y: -150, width: 100, height: 100)
      self.view.addSubview(locationView)

      let tap = UITapGestureRecognizer(target: self, action: ("handleTap:"))
      view.addGestureRecognizer(tap)
      println(tap)
        // Do any additional setup after loading the view.
    }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    let imageView = UIImageView(image: UIImage(named: "pixelGlove"))
    self.locationView.addSubview(imageView)
    self.locationView.backgroundColor = UIColor.clearColor()
    println(imageView.frame)
  }

  func handleTap(gesture: UITapGestureRecognizer) {
    let tapLocation = gesture.locationInView(view)
    println(tapLocation)
    pitchLocation.append(tapLocation)
    println(pitchLocation.count)
    for subView in self.view.subviews {
      if let view = subView as? UIView {
        if CGRectContainsPoint(view.frame, tapLocation){
          println(view.tag)
          locationView.center = tapLocation
      }
    }
  }
  }
  
}
