//
//  RunCreateView.swift
//  IJustFeltLikeRunninguh
//
//  Created by Phillip Williams on 9/15/23.
//

import Combine
import SwiftUI

// enum MoodType: String, CaseIterable, Identifiable {
//    case terrible, bad, okay, good, great
//    var id: Self { self }
// }
//
// enum WeatherType: String, CaseIterable, Identifiable {
//    case cold, wet, fair, hot
//    var id: Self { self }
// }

enum FormField: Hashable {
    case distance, time, averagePace, averageHeartRate
}

let WeatherType = ["Cold", "Wet", "Fair", "Hot"]
let MoodType = ["Terrible", "Bad", "Okay", "Good", "Great"]

struct RunDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @Bindable var run = Run()
    var formMode: String

    var isValid: Bool {
        if !run.distance.isEmpty
            && !run.time.isEmpty
            && !run.averagePace.isEmpty
        {
            return true
        }

        return false
    }

    enum FocusedField {
        case date, distance, time, averagePace, averageHeartRate
    }

    @FocusState var focusedField: FormField?

    var body: some View {
        Form {
            Section {
                DatePicker("Date", selection: $run.date, displayedComponents: .date)

                HStack {
                    Text("Distance")
                    TextField("3.15 (miles)", text: $run.distance)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .distance)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Time")
                    TextField("38:16 (hh:mm:ss)", text: $run.time)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .time)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Avg. Pace")
                    TextField("12:14 (mm:ss)", text: $run.averagePace)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .averagePace)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Avg. Heart Rate")
                    TextField("133 (BPM)", text: $run.averageHeartRate)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .averageHeartRate)
                        .multilineTextAlignment(.trailing)
                }
            } header: {
                Text("Run Details")
            }

            Section {
                Picker("Weather", selection: $run.weather) {
                    ForEach(WeatherType, id: \.self) { weatherOption in
                        Text(weatherOption)
                    }
                }.pickerStyle(.segmented)
            } header: {
                Text("Weather")
            }

            Section {
                Picker("Mood", selection: $run.mood) {
                    ForEach(MoodType, id: \.self) { moodOption in
                        Text(moodOption)
                    }
                }.pickerStyle(.segmented)
            } header: {
                Text("Mood")
            }

            // Shouldn't this be a toolbar item on the navigation stack?
            // See how I made the button full width: https://stackoverflow.com/questions/56471004/making-button-span-across-vstack
            VStack {
                if formMode == "create" {
                    Button {
                        context.insert(run)
                        dismiss()
                    } label: {
                        Text("Add")
                            .frame(maxWidth: .infinity)
                            .font(.title)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isValid)
                } else {
                    Button {
                        dismiss()
                    } label: {
                        Text("Update")
                            .frame(maxWidth: .infinity)
                            .font(.title)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isValid)
                }
            }

        }.toolbar {
            // not working right now, maybe a bug in iOS 17 or my beta version of xcode/ios?
            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    focusedField = nextField(currentField: focusedField)
                } label: {
                    Image(systemName: "chevron.down")
                }

                Button {
                    focusedField = previousField(currentField: focusedField)
                } label: {
                    Image(systemName: "chevron.up")
                }

                // fixes bug where arrows appear correctly but then after dismissing keyboard and then bringing it back the 2nd item is shifted near other group
                Spacer()
            }

            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    focusedField = nil
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
    }
}

func nextField(currentField: FormField?) -> FormField {
    if currentField == nil {
        return .distance
    }

    switch currentField {
        case .distance: return .time
        case .time: return .averagePace
        case .averagePace: return .averageHeartRate
        case .averageHeartRate: return .distance
        default: return .distance
    }
}

func previousField(currentField: FormField?) -> FormField {
    if currentField == nil {
        return .averageHeartRate
    }

    switch currentField {
        case .distance: return .averageHeartRate
        case .time: return .distance
        case .averagePace: return .time
        case .averageHeartRate: return .averagePace
        default: return .averageHeartRate
    }
}

// #Preview {
//    RunCreateView(formMode: "create")
// }
