//
//	ArticlesDataMedia.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ArticlesDataMedia : Codable {

	let blogId : String?
	let createdAt : String?
	let id : String?
	let image : String?
	let title : String?
	let url : String?


	enum CodingKeys: String, CodingKey {
		case blogId = "blogId"
		case createdAt = "createdAt"
		case id = "id"
		case image = "image"
		case title = "title"
		case url = "url"
	}
    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		blogId = try values.decodeIfPresent(String.self, forKey: .blogId)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}


}
