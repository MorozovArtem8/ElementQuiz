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
    case score
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    // Quiz-specific state
    var answerIsCorrect = false
    var correctAnswerCount = 0
    
    var mode = Mode.flashCard {
        didSet{
            switch mode{
            case .flashCard:
                setupFlashCards()
            case .quiz:
                setupdQuiz()
                
            }
            updateUI()
        }
    }
    var state: State = .question
    let fixedElementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var elementList: [String] = []
    var currentElementIndex = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var showAnswerButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mode = .flashCard
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
            if mode == .quiz {
                state = .score
                updateUI()
                return
            }
        }
        state = .question
        updateUI()
    }
    
    //  Updates the app's UI in flash card mode.
    func updateFlashCardUI(elementName: String){
        //Buttons
        showAnswerButton.isHidden = false
        nextButton.isEnabled = true
        nextButton.setTitle("Next Element", for: .normal)
        
        modeSelector.selectedSegmentIndex = 0
        //Text Field
        textField.isHidden = true // скрываем текстовое поле
        textField.resignFirstResponder() // скрываем клавиатуру
        
        switch state {
        case .answer:
            answerLabel.text = elementName
        case .question:
            answerLabel.text = "?"
        case .score:
            return
            }
        }
    // Updates the app's UI in quiz mode.
    func updateQuizUI(elementName: String){
        //Buttons
        showAnswerButton.isHidden = true
        if currentElementIndex == elementList.count - 1 {
            nextButton.setTitle("Show score", for: .normal)
        }else{
            nextButton.setTitle("Next Question", for: .normal)
        }
        switch state {
        case .question:
            nextButton.isEnabled = false
        case .answer:
            nextButton.isEnabled = true
        case .score:
            nextButton.isEnabled = false
        }
        
        modeSelector.selectedSegmentIndex = 1
        //TextField
        textField.isHidden = false
        switch state{
        case .question:
            textField.isEnabled = true
            textField.text = ""
            textField.becomeFirstResponder()
        case .answer:
            textField.isEnabled = false
            textField.resignFirstResponder()
        case .score:
            textField.isHidden = true
            textField.resignFirstResponder()
        }
    
        //Answer label
        switch state{
        case .question:
            answerLabel.text = ""
        case .answer:
            if answerIsCorrect {
                answerLabel.text = "Correct!"
            }else{
                answerLabel.text = "❌\nCorrect Answer: " + elementName
            }
        case .score:
            answerLabel.text = ""
            //print("У вас \(correctAnswerCount) очков из \(elementList.count)")
        }
        if state == .score {
            displayScoreAlert()
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
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFieldContents = textField.text!
        if textFieldContents.lowercased() == elementList[currentElementIndex].lowercased() {
            answerIsCorrect = true
            correctAnswerCount += 1
        } else {
            answerIsCorrect = false
        }
        state = .answer
        updateUI()
        return true
    }
    
    func displayScoreAlert() {
        let alert = UIAlertController(title: "Quiz Score", message: "Твои очки \(correctAnswerCount) из \(elementList.count)", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: scoreAlertDismissed(_:))
        
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func scoreAlertDismissed(_ action: UIAlertAction) {
        mode = .flashCard
    }
    
    func setupFlashCards(){
        elementList = fixedElementList
        state = .question
        currentElementIndex = 0
    }
    func setupdQuiz(){
        state = .question
        currentElementIndex = 0
        answerIsCorrect = false
        correctAnswerCount = 0
        elementList = fixedElementList.shuffled()
    }

}

