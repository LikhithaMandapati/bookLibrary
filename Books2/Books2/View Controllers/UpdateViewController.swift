//
//  UpdateViewController.swift
//  Books2
//
//  Created by Likhitha Mandapati on 1/16/24.
//

import UIKit

class UpdateViewController: UIViewController {

    var book : [String: Any]?
    var isUpdating = false
    
    @IBOutlet var titleTF: UITextField!
    @IBOutlet var authorTF: UITextField!
    @IBOutlet var subNameTF: UITextField!
    @IBOutlet var dueDateTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isUpdating {
            oldTextFieldDetails()
        }
    }
    
    // MARK: - Add Book
    func addBookData() {
        BooksListCRUD.create(newTitle: titleTF.text!, newAuthor: authorTF.text!, newSubName: subNameTF.text!, newDueDate: createDate(from: dueDateTF.text!) ?? Date())
    }
    
    // MARK: - Edit Book
    func oldTextFieldDetails()  {
        titleTF.text = book!["title"] as? String
        authorTF.text = book!["author"] as? String
        subNameTF.text = book!["subjectName"] as? String

        let df = formatter()
        dueDateTF.text = df.string(from: (book!["dueDate"] as? Date ?? Date()))
    }
    
    func editBookData() {
        guard let book = book,
              let oldTitle = book["title"] as? String,
              let oldAuthor = book["author"] as? String,
              let oldSubName = book["subjectName"] as? String,
              let oldDueDate = book["dueDate"] as? Date else {return}
        
        let df = formatter()
        if titleTF.text != oldTitle || authorTF.text != oldAuthor || subNameTF.text != oldSubName || dueDateTF.text != df.string(from: oldDueDate) {
            BooksListCRUD.update(oldTitle: oldTitle, newTitle: titleTF.text!, newAuthor: authorTF.text!, newSubName: subNameTF.text!, newDueDate: createDate(from: dueDateTF.text!) ?? Date())
        }
    }
 
    // MARK: - Save
    @IBAction func saveButton(_ sender: Any) {
        if isUpdating {
            editBookData()
        }
        else {
            addBookData()
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Other Functions
    func createDate(from dateString: String) -> Date? {
        let df = formatter()
        return df.date(from: dateString)
    }
    
    func formatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
}
