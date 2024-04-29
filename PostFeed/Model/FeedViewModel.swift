//
//  FeedViewModel.swift
//  PostFeed
//
//  Created by Prateek Sujaina on 29/04/24.
//

import Foundation
import Combine

final class FeedViewModel {
    
    private(set) var posts: [PostModel] = []
    
    private var offset: Int = 0
    private var pageSize: Int = 100
    private(set) var hasMoreData: Bool = true
    
    @MainActor
    func loadPosts() async throws {
        let posts = try await fetchPage(offset: offset, pageSize: pageSize)
        self.posts = posts
        offset += posts.count
        // if count of posts received is equal to requested page-size, there could be more feeds available.
        hasMoreData = posts.count == pageSize
    }
    
    @MainActor
    func loadNextPage() async throws {
        let posts = try await fetchPage(offset: offset, pageSize: pageSize)
        self.posts.append(contentsOf: posts)
        offset += posts.count
        hasMoreData = posts.count == pageSize
    }
    
    @MainActor
    func fetchPage(offset: Int, pageSize: Int) async throws -> [PostModel] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts?offset=\(offset)&size=\(pageSize)") else {
            throw APIError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([PostModel].self, from: data)
    }
    
    
}

enum APIError: Error {
    case invalidURL
}
