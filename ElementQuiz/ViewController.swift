//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Artem Morozov on 30.10.2023.
//

import UIKit

enum Mode {
    case flashCard
    case quiz
}

enum State {
    case question
    case answer
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    // Quiz-specific state
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    var mode = Mode.flashCard
    var state: State = .question
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var currentElementIndex = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    @IBAction func showAnswer(_ sender: UIButton) {
        
        state = .answer
        updateUI()
    }
    
    @IBAction func next(_ sender: UIButton) {
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
        }
        state = .question
        updateUI()
    }
    
    //  Updates the app's UI in flash card mode.
    func updateFlashCardUI(){
        let elementName = elementList[currentElementIndex]
        
        let image = UIImage(named: elementName)
        imageView.image = image
        switch state {
        case .answer:
            answerLabel.text = elementName
        case .question:
            answerLabel.text = "?"
            }
        }
    // Updates the app's UI in quiz mode.
    func updateQuizUI(){
        
    }
    
    // Updates the app's UI based on its mode and
    func updateUI(){
        switch mode {
        case .flashCard:
            updateFlashCardUI()
        case .quiz:
            updateQuizUI()
        }
    }
    
    func textFieldShouldReturn(_ textField:
       UITextField) -> Bool {
        // Get the text from the text field
        let textFieldContents = textField.text!
        
        // Determine whether the user answered correctly and update appropriate quiz
        // state
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
            answerIsCorrect = true
            correctAnswerCount += 1
        } else {
            answerIsCorrect = false
        }
        
        // The app should now display the answer to the user
        state = .answer
        
        updateUI()
        
        return true
    }

}

