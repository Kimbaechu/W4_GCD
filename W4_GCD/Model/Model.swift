//
//  Model.swift
//  W4_GCD
//
//  Created by Beomcheol Kwon on 2021/01/21.
//

import Foundation

//https://www.mockaroo.com 에서 api 생성 후 사용
let MEMBER_LIST_URL = "https://my.api.mockaroo.com/member.json?key=7bc27ed0"

// MARK: - Member
struct Member: Codable {
    let id: Int
    let name: String
    let avatar: String
    let job: String
    let age: Int
}

typealias Members = [Member]
