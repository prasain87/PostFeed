//
//  FeetViewController.swift
//  PostFeed
//
//  Created by Prateek Sujaina on 29/04/24.
//

import UIKit

final class FeetViewController: UITableViewController {
    
    let viewModel: FeedViewModel = FeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Feeds"
        
        loadData()
    }
    
    func loadData() {
        Task {
            do {
                try await viewModel.loadPosts()
            } catch {
                let alert = UIAlertController(title: "Failed to load posts!", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                    self?.loadData()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(alert, animated: true)
            }
            self.tableView.reloadData()
        }
    }
}

extension FeetViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTVC") as? PostTVC else {
            return PostTVC(style: .default, reuseIdentifier: "PostTVC")
        }
        
        cell.configure(model: viewModel.posts[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.posts.count-1 && viewModel.hasMoreData {
            tableView.showLoadingFooter()
            Task {
                do {
                    try await viewModel.loadNextPage()
                    tableView.reloadData()
                } catch {
                    let alert = UIAlertController(title: "Failed to load more posts!", message: error.localizedDescription, preferredStyle: .actionSheet)
                    show(alert, sender: nil)
                }
                tableView.hideLoadingFooter()
            }
        }
    }
}

extension FeetViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostDetailController" {
            let postDetail = segue.destination as! PostDetailController
            postDetail.model = (sender as! PostTVC).model
        }
    }
}

extension UITableView {
    func showLoadingFooter() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(44))
        self.tableFooterView = spinner
        self.tableFooterView?.isHidden = false
    }
    func hideLoadingFooter() {
        self.tableFooterView?.isHidden = true
        self.tableFooterView = nil
    }
}
