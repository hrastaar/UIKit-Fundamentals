//
//  StoryPromptViewController.swift
//  StoryPrompt
//
//  Created by Rastaar Haghi on 11/1/20.
//

import UIKit

class StoryPromptViewController: UIViewController {

    @IBOutlet weak var storyPromptTextView: UITextView!
    var storyPrompt: StoryPromptEntry?
    var isNewStoryPrompt = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        storyPromptTextView.text = storyPrompt?.description
        if isNewStoryPrompt {
            let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(SaveStoryPrompt))
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CancelStoryPrompt))
            navigationItem.rightBarButtonItem = saveButton
            navigationItem.leftBarButtonItem = cancelButton
        }
    }
    
    @objc func SaveStoryPrompt() {
        performSegue(withIdentifier: "SaveStoryPrompt", sender: nil)
    }
    
    @objc func CancelStoryPrompt() {
        NotificationCenter.default.post(name: .StoryPromptSaved, object: storyPrompt)
        performSegue(withIdentifier: "CancelStoryPrompt", sender: nil)
    }
    
}

extension Notification.Name {
    static let StoryPromptSaved = Notification.Name("StoryPromptSave")
}
