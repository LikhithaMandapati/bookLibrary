//
//  ListTableViewController.swift
//  Books2
//
//  Created by Likhitha Mandapati on 1/13/24.
//

import UIKit

class ListTableViewController: UITableViewController {

    var books = [[String: Any]]()
    var selectedBook : [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BooksListCRUD.deleteAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let allBooks = BooksListCRUD.readAll()
        if !allBooks.isEmpty {
            books = allBooks
            sorting()
            tableView.reloadData()
        }
        else {
            books.removeAll()
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBook = books[indexPath.row]
        self.performSegue(withIdentifier: "viewDetails", sender: self)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BooksCell", for: indexPath) as! BooksTableViewCell
        
        let bookEntry = books[indexPath.row]
        cell.titleLabel?.text = bookEntry["title"] as? String
        
        if let dueDate = bookEntry["dueDate"] as? Date {
            let df = formatter()
            let formattedDate = df.string(from: dueDate)
            cell.dueDateLabel?.text = formattedDate
        }
        return cell
    }
    
    // MARK: - Add Book
    @IBAction func addBook(_ sender: Any) {
        performSegue(withIdentifier: "seg_add", sender: self)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewDetails" {
            let details_view = segue.destination as! ViewController
            details_view.book = selectedBook
        }
        else if segue.identifier == "seg_add" {
            _ = segue.destination as! UpdateViewController
        }
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
    
    func sorting() {
        books.sort { (entry1, entry2) -> Bool in
            if let dueDate1 = entry1["dueDate"] as? Date, let dueDate2 = entry2["dueDate"] as? Date {
                return dueDate1 < dueDate2
            }
            return false
        }
    }
}
