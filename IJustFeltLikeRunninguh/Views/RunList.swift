//
//  RunList.swift
//  IJustFeltLikeRunninguh
//
//  Created by Phillip Williams on 9/15/23.
//

import SwiftData
import SwiftUI

struct RunList: View {
    @Environment(\.modelContext) var context

    @State var showCreateRunSheet = false
    @State var runToEdit: Run?

    @Query var runs: [Run]

    @State private var distance = "All"
    let format = ["All", "5k", "10k", "10 miler", "Mini", "Marathon"]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    Picker("Distance", selection: $distance) {
                        ForEach(format, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    if runs.isEmpty {
                        Spacer()
                        if $distance.wrappedValue == "All" {
                            Text("Get out running'uh!")
                                .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
                                .bold()
                        } else {
                            Text("No runs tracked for this format")
                                .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
                                .bold()
                        }

                        Spacer()
                    } else {
                        List(runs) { run in
                            Button {
                                runToEdit = run
                            } label: {
                                HStack {
                                    Image(systemName: "figure.run")
                                        .font(.title)

                                    VStack(alignment: .leading) {
                                        Text("\(run.distance) miles")
                                            .font(.headline)

                                        HStack {
                                            Image(systemName: "calendar")
                                            Text("\(run.date, format: Date.FormatStyle(date: .numeric))")
                                        }
                                        .font(.subheadline)

                                        HStack {
                                            Image(systemName: "stopwatch")
                                            Text("\(run.time)")
                                        }
                                        .font(.subheadline)
                                    }
                                }
                                // See: https://stackoverflow.com/questions/59528780/how-to-create-spacing-between-items-in-a-swiftui-list-view
                                //                            .listRowBackground(
                                //                                RoundedRectangle(cornerRadius: 5)
                                //                                    .background(.clear)
                                //                                    .foregroundColor(.clear)
                                //                                    .padding(EdgeInsets(
                                //                                        top: 2,
                                //                                        leading: 10,
                                //                                        bottom: 2,
                                //                                        trailing: 10)))
                                //                            .listRowSeparator(.hidden)

                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            context.delete(run)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash").symbolVariant(/*@START_MENU_TOKEN@*/ .fill/*@END_MENU_TOKEN@*/)
                                    }

                                    Button {
                                        runToEdit = run
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                            }
                            .tint(.black)
                        }
                    }
                }

                // FAB: https://sarunw.com/posts/floating-action-button-in-swiftui/
                Button {
                    showCreateRunSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    // .shadow(radius: 4, x: 0, y: 4)
                }
                .padding()
            }
            .sheet(isPresented: $showCreateRunSheet) {
                RunDetailView(formMode: "create")
            }
            .sheet(item: $runToEdit) {
                runToEdit = nil
            } content: { run in
                RunDetailView(run: run,
                              formMode: "edit")
            }
        }
        .onAppear(perform: {
            checkNotificationPermissions()
        })
    }
}

func checkNotificationPermissions() {
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.getNotificationSettings { settings in
        switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, _ in
                    if didAllow {
                        scheduleNotifications()
                    }
                }
            case .denied: return
            case .authorized, .ephemeral, .provisional:
                scheduleNotifications()
            default: return
        }
    }
}

func scheduleNotifications() {
    scheduleNotification(identifier: "run-reminder-sunday", weekDay: 1, hour: 15, minute: 30)
    scheduleNotification(identifier: "run-reminder-tuesday", weekDay: 3, hour: 17, minute: 00)
    scheduleNotification(identifier: "run-reminder-thursday", weekDay: 5, hour: 17, minute: 00)
}

func scheduleNotification(identifier: String, weekDay: Int, hour: Int, minute: Int) {
    let notificationCenter = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = "Update runs"
    content.body = "Did you go for a run?"
    content.sound = .default

    let calendar = Calendar.current
    var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
    dateComponents.weekday = weekDay
    dateComponents.hour = hour
    dateComponents.minute = minute

    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

    notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    notificationCenter.add(request)
}

#Preview {
    RunList()
}
