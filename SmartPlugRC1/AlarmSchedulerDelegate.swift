//
//  AlarmSchedulerDelegate.swift
//  SmartPlugRC1
//
//  Created by Lander Saavedra on 12/03/18.
//  Copyright © 2018 com.RudyLLantoy. All rights reserved.
//

import Foundation
import UIKit

protocol AlarmSchedulerDelegate {
    func setNotificationWithDate(_ date: Date, onWeekdaysForNotify:[Int], snoozeEnabled: Bool, onSnooze:Bool, soundName: String, index: Int)
    //helper
    func setNotificationForSnooze(snoozeMinute: Int, soundName: String, index: Int)
    func setupNotificationSettings() -> UIUserNotificationSettings
    func reSchedule()
    func checkNotification()
}

