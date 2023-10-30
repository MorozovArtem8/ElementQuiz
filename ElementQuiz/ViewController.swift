//
//  ViewController.swift
//  ElementQuiz
//
//  Created by Artem Morozov on 30.10.2023.
//

import UIKit

class ViewController: UIViewController {
    let elementList = ["Carbon", "Gold", "Chlorine", "Sodium"]
    var currentElementIndex = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateElement()
        // Do any additional setup after loading the view.
    }
    @IBAction func showAnswer(_ sender: UIButton) {
        answerLabel.text = elementList[currentElementIndex]
    }
    
    @IBAction func next(_ sender: UIButton) {
        currentElementIndex += 1
        if currentElementIndex >= elementList.count {
            currentElementIndex = 0
        }
        updateElement()
    }
    
    func updateElement(){
        let elementName = elementList[currentElementIndex]
        
        let image = UIImage(named: elementName)
        imageView.image = image
        answerLabel.text = "?"
    }


}

