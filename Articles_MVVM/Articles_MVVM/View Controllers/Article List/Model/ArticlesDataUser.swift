//
//	ArticlesDataUser.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ArticlesDataUser : Codable {

	let about : String?
	let avatar : String?
	let blogId : String?
	let city : String?
	let createdAt : String?
	let designation : String?
	let id : String?
	let lastname : String?
	let name : String?


	enum CodingKeys: String, CodingKey {
		case about = "about"
		case avatar = "avatar"
		case blogId = "blogId"
		case city = "city"
		case createdAt = "createdAt"
		case designation = "designation"
		case id = "id"
		case lastname = "lastname"
		case name = "name"
	}
    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		about = try values.decodeIfPresent(String.self, forKey: .about)
		avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
		blogId = try values.decodeIfPresent(String.self, forKey: .blogId)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		designation = try values.decodeIfPresent(String.self, forKey: .designation)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		lastname = try values.decodeIfPresent(String.self, forKey: .lastname)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}
}
