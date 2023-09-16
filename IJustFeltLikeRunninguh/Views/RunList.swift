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
                        HStack {
                            Text("\(run.date, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                .font(.callout)
                        }
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
                            .tint(.gray)
                        }
                    }.navigationTitle("Runs")
                }
            }
            .sheet(item: $runToEdit) {
                runToEdit = nil
            } content: { run in
                RunEditView(run: run)
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
        }.sheet(isPresented: $showCreateRunSheet) {
            RunCreateView()
        }
    }
}

#Preview {
    RunList()
}