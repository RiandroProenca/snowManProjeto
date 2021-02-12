//
//  TableViewController.swift
//  snowManProjeto
//
//  Created by Riandro Proença on 11/02/21.
//
import Firebase
import UIKit

    class FaqListTableViewController: UITableViewController, AddFaqDelegate {
    
    private var questions: [Faq] = []
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuestions()
    }
    
    private func fetchQuestions() {
        db.collection("questions").getDocuments() { (querySnapshot, err) in
            guard err == nil, let documents = querySnapshot?.documents else { return }
            for document in documents {
                if let question = document.data()["question"] as? String,
                   let answer = document.data()["answer"] as? String {
                    let faq = Faq(question: question, answer: answer)
                    self.questions.append(faq)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let question = questions[indexPath.row]
        cell.textLabel?.text = question.question
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(showDetails(_:)))
        cell.addGestureRecognizer(longPress)
        return cell
    }
    
    @objc
    private func showDetails(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            guard
                let cell = gesture.view as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) else {
                return
            }
            
            let question = questions[indexPath.row]
            let alert = UIAlertController(title: question.question,
                                          message: "Resposta: \(question.answer)",
                                          preferredStyle: .alert)
            let buttonCancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(buttonCancel)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func add(_ faq: Faq) {
        questions.append(faq)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? FaqViewController {
            viewController.delegate = self
        }
    }
}
