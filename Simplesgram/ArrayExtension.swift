//
//  ArrayExtension.swift
//  Simplesgram
//
//  Created by yan ShengMing on 15/10/8.
//  Copyright © 2015年 mobile_course_team_1. All rights reserved.
//

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    mutating func removeObject(object: Self.Generator.Element) {
        if let found = self.indexOf(object) {
            self.removeAtIndex(found)
        }
    }
}