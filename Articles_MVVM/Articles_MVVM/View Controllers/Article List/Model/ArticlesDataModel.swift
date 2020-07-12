//
//	ArticlesDataModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ArticlesDataModel : Codable {

	let comments : Int?
	let content : String?
	let createdAt : String?
	let id : String?
	let likes : Int?
	let media : [ArticlesDataMedia]?
	let user : [ArticlesDataUser]?


	enum CodingKeys: String, CodingKey {
		case comments = "comments"
		case content = "content"
		case createdAt = "createdAt"
		case id = "id"
		case likes = "likes"
		case media = "media"
		case user = "user"
	}
    
    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		comments = try values.decodeIfPresent(Int.self, forKey: .comments)
		content = try values.decodeIfPresent(String.self, forKey: .content)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		likes = try values.decodeIfPresent(Int.self, forKey: .likes)
		media = try values.decodeIfPresent([ArticlesDataMedia].self, forKey: .media)
		user = try values.decodeIfPresent([ArticlesDataUser].self, forKey: .user)
	}


}
