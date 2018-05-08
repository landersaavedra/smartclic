//
//  Topics.swift
//  SmartPlugRC1
//
//  Created by RUDY FRITZ on 11/12/17.
//  Copyright © 2017 com.RudyLLantoy. All rights reserved.
//

import Foundation

let TOPIC_POWER:String = "cmnd/sonoff/POWER"
let TOPIC_STATUS:String = "cmnd/sonoff/STATUS"

// Para obtener estados
let SUBSCRIBE_POWER:String = "stat/sonoff/POWER"
let SUBSCRIBE_STATUS:String = "stat/sonoff/STATUS"


let SUBSCRIBE_STATE:String = "+/sonoff/STATE"
let SUBSCRIBE_ALL:String = "+/sonoff/#"

let MESSAGE_POWER_ON:String = "ON"
let MESSAGE_POWER_OFF:String = "OFF"

let MESSAGE_STATUS_POWER:String = "11"
let MESSAGE_STATUS_POWER_ALL:String = "0"
