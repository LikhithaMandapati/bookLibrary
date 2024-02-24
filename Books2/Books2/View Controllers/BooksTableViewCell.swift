//
//  BooksTableViewCell.swift
//  Books2
//
//  Created by Likhitha Mandapati on 1/13/24.
//

import UIKit

class BooksTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
