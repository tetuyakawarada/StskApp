//
//  Task.swift
//  StskApp
//
//  Created by tetsuya on 2022/11/16.
//

import Foundation

struct Task: Codable {
    let id: Int
    let title: String
    let body: String?
    let userId: Int
    let eventId: Int
    let subjectId: Int
    let stateId: Int
    let totalPage: Int
    let finishPage: Int
    let pageTime: Int
    let createdAt: String
    let updatedAt: String
    let userName: String
    let subjectName: String
    let totalTime: Int
    let progressTime: Int
    let degreeTime: Int

    
    enum CodingKeys:  String, CodingKey {
        case id //"id": 9,
        case title //"title": "きわめる国語",
        case body //"body": "1",
        case userId = "user_id" //: 1,
        case eventId = "event_id" //: 2,
        case subjectId = "subject_id" //: 2,
        case stateId = "state_id" //: 1,
        case totalPage = "total_page" //: 35,
        case finishPage = "finish_page" //: 0,
        case pageTime = "page_time" //: 10,
        case createdAt = "created_at" //: "2022-11-15T08:58:07.000000Z",
        case updatedAt = "updated_at" //: "2022-11-15T08:58:07.000000Z",
        case userName = "user_name" //: "Ritsu",
        case subjectName = "subject_name" //: "国語",
        case totalTime = "total_time" //: 350,
        case progressTime = "progress_time" //: 0,
        case degreeTime = "degree_time" //: 0
    }
}
