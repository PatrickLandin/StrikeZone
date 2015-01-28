//
//  PitcherMenuViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class PitcherMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var newPitcherText: UITextField!
  
  var pitchers = [Pitcher]()
  var selectedRowIndex = NSIndexPath(forRow: -1, inSection: 1)
  var alertView : UIView?
  var imagePickerController = UIImagePickerController()
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      var pitcher1 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher2 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher3 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher4 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher5 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher6 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher7 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher8 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher9 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher10 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher11 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher12 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher13 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      var pitcher14 = Pitcher(name: "Pedro", number: 22, homeTown: "BingoLand", team: "The Bingos")
      
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
    
    var newPitcher = Pitcher(name: newPitcherText.text, number: 22, homeTown: "", team: "")
    self.pitchers.append(newPitcher)
    self.tableView.reloadData()
    self.alertView?.removeFromSuperview()
  }
  
  //MARK: Delete Button
  @IBAction func deleteButtonPressed(sender: AnyObject) {
    println("Sort stuff")
  }
  
  //MARK: Tableview datasource
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
    
    cell.imageButton.tag = indexPath.row
    cell.imageButton.addTarget(self, action: "showPickerController:", forControlEvents: UIControlEvents.TouchUpInside)
    
    return cell
  }
  
  //MARK: Instaniate StrikeZoneViewController
  func showMap(sender : UIButton) {
    
    println(sender.tag)
    var strikeZoneVC = self.storyboard?.instantiateViewControllerWithIdentifier("MAP") as StrikeZoneViewController
    let selectedIndexPath = self.tableView.indexPathForSelectedRow()?.row
    strikeZoneVC.selectedPitcher = self.pitchers[selectedIndexPath!]
    self.navigationController?.pushViewController(strikeZoneVC, animated: true)
  }
  
  //MARK: UIImagePickerController
  func showPickerController(sender : UIButton) {
          if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        self.presentViewController(self.imagePickerController, animated: true, completion: nil)
      }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
      let image = info[UIImagePickerControllerEditedImage] as UIImage
      
      //    self.pitcherImage.image = image
      //    self.selectedPitcher?.image = imageView.image
      
      self.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }
    
  }
  
  //MARK: Swipe to Delete
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
//  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//    if (editingStyle == UITableViewCellEditingStyle.Delete) {
//      self.pitchers.removeAtIndex(indexPath.row)
//      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//    }
//  }
  
  //MARK: Expand/Collapse tableView cells
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if selectedRowIndex.row == indexPath.row {
      return 196
    }
    return 40
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedRowIndex = indexPath
    tableView.beginUpdates()
    tableView.endUpdates()
  }

}








