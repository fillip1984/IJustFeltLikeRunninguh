//
//  RunCreateView.swift
//  IJustFeltLikeRunninguh
//
//  Created by Phillip Williams on 9/15/23.
//

import Combine
import SwiftUI

enum MoodType: String, CaseIterable, Identifiable {
    case terrible, bad, okay, good, great
    var id: Self { self }
}

enum WeatherType: String, CaseIterable, Identifiable {
    case cold, wet, fair, hot
    var id: Self { self }
}

struct RunCreateView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State var run = Run()
    
    enum FocusedField {
        case date, distance, duration
    }

    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                DatePicker("Date", selection: $run.date, displayedComponents: .date)
                    .focused($focusedField, equals: .date)
            
                HStack {
                    Text("Distance")
                    TextField("3.15 (miles)", text: $run.distance)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .distance)
//                        .onReceive(Just(run.distance)) { newValue in
//                            let filtered = newValue.filter { "0123456789.".contains($0) }
//                            if filtered != newValue {
//                                $run.distance. = filtered
//                            }
//                        }
                        .multilineTextAlignment(.trailing)
                }
                    
                HStack {
                    Text("Duration")
                    TextField("35:16 (hh:mm:ss)", text: $run.duration)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .duration)
//                        .onReceive(Just(run.distance)) { newValue in
//                            let filtered = newValue.filter { "0123456789".contains($0) }
//                            if filtered != newValue {
//                                $run.distance = filtered
//                            }
//                        }
                        .multilineTextAlignment(.trailing)
                }
            
                Text("Pace")
                Text("Heart rate average")
            }
            
            // picker per internet searches, I like the Apple suggestion better
            Section(header: Text("Weather")) {
                Picker(selection: $run.weather, label: Text("Weather")) {
//                    Text("Unknown").tag(nil as WeatherType?)
                    Text("Cold").tag(WeatherType.cold as WeatherType?)
                    Text("Wet").tag(WeatherType.wet as WeatherType?)
                    Text("Fair").tag(WeatherType.fair as WeatherType?)
                    Text("Hot").tag(WeatherType.hot as WeatherType?)
                }
                .pickerStyle(.segmented)
            }
            
            // per apple's documentation
            Section(header: Text("Mood")) {
                Picker("Mood", selection: $run.mood) {
//                    Text("Unknown").tag(nil as MoodType?)
                    Text("Terrible").tag(MoodType.terrible as MoodType?)
                    Text("Bad").tag(MoodType.bad as MoodType?)
                    Text("Okay").tag(MoodType.okay as MoodType?)
                    Text("Good").tag(MoodType.good as MoodType?)
                    Text("Great").tag(MoodType.great as MoodType?)
                }
                .pickerStyle(.segmented)
            }
            
//            Section {
//                Toggle(isOn: $isPrivate) {
//                    Text("Keep private")
//                }
//            }
            
//                Button(action: { print("saving") }) {
//                    HStack {
//                        Spacer()
//                        Text("Save").font(.title).foregroundColor(.white)
//                        Spacer()
//                    }
//                }
//                .frame(width: .infinity)
//                .padding()
//                .background(Color.black)
//                .cornerRadius(5)
        }
        Button {
            context.insert(run)
            dismiss()
        } label: {
            Text("Add")
                .padding()
                .cornerRadius(40)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/)
                .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
                .background(Color.pink)
                .foregroundColor(.white)
        }.toolbar {
            ToolbarItem(placement: .keyboard) {
                Spacer()
            }
            ToolbarItem(placement: .keyboard) {
                Button {
                    focusedField = nil
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
    }
}

#Preview {
    RunCreateView()
}
