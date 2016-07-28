//
//  SignUpViewController.swift
//  E-Legal
//
//  Created by Toqir Ahmad on 19/07/2016.
//  Copyright © 2016 Toqir Ahmad. All rights reserved.
//

import UIKit
import Parse
class SignUpViewController: UIViewController {

   @IBOutlet weak var signUpTableView: UITableView!
   let dobPicker = UIDatePicker()
   var signUpCell: SignUpTableViewCell?
   var photoUrl: NSURL?
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      navigationController?.navigationBarHidden = true
      automaticallyAdjustsScrollViewInsets = false
      dateOfBirthPicker()
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }

   @IBAction func goBack (sender: UIButton) {
      navigationController?.popViewControllerAnimated(true)
   }

   @IBAction func addPhoto (sender: UIButton) {
      let alert: UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
      let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
         UIAlertAction in
         self.openCamera()
      }
      let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default) {
         UIAlertAction in
         self.openGallary()
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
         UIAlertAction in
      }

      alert.addAction(cameraAction)
      alert.addAction(gallaryAction)
      alert.addAction(cancelAction)
      presentViewController(alert, animated: true, completion: nil)

   }

   func openCamera() {
      if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
         let picker = UIImagePickerController()
         picker.delegate = self
         picker.sourceType = UIImagePickerControllerSourceType.Camera
         presentViewController(picker, animated: true, completion: nil)
      } else {
//            ApplicationHelper.showAlertView("Alert", message: "You don't have camera", view: self)
      }
   }

   func openGallary() {
      let picker = UIImagePickerController()
      picker.delegate = self
      picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      presentViewController(picker, animated: true, completion: nil)
   }

   @IBAction func signUpLinkedin (sender: UIButton) {

   }

   @IBAction func createAccount (sender: UIButton) {
      validateFields()
   }

   func dateOfBirthPicker () {
      dobPicker.datePickerMode = UIDatePickerMode.Date
      dobPicker.maximumDate = NSDate()
      dobPicker.addTarget(self, action: #selector(SignUpViewController.handleDateOfBirthPicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
   }

   func handleDateOfBirthPicker(sender: UIDatePicker) {
      let timeFormatter = NSDateFormatter()
      timeFormatter.dateFormat = "MM-dd-yyyy"
      signUpCell?.textFieldDateOfBirth.text = timeFormatter.stringFromDate(sender.date)
   }

   func validateFields() {
      var error = ""
      if signUpCell?.textFieldName.text == "Please enter your Name!\n" {
         error = error.stringByAppendingString("")
      }
      if signUpCell?.textFieldemail.text == "" {
         error = error.stringByAppendingString("Please enter your Email!\n")
      }
      if signUpCell?.textFieldPassword.text == "" {
         error = error.stringByAppendingString("Please enter Password!\n")
      }
      if signUpCell?.textFieldPhoneNumber.text == "" {
         error = error.stringByAppendingString("Please enter your Phone Number!\n")
      }
      if signUpCell?.textFieldDateOfBirth.text == "" {
         error = error.stringByAppendingString("Please enter Date of Birth!\n")
      }
      if signUpCell?.switchLawyer.on == true {
         if signUpCell?.textFieldRegistrationNo.text == "" {
            error = error.stringByAppendingString("Please enter your Registration Number!\n")
         }
         if signUpCell?.textFieldAreaOfPractice.text == "" {
            error = error.stringByAppendingString("Please enter your Area of Practice!\n")
         }
      }
      if error == "" {
         signUpNewuser()
      } else {
         ApplicationHelper.showAlertView("Alert!", message: error, view: self)
      }
   }

   func signUpNewuser() {
      let newUser = PFUser()
      newUser.username = signUpCell?.textFieldName.text
      newUser.password = signUpCell?.textFieldPassword.text
      newUser.email = signUpCell?.textFieldemail.text
      newUser["phonePrimary"] = signUpCell?.textFieldPhoneNumber.text
//      newUser["areaOfPractice"] = signUpCell?.textFieldAreaOfPractice.text
//      newUser["isLawyer"] = signUpCell?.switchLawyer.on
//      newUser["registrationNumber"] = signUpCell?.textFieldRegistrationNo.text
//      newUser["dateOfBirth"] = signUpCell?.textFieldDateOfBirth.text
      do {
         newUser["photo"] = try PFFile(name: "photo", contentsAtPath: "\(photoUrl)")
      } catch {

      }
      // Sign up the user asynchronously
      var Error = ""
      newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
         if ((error) != nil) {
            if let errorDescription = error?.localizedDescription {
               Error = errorDescription
            }
            ApplicationHelper.showAlertView("Error", message: Error, view: self)
         } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
               let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
               let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("SSASideMenu") as! SSASideMenu
               let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
               appDelegate?.window?.rootViewController = viewController
            })
         }
      })
   }

   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

   }
}

extension SignUpViewController: UITableViewDataSource, UITableViewDelegate {

   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
   }

   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
   }

   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

      signUpCell = tableView.dequeueReusableCellWithIdentifier("signUpTableViewCell") as? SignUpTableViewCell
      guard let signUpCell = signUpCell else { return UITableViewCell() }
      signUpCell.buttonAddPhoto.addTarget(self, action: #selector(SignUpViewController.addPhoto(_:)), forControlEvents: UIControlEvents.TouchUpInside)
      signUpCell.buttonLinkedIn.addTarget(self, action: #selector(SignUpViewController.signUpLinkedin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
      signUpCell.buttonCreateAccount.addTarget(self, action: #selector(SignUpViewController.createAccount(_:)), forControlEvents: UIControlEvents.TouchUpInside)
      signUpCell.buttonGoBack.addTarget(self, action: #selector(SignUpViewController.goBack(_:)), forControlEvents: UIControlEvents.TouchUpInside)
      signUpCell.textFieldDateOfBirth.inputView = dobPicker
      return signUpCell
   }
}

extension SignUpViewController: UITextFieldDelegate {

   func textFieldDidBeginEditing(textField: UITextField) {

   }

   func textFieldDidEndEditing(textField: UITextField) {

   }

   func textFieldShouldReturn(textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
   }
}

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

   func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
      if let imageUrl = info[UIImagePickerControllerReferenceURL] as? NSURL {
         if let imageName = imageUrl.lastPathComponent {
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
            let photoURL = NSURL(fileURLWithPath: documentDirectory)
            photoUrl = photoURL.URLByAppendingPathComponent(imageName)
         }
      }
      if let choosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
         signUpCell?.ImageViewUser.image = choosenImage
         signUpCell?.buttonAddPhoto.setImage(nil, forState: UIControlState.Normal)
         signUpCell?.buttonAddPhoto.setTitle("", forState: UIControlState.Normal)
      }
      dismissViewControllerAnimated(true, completion: nil)
   }
}
