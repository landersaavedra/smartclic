//
//  FirstViewController.swift
//  SmartPlugRC1
//
//  Created by RUDY FRITZ on 10/12/17.
//  Copyright © 2017 com.RudyLLantoy. All rights reserved.
//

import UIKit
import CocoaMQTT

class FirstViewController: UIViewController {
    
    var mqtt: CocoaMQTT?
    
    var device_state:Int = 0
    
    @IBOutlet var lblEstado: UILabel!
    
    @IBOutlet var lbl_device: UILabel!
    
    @IBOutlet var btn_sonoff: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mqttSetting()
        mqttConnect()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mqttSetting() {
        
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: server, port: UInt16(truncating: port))
        mqtt!.username = username
        mqtt!.password = password
        mqtt!.willMessage = CocoaMQTTWill(topic: TOPIC_POWER, message: "")
        mqtt!.keepAlive = 10
        mqtt!.delegate = self
    }
    
    func mqttConnect(){
        
        let conectado = mqtt!.connect()
        
        if conectado {
            lblEstado.text = "Conectado al servidor"
        }
    }
    
    
    func mqttON(){
        mqtt!.publish(TOPIC_POWER, withString: MESSAGE_POWER_ON, qos: .qos1)
    }
    
    func mqttOFF(){
        mqtt!.publish(TOPIC_POWER, withString: MESSAGE_POWER_OFF, qos: .qos1)        
    }
    
    
    @IBAction func btn_sonoff(_ sender: Any) {
        
        if device_state == 0 {
            mqttON()
        }
        else{
            mqttOFF()
        }
    }
    
    
    @IBAction func btn_on(_ sender: Any) {
        
        mqtt!.publish(TOPIC_POWER, withString: MESSAGE_POWER_ON, qos: .qos1)
    }
    
    
    
    @IBAction func btn_off(_ sender: Any) {
        
        mqtt!.publish(TOPIC_POWER, withString: MESSAGE_POWER_OFF, qos: .qos1)
        
    }
    
    
}



extension FirstViewController: CocoaMQTTDelegate {
    
    
    // Optional ssl CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        /// Validate the server certificate
        ///
        /// Some custom validation...
        ///
        /// if validatePassed {
        ///     completionHandler(true)
        /// } else {
        ///     completionHandler(false)
        /// }
        completionHandler(true)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck: \(ack)，rawValue: \(ack.rawValue)")
        mqtt.publish(TOPIC_POWER, withString: "", qos: .qos1)
        if ack == .accept {
            //  mqtt.subscribe(SUBSCRIBE_ALL, qos: .qos1)
            //  mqtt.subscribe(SUBSCRIBE_STATUS, qos: .qos1)
            mqtt.subscribe(SUBSCRIBE_POWER, qos: .qos2)
        }
        
        //mqtt.ping()
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(message.string ?? "")")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("didReceivedMessage: \(message.string ?? "") with id \(id)")
        
        
        
        if let msgString = message.string {
            
            if msgString == "OFF" {
                
                //btn_off.isEnabled = false
                //btn_on.isEnabled = true
                btn_sonoff.setImage(UIImage(named: "btn_sooff_off"), for: .normal)
                device_state = 0
                lbl_device.text = "Dispositivo Apagado"
                
               
                
            }
                
            else {
                
                //btn_on.isEnabled = false
                //btn_off.isEnabled = true
                btn_sonoff.setImage(UIImage(named: "btn_sooff_on"), for: .normal)
                device_state = 1
                lbl_device.text = "Dispositivo Encendido"
                
            }
            
            
        }
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic to \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic to \(topic)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("didPing")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        _console("didReceivePong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        _console("mqttDidDisconnect")
    }
    
    func _console(_ info: String) {
        print("Delegate: \(info)")
    }
    
   
}


