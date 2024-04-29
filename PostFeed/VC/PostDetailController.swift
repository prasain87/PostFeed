//
//  PostDetailController.swift
//  PostFeed
//
//  Created by Prateek Sujaina on 29/04/24.
//

import UIKit

final class PostDetailController: UIViewController {
    @IBOutlet private var labelTitle: UILabel!
    @IBOutlet private var labelId: UILabel!
    @IBOutlet private var labelBody: UILabel!
    
    var model: PostModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        labelTitle.text = model.title
        labelId.text = "\(model.userId)"
        labelBody.text = model.body
    }
}
