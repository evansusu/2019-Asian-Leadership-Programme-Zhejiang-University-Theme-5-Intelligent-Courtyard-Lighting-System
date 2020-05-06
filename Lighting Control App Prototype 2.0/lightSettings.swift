//
//  lightSettings.swift
//  Lighting Control App Prototype 1.1
//
//  Created by Cornelius Yap on 11/7/19.
//  Copyright © 2019 Cornelius Yap. All rights reserved.
//

import UIKit
import SwiftSocket


class lightSettings: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var lightSettingsLabel: UILabel!
    @IBOutlet weak var lightOnOffSwitch: UISwitch!
    @IBOutlet weak var lightBrightnessControl: UISlider!
    @IBOutlet weak var lightColourSettings: UIPickerView!
    
    @IBAction func backButton(_ sender: Any) {
        if client != nil {
            _ = sendRequest(string: "EXIT", using: client!)
            client!.close()
        }
    }
    
    // code for connecting app to rpi
    
    @IBAction func connectButton(_ sender: Any) {
        guard let client = client else { return }
        switch client.connect(timeout: 10) {
        case .success:
            print("Connected to host \(client.address)")
            _ = sendRequest(string: "UserID: \(dataClass.userID!)\n", using: client)
            _ = sendRequest(string: "Light: \(lightLabel!)\n", using: client)
//            print("Attempting to send image")
//            if let encodedImage = UserDefaults.standard.object(forKey: "encodedImage") as? String {
//                print("Sending Image")
//                _ = client.send(string: encodedImage)
//            }
        case .failure(let error):
            print(String(describing: error))
        }
    }
    
    private func sendRequest(string: String, using client: TCPClient) -> String? {
        print("Sending data ... ")
        
        switch client.send(string: string) {
        case .success:
            return readResponse(from: client)
        case .failure(let error):
            print(String(describing: error))
            return nil
        }
    }
    
    private func readResponse(from client: TCPClient) -> String? {
        guard let response = client.read(1024*10) else { return nil }
        
        return String(bytes: response, encoding: .utf8)
    }
    
    
    let host = "192.168.2.146"
    let port = 5560
    var client: TCPClient?
    
    //end of connection code
    
    @IBAction func unwindTolightSettings(_ unwindSegue: UIStoryboardSegue) {
    }
    
    
    @IBAction func liveStreamButton(_ sender: Any) {
        performSegue(withIdentifier: "webViewSegue", sender: self)
    }
    
    
    var lightLabel: String?
    let colourPickerData = ["White", "Pink", "Purple", "Blue", "Aqua", "Green", "Yellow", "Orange", "Red"]
    var selectedColour: String!
    var brightnessValue: Float!
    var switchStatus: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lightSettingsLabel.text = lightLabel
        self.lightColourSettings.delegate = self
        self.lightColourSettings.dataSource = self
        client = TCPClient(address: host, port: Int32(port))
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colourPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colourPickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColour = colourPickerData[row]
        print(selectedColour!)
        if client != nil {
            _ = sendRequest(string: "colour: \(selectedColour!)\n", using: client!)
        }
    }

    @IBAction func brightnessValueChanged(_ sender: Any) {
        brightnessValue = lightBrightnessControl.value
        print(brightnessValue!)
        if client != nil {
            _ = sendRequest(string: "brightnessvalue: \(brightnessValue!)\n", using: client!)
        }
    }
    
    @IBAction func onOffSwitch(_ sender: Any) {
        if lightOnOffSwitch.isOn {
            switchStatus = "on"
        }
        else {
            switchStatus = "off"
            print(switchStatus!)
        }
        if client != nil {
            _ = sendRequest(string: "State: \(switchStatus!)\n", using: client!)
        }
    }
}
