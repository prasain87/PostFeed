//
//  PostModel.swift
//  PostFeed
//
//  Created by Prateek Sujaina on 29/04/24.
//

import Foundation

struct PostModel: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
