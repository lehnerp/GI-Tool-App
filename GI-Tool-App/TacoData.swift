//
//  TacoData.swift
//  GI-Tool-App
//
//  Created by Patrik Lehner on 01.02.2023.
//

import Foundation

struct Character: Codable {
    var name: String
    var title: String
    var vision: String
    var weapon: String
    var nation: String
    var affiliation: String
    var rarity: Int
    var constellation: String
    var birthday: String
    var description: String
    var skillTalents: [SkillTalent]
    var passiveTalents: [PassiveTalent]
    var constellations: [Constellation]
    var vision_key: String
    var weapon_type: String
}

struct SkillTalent: Codable {
    var name: String
    var unlock: String
    var description: String
    var type: String
}

struct PassiveTalent: Codable {
    var name: String
    var unlock: String
    var description: String
    var level: Int
}

struct Constellation: Codable {
    var name: String
    var unlock: String
    var description: String
    var level: Int
}

