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
  
  var pitchers = [Pitcher]()
  var selectedPitcher : Pitcher?
  var alertView : UIView!
  var editAlertView : UIView!
  var selectedRowIndex = -1
  var selectedIndexPath : NSIndexPath!
  var imagePickerController = UIImagePickerController()
  var pitcherImage : UIImage?
  var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationItem.title = "High Heat"

      self.tableView.delegate = self
      self.tableView.registerNib(UINib(nibName: "MenuCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL")
      self.tableView.estimatedRowHeight = 100
      self.tableView.rowHeight = UITableViewAutomaticDimension
      self.navigationController?.delegate = self
      //self.tableView.backgroundColor = UIColor(red: 0.82, green: 0.88, blue: 0.89, alpha: 1)
      self.tableView.separatorStyle = .None
      
      let fetchRequest = NSFetchRequest(entityName: "Pitcher")
      let teamSortDescriptor = NSSortDescriptor(key: "team", ascending: true)
      let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
      fetchRequest.sortDescriptors = [teamSortDescriptor, nameSortDescriptor]
      self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PitchService.sharedPitchService.coreDataStack.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
      self.fetchedResultController.delegate = self
            self.tableView.dataSource = self
      self.fetchedResultController.performFetch(nil)
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
    
    cell.imageButton.tag = indexPath.row
    cell.imageButton.addTarget(self, action: "showPickerController:", forControlEvents: UIControlEvents.TouchUpInside)
    
    cell.editButton.tag = indexPath.row
    cell.editButton.addTarget(self, action: "editPitcher:", forControlEvents: UIControlEvents.TouchUpInside)
    cell.editButton.enabled = true
    
    let pitcherImage = PitchService.sharedPitchService.convertDataToImage(pitcherToDisplay.pitcherImage)
    
    cell.pitcherImage.image = pitcherImage
    cell.pitcherImage.layer.masksToBounds = true
    cell.pitcherImage.layer.cornerRadius = 7.0
    
    cell.backgroundColor = UIColor.lightGrayColor()
    
    cell.collectionView.reloadData()
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//    return self.fetchedResultController.sections!.count
    return 1
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if let menuCell = cell as? MenuTableViewCell {
      menuCell.collectionView.dataSource = self
      menuCell.collectionView.delegate = self
    }
  }
  
  func continueButtonPressed() {
    let destinationVC = StrikeZoneViewController()
    self.navigationController?.pushViewController(destinationVC, animated: true)
  }
  
  //MARK: CollectionView DataSource
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let contentView = collectionView.superview! as UIView
    let tableViewCell = contentView.superview as MenuTableViewCell
    let tableViewIndexPath = self.tableView.indexPathForCell(tableViewCell)
    let pitcher = self.fetchedResultController.objectAtIndexPath(tableViewIndexPath!) as Pitcher

    
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
    let pitcher = self.fetchedResultController.objectAtIndexPath(tableViewIndexPath!) as Pitcher
    
    let heatMaps = pitcher.heatMaps.allObjects
    if let currentHeatMap = heatMaps[indexPath.row] as? HeatMap{
      let heatMapImage = PitchService.sharedPitchService.convertDataToImage(currentHeatMap.heatMapImage)
      cell.mapImageView.image = heatMapImage
    }
    
    
    return cell
  }
  //MARK: Tableview DataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionInfo = self.fetchedResultController.sections![section] as NSFetchedResultsSectionInfo
    
//    if sectionInfo.numberOfObjects == 0{
//      let alertView = UIAlertView(title: "Initial Setup", message: "Please press the + in the bottom right corner to create your first pitcher.", delegate: self, cancelButtonTitle: "OK")
//      alertView.show()
//    }
    
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
//    let pitcher = self.pitchers[tableViewIndexPath!.row]
    
    let selectedHeatMap = self.selectedPitcher?.heatMaps.allObjects[indexPath.row] as HeatMap
    var strikeZoneVC = self.storyboard?.instantiateViewControllerWithIdentifier("MAP") as StrikeZoneViewController
    //let selectedIndexPath = self.tableView.indexPathForSelectedRow()?.row
    strikeZoneVC.currentHeatMap = selectedHeatMap
    strikeZoneVC.selectedPitcher = pitcher
    strikeZoneVC.delegate = self
    self.navigationController?.pushViewController(strikeZoneVC, animated: true)
    
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
      self.alertView.transform =  CGAffineTransformMakeScale(1.0 , 1.0)
      }) { (finished) -> Void in
    }
    self.addButton.enabled = false
  }

  @IBAction func addPitcherPressed(sender: AnyObject) {    
    var newPitcher = PitchService.sharedPitchService.newPitcher(self.newPitcherText.text, team: self.newTeamText.text)
    //self.pitchers.insert(newPitcher!, atIndex: 0)
    //self.tableView.reloadData()
    
    UIView.animateWithDuration(0.4, delay: 0.1, options: nil, animations: { () -> Void in
      self.alertView.alpha = 0
      self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
        self.alertView.removeFromSuperview()
        self.addButton.enabled = true
    }
  }
  
  @IBAction func cancelNewPressed(sender: UIButton) {
    UIView.animateWithDuration(0.4, delay: 0.1, options: nil, animations: { () -> Void in
      self.alertView.alpha = 0
      self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
        self.alertView.removeFromSuperview()
    }
    self.addButton.enabled = true
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
    sender.enabled = false
  }
  
  @IBAction func editingDonePressed(sender: UIButton) {
    
    if editPitcherText.text != "" {
      selectedPitcher!.name = self.editPitcherText.text
    }
    if editTeamText.text != "" {
      selectedPitcher!.team = self.editTeamText.text
    }
    var editError : NSError?
    PitchService.sharedPitchService.coreDataStack.managedObjectContext?.save(&editError)
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
    
    PitchService.sharedPitchService.coreDataStack.managedObjectContext?.deleteObject(self.selectedPitcher! as NSManagedObject)
    var deleteError : NSError?
    PitchService.sharedPitchService.coreDataStack.managedObjectContext?.save(&deleteError)
    println(deleteError?.localizedDescription)
    
    self.tableView.reloadData()
    
    UIView.animateWithDuration(0.4, delay: 0.1, options: nil, animations: { () -> Void in
      self.editAlertView.alpha = 0
      self.editAlertView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }) { (finished) -> Void in
        self.editAlertView.removeFromSuperview()
    }
  }
  
  //MARK: Instantiate StrikeZoneViewController
  func showMap(sender : UIButton) {
    
    var strikeZoneVC = self.storyboard?.instantiateViewControllerWithIdentifier("MAP") as StrikeZoneViewController
    //self.selectedIndexPath = self.tableView.indexPathForSelectedRow()?
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
      self.presentViewController(self.imagePickerController, animated: true, completion: nil)
//      self.selectedPitcher = self.pitchers[self.selectedIndexPath.row]
    }
  }
  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
      self.pitcherImage = info[UIImagePickerControllerEditedImage] as? UIImage
      PitchService.sharedPitchService.covertAndSaveImageForPitcher(self.selectedPitcher!, image: self.pitcherImage!)
      
//      self.selectedPitcher!.pitcherImage = self.pitcherImage
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
    
    self.selectedIndexPath = indexPath
    self.selectedPitcher = self.fetchedResultController.objectAtIndexPath(indexPath) as? Pitcher
    
    if selectedRowIndex == indexPath.row {
      selectedRowIndex = -1
    } else {
      self.selectedRowIndex = indexPath.row
    }
    tableView.beginUpdates()
    tableView.endUpdates()
  }

  //MARK: Data Passing
  func setPitcher(pitcher: Pitcher?){
    println("this should also fire")
    self.tableView.reloadData()
  }
  
}



