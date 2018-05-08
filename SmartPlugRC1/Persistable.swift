//
//  Persistable.swift
//  SmartPlugRC1
//
//  Created by Avances on 13/03/18.
//  Copyright © 2018 com.RudyLLantoy. All rights reserved.
//

import Foundation

protocol Persistable{
    var ud: UserDefaults {get}
    var persistKey : String {get}
    func persist()
    func unpersist()
}
