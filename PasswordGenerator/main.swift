//
//  main.swift
//  PasswordGenerator
//
//  Created by Krzysztof Grabowski on 30.10.2016.
//  Copyright © 2016 Indywidualni.org.
//

import Foundation
import AppKit

let openSslPath = "/usr/bin/openssl"
let passwordLength = "13"

func shell(launchPath: String, arguments: [String] = []) -> (String? , Int32) {
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.launch()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: String.Encoding.utf8)
    task.waitUntilExit()
    return (output, task.terminationStatus)
}

func copyToPasteboard(text: String) {
    let pasteboard = NSPasteboard.general()
    pasteboard.clearContents()
    pasteboard.setString(text, forType: NSPasteboardTypeString)
}

var commandOutput = shell(launchPath:openSslPath, arguments:["rand", "-base64", passwordLength])
var generatedPassword = commandOutput.0!

if (commandOutput.1 == 0) {
    // drop = and new line character at the end of the result
    let resultPassword = String(generatedPassword.characters.dropLast(3))
    copyToPasteboard(text:resultPassword)
    print(resultPassword)
} else {
    print("Status " + String(commandOutput.1))
    print("Password wasn't generated")
}
