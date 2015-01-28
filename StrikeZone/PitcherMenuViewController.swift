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
  var selectedRowIndex = NSIndexPath(forRow: -1, inSection: 1)
  var alertView : UIView?
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      var pitcher1 = Pitcher(name: "Pedro", number: 22)
      var pitcher2 = Pitcher(name: "Roger", number: 22)
      var pitcher3 = Pitcher(name: "Gilroy", number: 22)
      var pitcher4 = Pitcher(name: "Gregory", number: 22)
      var pitcher5 = Pitcher(name: "Felix", number: 22)
      var pitcher6 = Pitcher(name: "Clayton", number: 22)
      var pitcher7 = Pitcher(name: "Stanly", number: 22)
      var pitcher8 = Pitcher(name: "Pedro", number: 22)
      var pitcher9 = Pitcher(name: "Roger", number: 22)
      var pitcher10 = Pitcher(name: "Gilroy", number: 22)
      var pitcher11 = Pitcher(name: "Gregory", number: 22)
      var pitcher12 = Pitcher(name: "Felix", number: 22)
      var pitcher13 = Pitcher(name: "Clayton", number: 22)
      var pitcher14 = Pitcher(name: "Stanly", number: 22)
      
      pitchers.append(pitcher1)
      pitchers.append(pitcher2)
      pitchers.append(pitcher3)
      pitchers.append(pitcher4)
      pitchers.append(pitcher5)
      pitchers.append(pitcher6)
      pitchers.append(pitcher7)
      pitchers.append(pitcher8)
      pitchers.append(pitcher9)
      pitchers.append(pitcher10)
      pitchers.append(pitcher11)
      pitchers.append(pitcher12)
      pitchers.append(pitcher13)
      pitchers.append(pitcher14)
      
      self.tableView.delegate = self
      self.tableView.dataSource = self
      self.tableView.registerNib(UINib(nibName: "MenuCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL")
      self.tableView.estimatedRowHeight = 100
      self.tableView.rowHeight = UITableViewAutomaticDimension

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
    
    var newPitcher = Pitcher(name: newPitcherText.text, number: 22)
    self.pitchers.append(newPitcher)
    self.tableView.reloadData()
    self.alertView?.removeFromSuperview()
    
  }
  
  
  @IBAction func deleteButtonPressed(sender: AnyObject) {
    println("Delete stuff")
    
    
    
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.pitchers.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as MenuTableViewCell
    
    var pitcherToDisplay = self.pitchers[indexPath.row]
    cell.pitcherNameLabel.text = pitcherToDisplay.name
    cell.contentView.clipsToBounds = true
    
    cell.newMapButton.tag = indexPath.row
    cell.newMapButton.addTarget(self, action: "showMap:", forControlEvents: UIControlEvents.TouchUpInside)
    
    return cell
  }
  
  func showMap(sender : UIButton) {
    
    println(sender.tag)
    var strikeZoneVC = self.storyboard?.instantiateViewControllerWithIdentifier("MAP") as StrikeZoneViewController
    let selectediIndexPath = self.tableView.indexPathForSelectedRow()?.row
    strikeZoneVC.selectedPitcher = self.pitchers[selectediIndexPath!]
    self.navigationController?.pushViewController(strikeZoneVC, animated: true)
    
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
//  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//    if (editingStyle == UITableViewCellEditingStyle.Delete) {
//      self.pitchers.removeAtIndex(indexPath.row)
//      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//    }
//  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if selectedRowIndex.row == indexPath.row {
      return 196
    }
    return 50
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedRowIndex = indexPath
    tableView.beginUpdates()
    tableView.endUpdates()
    
  }

}








