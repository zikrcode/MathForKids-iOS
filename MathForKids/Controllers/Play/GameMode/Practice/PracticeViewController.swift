//
//  PracticeViewController.swift
//  MathForKids
//
//  Created by Zokirjon Mamadjonov on 18/06/2023.
//

import UIKit

class PracticeViewController: UIViewController {
    
    @IBOutlet private weak var currentQuestionNumber: UILabel!
    
    @IBOutlet private weak var numberOfCorrectQuestion: UILabel!
    @IBOutlet private weak var numberOfWrongQuestion: UILabel!
    
    @IBOutlet private weak var a: UILabel!
    @IBOutlet private weak var operation: UILabel!
    @IBOutlet private weak var b: UILabel!
    
    @IBOutlet private weak var optionA: UIButton!
    @IBOutlet private weak var optionB: UIButton!
    @IBOutlet private weak var optionC: UIButton!
    @IBOutlet private weak var optionD: UIButton!
    
    private var min = AppConstants.minValue
    private var max = AppConstants.maxValue
    private let operationString: String
    private var questions: [Question] = []
    private var questionNumber = 0
    private var ans = 0
    private var showNextQuestion = true
    private var correctQuestions = ""
    private var correctQuestionsCount = 0
    private var wrongQuestions = ""
    private var wrongQuestionsCount = 0
    
    init(operationString: String) {
        self.operationString = operationString
        super.init(nibName: "PracticeViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        if let newMinValue = getIntValueFrom(key: AppConstants.keyMinValue) {
            min = newMinValue
        }
        if let newMaxValue = getIntValueFrom(key: AppConstants.keyMaxValue) {
            max = newMaxValue
        }
        
        for _ in 1...10 {
            questions.append(Question(operationString, min, max))
        }
        
        operation.text = operationString
        
        setupQuestion()
    }
        
    private func setupQuestion() {
        currentQuestionNumber.text = "\(questionNumber + 1)/10"
        
        a.text = questions[questionNumber].getA()
        b.text = questions[questionNumber].getB()
        ans =  questions[questionNumber].getC()
        
        let random = questions[questionNumber].getRandom()
        
        optionA.setTitle(String(random[0]), for: .normal)
        optionB.setTitle(String(random[1]), for: .normal)
        optionC.setTitle(String(random[2]), for: .normal)
        optionD.setTitle(String(random[3]), for: .normal)
        
        switch Int.random(in: 1...4) {
        case 1:
            optionA.setTitle(String(ans), for: .normal)
        case 2:
            optionB.setTitle(String(ans), for: .normal)
        case 3:
            optionC.setTitle(String(ans), for: .normal)
        case 4:
            optionD.setTitle(String(ans), for: .normal)
        default: break
        }
    }
    
    @IBAction private func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func optionAClicked(_ sender: UIButton) {
        if sender.titleLabel?.text == String(ans) {
            correctOptionSelected(button: sender)
        } else {
            wrongOptionSelected(button: sender)
        }
    }
    
    @IBAction private func optionBClicked(_ sender: UIButton) {
        if sender.titleLabel?.text == String(ans) {
            correctOptionSelected(button: sender)
        } else {
            wrongOptionSelected(button: sender)
        }
    }
    
    @IBAction private func optionCClicked(_ sender: UIButton) {
        if sender.titleLabel?.text == String(ans) {
            correctOptionSelected(button: sender)
        } else {
            wrongOptionSelected(button: sender)
        }
    }
    
    @IBAction private func optionDClicked(_ sender: UIButton) {
        if sender.titleLabel?.text == String(ans) {
            correctOptionSelected(button: sender)
        } else {
            wrongOptionSelected(button: sender)
        }
    }
    
    private func getIntValueFrom(key: String) -> Int? {
        UserDefaults.standard.object(forKey: key) as? Int
    }
    
    private func correctOptionSelected(button: UIButton) {
        let currentQuestion = questions[questionNumber]

        if showNextQuestion {
            correctQuestions.append(
                "\(currentQuestion.getA())" +
                "\(operationString)" +
                "\(currentQuestion.getB())" +
                "\(AppConstants.equal)" +
                "\(String(describing: button.titleLabel))"
            )
            correctQuestionsCount += 1
        }
        
        questionNumber += 1
        showNextQuestion = true
        
        if questionNumber == 10 {
            // TODO: needs to be modified after Reulult page
            self.navigationController?.popViewController(animated: true)
        } else {
            numberOfCorrectQuestion.text = String(correctQuestionsCount)
            setupQuestion()
        }
    }
    
    private func wrongOptionSelected(button: UIButton) {
        showToast(message: "Wrong answer, Please try again!")
        
        if showNextQuestion {
            let currentQuestion = questions[questionNumber]
            wrongQuestions.append(
                "\(currentQuestion.getA())" +
                "\(operationString)" +
                "\(currentQuestion.getB())" +
                "\(AppConstants.equal)" +
                "\(String(describing: button.titleLabel))"
            )
            wrongQuestionsCount += 1
            showNextQuestion = false
            
            numberOfWrongQuestion.text = String(wrongQuestionsCount)
        }
    }
    
    private func showToast(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}
