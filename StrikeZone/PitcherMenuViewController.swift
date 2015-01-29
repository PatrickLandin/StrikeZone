//
//  PitcherMenuViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit

class PitcherMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var newPitcherText: UITextField!
  @IBOutlet weak var newTeamText: UITextField!
  @IBOutlet weak var editPitcherText: UITextField!
  @IBOutlet weak var editTeamText: UITextField!
  
  var pitchers = [Pitcher]()
  var selectedPitcher : Pitcher?
  var alertView : UIView!
  var editAlertView : UIView!
  var selectedRowIndex = -1
  var imagePickerController = UIImagePickerController()
  var pitcherImage : UIImage?
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationItem.title = "Strike Zone"
      
      var pitcher1 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher2 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher3 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher4 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher5 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher6 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher7 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher8 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher9 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher10 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher11 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher12 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher13 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      var pitcher14 = Pitcher(name: "Mr. Gomez", team: "Hillside BloomyBombers")
      
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
      self.navigationController?.delegate = self

        // Do any additional setup after loading the view.
    }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if let menuCell = cell as? MenuTableViewCell {
      menuCell.collectionView.dataSource = self
    }
  }
  
  //MARK: CollectionView DataSource
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if selectedPitcher?.heatMaps.count == nil {
      return 50
    }
    return self.selectedPitcher!.heatMaps.count
    
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as MenuCollectionViewCell
    
    cell.backgroundColor = UIColor.grayColor()
    cell.layer.cornerRadius = 7.0
    cell.mapImageView.image = self.selectedPitcher?.heatMaps[indexPath.row].heatMapImage
    
    return cell
  }
  
  //MARK: New Pitcher
  @IBAction func addPressed(sender: AnyObject) {
    
    self.alertView = NSBundle.mainBundle().loadNibNamed("AddPitcherAlert", owner: self, options: nil).first as? UIView
    self.alertView.center = self.view.center
    self.alertView.alpha = 0
    self.alertView.layer.cornerRadius = 15.0
    self.alertView.transform = CGAffineTransformMakeScale(0.4, 0.4)
    self.view.addSubview(alertView)
    
    UIView.animateWithDuration(0.4, delay: 0.1, options: nil, animations: { () -> Void in
      self.alertView.alpha = 1
      self.alertView.layer.cornerRadius = 15.0
      self.alertView.backgroundColor = UIColor.lightGrayColor()
      self.alertView.transform =  CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
    }
  }

  @IBAction func addPitcherPressed(sender: AnyObject) {    
    var newPitcher = Pitcher(name: self.newPitcherText.text, team: self.newTeamText.text)
    self.pitchers.append(newPitcher)
    self.tableView.reloadData()
    
    UIView.animateWithDuration(0.4, delay: 0.1, options: nil, animations: { () -> Void in
      self.alertView.alpha = 0
      self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
        self.alertView.removeFromSuperview()
    }
  }
  
  @IBAction func cancelNewPressed(sender: UIButton) {
    UIView.animateWithDuration(0.4, delay: 0.1, options: nil, animations: { () -> Void in
      self.alertView.alpha = 0
      self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
        self.alertView.removeFromSuperview()
    }
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
    cell.teamLabel.text = pitcherToDisplay.team
    cell.contentView.clipsToBounds = true
    
    cell.newMapButton.tag = indexPath.row
    cell.newMapButton.addTarget(self, action: "showMap:", forControlEvents: UIControlEvents.TouchUpInside)
    
    cell.imageButton.tag = indexPath.row
    cell.imageButton.addTarget(self, action: "showPickerController:", forControlEvents: UIControlEvents.TouchUpInside)
    
    cell.editButton.tag = indexPath.row
    cell.editButton.addTarget(self, action: "editPitcher:", forControlEvents: UIControlEvents.TouchUpInside)
    
    cell.pitcherImage.image = pitcherToDisplay.pitcherImage
    cell.pitcherImage.layer.masksToBounds = true
    cell.pitcherImage.layer.cornerRadius = 10.0
    
//    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
//    let blurEffectView = UIVisualEffectView(effect: blurEffect)
//    blurEffectView.frame = cell.bounds
//    cell.insertSubview(blurEffectView, atIndex: indexPath.row)
    
    return cell
  }
  
  //MARK: Edit Pitcher
  func editPitcher(sender : UIButton) {
    
    self.editAlertView = NSBundle.mainBundle().loadNibNamed("editPitcherAlert", owner: self, options: nil).first as? UIView
    self.editAlertView.center = self.view.center
    self.editAlertView.alpha = 0
    self.editAlertView.layer.cornerRadius = 15.0
    self.editAlertView.transform = CGAffineTransformMakeScale(0.5, 0.5)
    self.view.addSubview(self.editAlertView)
    
    UIView.animateWithDuration(0.4, delay: 0.1, options: nil, animations: { () -> Void in
      self.editAlertView.alpha = 1
      self.editAlertView.layer.cornerRadius = 15.0
      self.editAlertView.backgroundColor = UIColor.lightGrayColor()
      self.editAlertView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
    }
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = editAlertView.bounds
//        editAlertView.insertSubview(blurEffectView, belowSubview: editAlertView)
  }
  
  @IBAction func editingDonePressed(sender: UIButton) {
    var editedPitcher = self.pitchers[selectedRowIndex]
    editedPitcher.name = self.editPitcherText.text
    editedPitcher.team = self.editTeamText.text
    self.tableView.reloadData()
    
    UIView.animateWithDuration(0.4, delay: 0.1, options: nil, animations: { () -> Void in
      self.editAlertView.alpha = 0
      self.editAlertView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
        self.editAlertView.removeFromSuperview()
    }
  }

  @IBAction func editCancelPressed(sender: UIButton) {
    UIView.animateWithDuration(0.4, delay: 0.1, options: nil, animations: { () -> Void in
      self.editAlertView.alpha = 0
      self.editAlertView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
        self.editAlertView.removeFromSuperview()
    }
  }
  
  @IBAction func removeButtonPressed(sender: UIButton) {
    var removedPitcher = self.pitchers[selectedRowIndex]
    pitchers.removeAtIndex(selectedRowIndex)
    self.tableView.reloadData()
    
    UIView.animateWithDuration(0.4, delay: 0.1, options: nil, animations: { () -> Void in
      self.editAlertView.alpha = 0
      self.editAlertView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
        self.editAlertView.removeFromSuperview()
    }
  }
  
  //MARK: Instaniate StrikeZoneViewController
  func showMap(sender : UIButton) {
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
      self.selectedPitcher = self.pitchers[sender.tag]
    }
  }
  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
      self.pitcherImage = info[UIImagePickerControllerEditedImage] as? UIImage
      self.selectedPitcher!.pitcherImage = self.pitcherImage
      self.tableView.reloadData()
      self.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
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
    if indexPath.row == selectedRowIndex {
      return 221
    }
    return 70
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    if selectedRowIndex == indexPath.row {
      selectedRowIndex = -1
    } else {
      self.selectedRowIndex = indexPath.row
    }
    tableView.beginUpdates()
    tableView.endUpdates()
  }

}








