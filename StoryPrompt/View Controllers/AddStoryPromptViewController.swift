//
//  ViewController.swift
//  StoryPrompt
//
//  Created by Rastaar Haghi on 11/1/20.
//

import UIKit
import PhotosUI

class AddStoryPromptViewController: UIViewController {

    @IBOutlet weak var NounTextField: UITextField!
    @IBOutlet weak var AdjectiveTextField: UITextField!
    @IBOutlet weak var VerbTextField: UITextField!
    @IBOutlet weak var numberSlider: UISlider!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var StoryPromptImageView: UIImageView!
    
    let storyPrompt = StoryPromptEntry()
    
    @IBAction func changedNumber(_ sender: UISlider) {
        numberLabel.text = "Number: \(Int(sender.value))"
        storyPrompt.number = Int(sender.value)
    }
    
    @IBAction func changedStoryType(_ sender: UISegmentedControl) {
        if let genre = StoryPrompts.Genre(rawValue: sender.selectedSegmentIndex) {
            storyPrompt.genre = genre
        } else {
            storyPrompt.genre = .scifi
        }
    }
    
    @IBAction func generateStoryPrompt(_ sender: Any) {
        updateStoryPrompt()
        if storyPrompt.isValid() {
            performSegue(withIdentifier: "StoryPrompt", sender: nil)
        } else {
            let alert = UIAlertController(title: "Invalid Story Prompt", message: "Please fill out all of the fields", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: {action
                in
                
            })
            alert.addAction(action)
            present(alert, animated: true)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberSlider.value = 7.5
        // Do any additional setup after loading the view.
        StoryPromptImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        StoryPromptImageView.addGestureRecognizer(gestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(updateStoryPrompt), name: UIResponder.keyboardDidHideNotification, object: nil)
        print(storyPrompt)
    }
    
    @objc func updateStoryPrompt() {
        storyPrompt.noun = NounTextField.text ?? ""
        storyPrompt.verb = VerbTextField.text ?? ""
        storyPrompt.adjective = AdjectiveTextField.text ?? ""
    }
    
    @objc
    func changeImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = self
        present(controller, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StoryPrompt" {
            guard let storyPromptViewController = segue.destination as? StoryPromptViewController else {
                return
            }
            storyPromptViewController.storyPrompt = storyPrompt
            storyPromptViewController.isNewStoryPrompt = true
        }
    }
}

extension AddStoryPromptViewController :  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddStoryPromptViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if(!results.isEmpty) {
            let result = results.first!
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let image = image as? UIImage else {
                        return
                    }
                    DispatchQueue.main.async {
                        self?.StoryPromptImageView.image = image
                    }
                }
            }
        }
    }
}
