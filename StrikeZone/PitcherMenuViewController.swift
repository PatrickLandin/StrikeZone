//
//  PitcherMenuViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class PitcherMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var newPitcherText: UITextField!
  
  var pitchers = [Pitcher]()
  var alertView : UIView?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      var pitcher1 = Pitcher(name: "Pedro")
      var pitcher2 = Pitcher(name: "Randy")
      var pitcher3 = Pitcher(name: "Greg")
      var pitcher4 = Pitcher(name: "Roger")
      var pitcher5 = Pitcher(name: "Felix")
      var pitcher6 = Pitcher(name: "Clayton")
      var pitcher7 = Pitcher(name: "Nolan")
      
      pitchers.append(pitcher1)
      pitchers.append(pitcher2)
      pitchers.append(pitcher3)
      pitchers.append(pitcher4)
      pitchers.append(pitcher5)
      pitchers.append(pitcher6)
      pitchers.append(pitcher7)
      
      self.tableView.delegate = self
      self.tableView.dataSource = self
      self.tableView.registerNib(UINib(nibName: "MenuCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL")
//      self.tableView.estimatedRowHeight = 100
//      self.tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }

  
  @IBAction func addButtonPressed(sender: AnyObject) {
    println("Add stuff")
    
    self.alertView = NSBundle.mainBundle().loadNibNamed("AddPitcherAlert", owner: self, options: nil).first as? UIView
    self.alertView!.center = self.view.center
    self.alertView!.alpha = 0
    self.alertView!.transform = CGAffineTransformMakeScale(0.4, 0.4)
    self.view.addSubview(alertView!)
    
    UIView.animateWithDuration(0.4, delay: 0.5, options: nil, animations: { () -> Void in
      self.alertView!.alpha = 1
      self.alertView!.transform =  CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
        
    }
  }
  
  @IBAction func addPitcherPressed(sender: AnyObject) {
    println(newPitcherText.text)
    
    var newPitcher = Pitcher(name: newPitcherText.text)
    self.pitchers.append(newPitcher)
    self.tableView.reloadData()
    self.alertView?.removeFromSuperview()
    
  }
  
  
  @IBAction func deleteButtonPressed(sender: AnyObject) {
    println("Delete stuff")
    
    
    
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.pitchers.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as MenuTableViewCell
    
    var pitcherToDisplay = self.pitchers[indexPath.row]
    cell.pitcherNameLabel.text = pitcherToDisplay.name
    
    return cell
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if (editingStyle == UITableViewCellEditingStyle.Delete) {
      self.pitchers.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }

}
