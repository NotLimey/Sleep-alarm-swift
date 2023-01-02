//
//  ContentView.swift
//  Sleep alarm
//
//  Created by Martin Myhre on 02/01/2023.
//

import SwiftUI
import AVFoundation
import Foundation

struct ContentView: View {
    // Declare a property to store the selected time
    @State private var selectedTime = Date()
    
    @State private var showAlert = false;
    
    @State private var riddle = "";
    @State private var riddleResult = 0.0;

    // Declare a property to store the timer
    @State private var timer: Timer?

    // Declare a property to store the sound player
    @State private var player: AVAudioPlayer?

    // Declare a property to store the entered date string
    @State private var enteredDateString = ""

    var body: some View {
        VStack {
            Text("Set an alarm")
                .font(.title)
            if timer == nil {
                ZStack {
                    Rectangle()
                        .frame(width: 160, height:50)
                        .foregroundColor(Color.blue)
                        .cornerRadius(10)
                    Text("Set new alarm")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(20)
                }
                .onTapGesture {
                    // Schedule the sound to play at the selected time
                    scheduleSound()
                }
                DatePicker("Select a time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .frame(width: 160)
            }
            if timer != nil {
                ZStack {
                    Rectangle()
                        .frame(width: 160, height:50)
                        .foregroundColor(Color.red)
                        .cornerRadius(10)
                    Text("Stop alarm")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(20)
                }
                .onTapGesture {
                    // Schedule the sound to play at the selected time
                    stopAlarm()
                }.alert(isPresented: $showAlert) {
                    Alert(title: Text("Incorrect password"), message: Text("If you write the wrong password again the sound will increase"), dismissButton: .default(Text("Dismiss")))
                }
                Text(riddle)
                TextField("Solve riddle to turn off. (answer_dd_mm)", text: $enteredDateString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 350)
            }
        }
        .padding()
    }

    func scheduleSound() {
        generate()
        
        // android_alarm_remix.mp3
        // Get the file URL of the built-in ringtone
        let filePath = Bundle.main.path(forResource: "android_alarm_remix", ofType: "mp3")
        if(filePath == nil) {
            return debugPrint("Something went wrong");
        }
        let soundURL = URL(fileURLWithPath: filePath!)

        // Create the sound player
        player = try! AVAudioPlayer(contentsOf: soundURL)
        player?.numberOfLoops = -1  // Set the number of loops to -1 to play the sound indefinitely

        // Calculate the time interval until the selected time
        let interval = selectedTime.timeIntervalSinceNow

        // Schedule the sound to play at the selected time
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            self.player?.play()
        }
    }
    
    func stopAlarm() {
        let date = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"

        let dateString = dateFormatter.string(from: date)
        
        let correctPwd = String(riddleResult) + "_" + dateString;
        debugPrint(correctPwd);
        
        if(correctPwd == enteredDateString) {
            timer = nil;
            player?.stop();
            
        }else {
            showAlert = true;
        }
    }
    func generate() {
        // Generate two random integers between 1 and 10
        let num1 = Int.random(in: 5...20)
        let num2 = Int.random(in: 5...15)

        // Calculate the result of the operation
        var result = Double(num1) * Double(num2);

        // Construct the riddle
        riddle = "What is \(num1) * \(num2)?"
        riddleResult = result;
      }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
