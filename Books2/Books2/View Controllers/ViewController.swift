//
//  ViewController.swift
//  Books2
//
//  Created by Likhitha Mandapati on 1/13/24.
//

import UIKit

class ViewController: UIViewController {

    var book : [String: Any]?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = book?["title"] as? String
        self.authorLabel.text = book?["author"] as? String
        self.subLabel.text = book?["subjectName"] as? String
        
        if let dueDate = book?["dueDate"] as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: dueDate)
            self.dueDateLabel?.text = formattedDate
        }
    }
    
    // MARK: - Edit Book
    @IBAction func editDetails(_ sender: Any) {
        performSegue(withIdentifier: "seg_edit", sender: self)
    }
    
    // MARK: - Delete Book
    @IBAction func deleteButton(_ sender: Any) {
        BooksListCRUD.delete(oldTitle: titleLabel.text!)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seg_edit" {
            let edit_view = segue.destination as! UpdateViewController
            edit_view.book = book
            edit_view.isUpdating = true
        }
    }
}

