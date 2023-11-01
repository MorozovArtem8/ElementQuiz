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
    
    var mode = Mode.flashCard {
        didSet{
            updateUI()
        }
    }
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
    @IBAction func switchModes(_ sender: Any) {
        
        if modeSelector.selectedSegmentIndex == 0 {
            mode = .flashCard
        }else{
            mode = .quiz
        }
        updateUI()
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
    func updateFlashCardUI(elementName: String){
        textField.isHidden = true // скрываем текстовое поле
        textField.resignFirstResponder() // скрываем клавиатуру
        
        switch state {
        case .answer:
            answerLabel.text = elementName
        case .question:
            answerLabel.text = "?"
            }
        }
    // Updates the app's UI in quiz mode.
    func updateQuizUI(elementName: String){
        textField.isHidden = false
        
        switch state{
        case .question:
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.resignFirstResponder()
        }
        
        switch state{
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct!"
            }else{
                answerLabel.text = "❌"
            }
        }
        
        
    }
    
    // Updates the app's UI based on its mode and
    func updateUI(){
        let elementName = elementList[currentElementIndex]
        let image = UIImage(named: elementName)
        imageView.image = image
        
        switch mode {
        case .flashCard:
            updateFlashCardUI(elementName: elementName)
        case .quiz:
            updateQuizUI(elementName: elementName)
        }
    }
    //Runs after the user hits the Return key on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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

