//
//  ViewController.swift
//  snowManProjeto
//
//  Created by Riandro Proença on 11/02/21.
//

import UIKit
import Firebase

protocol AddFaqDelegate: AnyObject {
    func add(_ faq: Faq)       
}
    class FaqViewController: UIViewController {
    
    // MARK:- Atributos
    
    weak var delegate: AddFaqDelegate?
    private let database = Firestore.firestore()
    
    // MARK:- IBActions
    
    @IBOutlet private weak var questionTextField: UITextField?
    @IBOutlet private weak var answerTextField: UITextField?
    
    // MARK:- IBActions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBord))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction private func add() {
        guard
            let question = questionTextField?.text,
            let answer = answerTextField?.text else {
            return
        }
        addQuestion(question: question, answer: answer)
        
        let faq = Faq(question: question, answer: answer)
        delegate?.add(faq)
        navigationController?.popViewController(animated: true)
    }
    
    private func addQuestion(question: String, answer: String) {
        database.collection("questions").addDocument(data: [
            "question": question,
            "answer": answer,
        ]) { err in
        if let err = err {
            print("Error adding document: \(err)") }
        }
    }
        //MARK:- Dismisskeybird
        
    @objc private func dismissKeyBord() {
        view.endEditing(true)
    }
}


