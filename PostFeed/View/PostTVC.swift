//
//  PostTVC.swift
//  PostFeed
//
//  Created by Prateek Sujaina on 29/04/24.
//

import UIKit

final class PostTVC: UITableViewCell {
    @IBOutlet private var labelTitle: UILabel!
    @IBOutlet private var labelId: UILabel!
    @IBOutlet private var labelBody: UILabel!
    
    private(set) var model: PostModel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    func configure(model: PostModel) {
        self.model = model
        
        labelTitle.text = model.title
        labelId.text = "\(model.userId)"
        labelBody.text = model.body
    }
}
