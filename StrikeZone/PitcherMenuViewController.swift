//
//  PitcherMenuViewController.swift
//  StrikeZone
//
//  Created by Patrick Landin on 1/26/15.
//  Copyright (c) 2015 QadburyDreams. All rights reserved.
//

import UIKit
import CoreData

class PitcherMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, heatMapDelegate {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var newPitcherText: UITextField!
  @IBOutlet weak var newTeamText: UITextField!
  @IBOutlet weak var editPitcherText: UITextField!
  @IBOutlet weak var editTeamText: UITextField!
  @IBOutlet weak var addButton: UIBarButtonItem!
  
  var allPitchers : NSArray?
  var selectedPitcher : Pitcher?
  var alertView : UIView!
  var editAlertView : UIView!
  var selectedRowIndex = -1
  var selectedIndexPath : NSIndexPath!
  var imagePickerController = UIImagePickerController()
  var pitcherImage : UIImage?
  var fetchedResultController = NSFetchedResultsController()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationItem.title = "High Heat"

      self.tableView.delegate = self
      self.tableView.registerNib(UINib(nibName: "MenuCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL")
      self.tableView.estimatedRowHeight = 100
      self.tableView.rowHeight = UITableViewAutomaticDimension
      self.navigationController?.delegate = self
      self.tableView.separatorStyle = .None
      
      let fetchRequest = NSFetchRequest(entityName: "Pitcher")
      let teamSortDescriptor = NSSortDescriptor(key: "team", ascending: true)
      let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
      fetchRequest.sortDescriptors = [nameSortDescriptor, teamSortDescriptor]
      self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PitchService.sharedPitchService.coreDataStack.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
      self.fetchedResultController.delegate = self
      self.tableView.dataSource = self
      self.fetchedResultController.performFetch(nil)
      
      let sortDescriptor = NSSortDescriptor(key: "team", ascending: true)
      self.allPitchers = self.allPitchers?.sortedArrayUsingDescriptors([sortDescriptor])
      
        // Do any additional setup after loading the view.
    }
  
  //MARK: NSFetchedResultsController
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    self.tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    self.tableView.endUpdates()
  }
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    switch type {
    case NSFetchedResultsChangeType.Delete :
      self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
    case NSFetchedResultsChangeType.Insert :
      self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
    case NSFetchedResultsChangeType.Move :
      self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
      self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
    case NSFetchedResultsChangeType.Update :
      let menuCell = self.tableView.cellForRowAtIndexPath(indexPath!) as MenuTableViewCell
      configureCellAtIndexPath(menuCell, indexPath: indexPath!)
    default:
      println("default")
    }
  }
  
  func configureCellAtIndexPath(cell : MenuTableViewCell, indexPath : NSIndexPath) {
    
    var pitcherToDisplay = self.fetchedResultController.objectAtIndexPath(indexPath) as Pitcher
    cell.pitcherNameLabel.text = pitcherToDisplay.name
    cell.teamLabel.text = pitcherToDisplay.team
    cell.contentView.clipsToBounds = true
    
    cell.newMapButton.tag = indexPath.row
    cell.newMapButton.addTarget(self, action: "showMap:", forControlEvents: UIControlEvents.TouchUpInside)
    
//    cell.imageButton.enabled = false
    cell.imageButton.tag = indexPath.row
    cell.imageButton.addTarget(self, action: "showPickerController:", forControlEvents: UIControlEvents.TouchUpInside)
    
    cell.editButton.tag = indexPath.row
    cell.editButton.addTarget(self, action: "editPitcher:", forControlEvents: UIControlEvents.TouchUpInside)
    cell.editButton.enabled = true
    
    if pitcherToDisplay.realImage == nil {
    pitcherToDisplay.realImage = PitchService.sharedPitchService.convertDataToImage(pitcherToDisplay.pitcherImage)
    }
    
    
    cell.pitcherImage.image = pitcherToDisplay.realImage
    cell.pitcherImage.layer.masksToBounds = true
    cell.pitcherImage.layer.cornerRadius = 7.0
    
    cell.backgroundColor = UIColor.lightGrayColor()
    
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if let menuCell = cell as? MenuTableViewCell {
    }
  }

  //MARK: Segue to StrikeZone
//  func continueButtonPressed() {
//    let destinationVC = StrikeZoneViewController()
//    self.navigationController?.pushViewController(destinationVC, animated: true)
//  }
  
  //MARK: CollectionView DataSource
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    let indexPath = NSIndexPath(forRow: collectionView.tag, inSection: 0)
    let pitcher = self.fetchedResultController.objectAtIndexPath(indexPath) as Pitcher

    if pitcher.heatMaps.count == 0 {
      return 0
    }
    return pitcher.heatMaps.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as MenuCollectionViewCell
    
    cell.backgroundColor = UIColor.grayColor()
    cell.layer.cornerRadius = 7.0
    
    let contentView = collectionView.superview! as UIView
    let tableViewCell = contentView.superview as MenuTableViewCell
    let tableViewIndexPath = self.tableView.indexPathForCell(tableViewCell)
    let indexPath = NSIndexPath(forRow: collectionView.tag, inSection: 0)
    let pitcher = self.fetchedResultController.objectAtIndexPath(indexPath) as Pitcher
    
    let heatMaps = pitcher.heatMaps.allObjects
    if let currentHeatMap = heatMaps[indexPath.row] as? HeatMap {
      let heatMapImage = PitchService.sharedPitchService.convertDataToImage(currentHeatMap.heatMapImage)
      cell.mapImageView.image = heatMapImage
    }
    return cell
  }
  
  //MARK: Tableview DataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionInfo = self.fetchedResultController.sections![section] as NSFetchedResultsSectionInfo
    println("numer of objects in tableview : \(sectionInfo.numberOfObjects)")
    return sectionInfo.numberOfObjects
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as MenuTableViewCell
    configureCellAtIndexPath(cell, indexPath: indexPath)
    return cell
  }
  
  //MARK: CollectionView DidSelectACell
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let contentView = collectionView.superview! as UIView
    let tableViewCell = contentView.superview as MenuTableViewCell
    let tableViewIndexPath = self.tableView.indexPathForCell(tableViewCell)
    let pitcher = self.fetchedResultController.objectAtIndexPath(tableViewIndexPath!) as Pitcher
    
    let selectedHeatMap = self.selectedPitcher?.heatMaps.allObjects[indexPath.row] as HeatMap
    var strikeZoneVC = self.storyboard?.instantiateViewControllerWithIdentifier("MAP") as StrikeZoneViewController
    strikeZoneVC.currentHeatMap = selectedHeatMap
    strikeZoneVC.selectedPitcher = pitcher
    //strikeZoneVC.delegate = self
    self.navigationController?.pushViewController(strikeZoneVC, animated: true)
  }
  
  //MARK: New Pitcher
  @IBAction func addPressed(sender: AnyObject) {
    
    var alert = UIAlertController(title: "New Pitcher", message: "Enter Pitcher's Info", preferredStyle: UIAlertControllerStyle.Alert)
    
    var pitcherNameTextField: UITextField?
    var teamNameTextField: UITextField?
    
    alert.addTextFieldWithConfigurationHandler { (pitcherTextField : UITextField!) -> Void in
      pitcherTextField.placeholder = "Name"
      pitcherNameTextField = pitcherTextField
    }
    
    alert.addTextFieldWithConfigurationHandler { (teamTextField : UITextField!) -> Void in
      teamTextField.placeholder = "Team"
      teamNameTextField = teamTextField
    }
    
    let saveAction = UIAlertAction(title: "Create", style: .Default) { (action) -> Void in
      
      var name : String?
      var team : String?
      
      if (pitcherNameTextField?.text != "") {
        println(pitcherNameTextField!.text)
        name = pitcherNameTextField!.text
      }
      else {
        name = ""
      }
      if (teamNameTextField?.text != "") {
        println(teamNameTextField!.text)
        team = teamNameTextField!.text
      }
      else {
        team = ""
      }
      var newPitcher = PitchService.sharedPitchService.newPitcher(name!, team : team!)
    }
    
    let cancelAction = UIAlertAction(title:"Cancel", style:.Destructive, handler: nil)
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    self.presentViewController(alert, animated: true, completion: nil)
    self.tableView.reloadData()
  }
  
  //MARK: Edit Pitcher
  func editPitcher(sender : UIButton) {
    
    var alert = UIAlertController(title: "Edit", message: "Enter Pitcher's Info", preferredStyle: UIAlertControllerStyle.Alert)
    
    var pitcherNameTextField: UITextField?
    var teamNameTextField: UITextField?
    
    alert.addTextFieldWithConfigurationHandler { (pitcherTextField : UITextField!) -> Void in
      pitcherTextField.placeholder = "Name"
      pitcherNameTextField = pitcherTextField
    }
    
    alert.addTextFieldWithConfigurationHandler { (teamTextField : UITextField!) -> Void in
      teamTextField.placeholder = "Team"
      teamNameTextField = teamTextField
    }
    
    let saveAction = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
      if (pitcherNameTextField?.text != "") {
      println(pitcherNameTextField!.text)
        self.selectedPitcher?.name = pitcherNameTextField!.text
      }
      if (teamNameTextField?.text != "") {
        println(teamNameTextField!.text)
        self.selectedPitcher?.team = teamNameTextField!.text
      }
      
      PitchService.sharedPitchService.saveEditedPitcher(self.selectedPitcher!)

    }
    
    let removeAction = UIAlertAction(title: "Remove", style: .Default) { (action) -> Void in
      PitchService.sharedPitchService.josePaniagua(self.selectedPitcher!)
    }
    let cancelAction = UIAlertAction(title:"Cancel", style:.Destructive, handler: nil)

    alert.addAction(saveAction)
    alert.addAction(removeAction)
    alert.addAction(cancelAction)
    self.presentViewController(alert, animated: true, completion: nil)

    self.tableView.reloadData()
  }
  
  //MARK: Instantiate StrikeZoneViewController
  func showMap(sender : UIButton) {
    
    var strikeZoneVC = self.storyboard?.instantiateViewControllerWithIdentifier("MAP") as StrikeZoneViewController
    strikeZoneVC.selectedPitcher = self.fetchedResultController.objectAtIndexPath(self.selectedIndexPath) as? Pitcher
    strikeZoneVC.delegate = self
    self.tableView.selectRowAtIndexPath(self.selectedIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
    self.navigationController?.pushViewController(strikeZoneVC, animated: true)
  }
  
  //MARK: UIImagePickerController
  func showPickerController(sender : UIButton) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      self.imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
      self.imagePickerController.delegate = self
      self.imagePickerController.allowsEditing = true
//      sender.enabled = false
      self.presentViewController(self.imagePickerController, animated: true, completion: nil)
    }
  }
  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
      self.pitcherImage = info[UIImagePickerControllerEditedImage] as? UIImage
      PitchService.sharedPitchService.covertAndSaveImageForPitcher(self.selectedPitcher!, image: self.pitcherImage!)
      self.tableView.reloadData()
      self.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }
  
  //MARK: Expand/Collapse tableView cells
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == selectedRowIndex {
      return 221
    }
    return 70
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    self.performSegueWithIdentifier("SHOW_MAPS", sender: self)
//    
//    tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    var cell : MenuTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as MenuTableViewCell
//    self.selectedIndexPath = indexPath
//    self.selectedPitcher = self.fetchedResultController.objectAtIndexPath(indexPath) as? Pitcher
//    
//    if selectedRowIndex == indexPath.row {
//      selectedRowIndex = -1
//      cell.imageButton.enabled = false
//    } else {
//      self.selectedRowIndex = indexPath.row
//      cell.imageButton.enabled = true
//      cell.editButton.enabled = true
//    }
//    tableView.beginUpdates()
//    tableView.endUpdates()
  }
  
  //MARK: Swipe to Delete
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if (editingStyle == UITableViewCellEditingStyle.Delete) {
      PitchService.sharedPitchService.josePaniagua(self.fetchedResultController.objectAtIndexPath(indexPath) as Pitcher)
    }
  }
  
  //MARK: Segue
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SHOW_MAPS" {
      
      let destinationVC = segue.destinationViewController as HeatMapCollectionViewController
      let selectedIndexPath = self.tableView.indexPathsForSelectedRows()!.first as NSIndexPath
      var pitcherToPass = self.fetchedResultController.objectAtIndexPath(selectedIndexPath) as Pitcher
      destinationVC.selectedPitcher = pitcherToPass
    }
  }
  
  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    var cell : MenuTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as MenuTableViewCell
//    cell.imageButton.enabled = false
  }

  //MARK: Data Passing
  func setPitcher(pitcher: Pitcher?){
    println("this should also fire")
    self.tableView.reloadData()
  }
  
}



