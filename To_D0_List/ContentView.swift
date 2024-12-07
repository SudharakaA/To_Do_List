//
//  ContentView.swift
//  To_D0_List
//
//  Created by Sudharaka Ashen Edussuriya on 2024-12-07.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    let description: String
    let timestamp: Date
}

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var newTask: String = ""
    @State private var hovering = false

    var body: some View {
        VStack {
            HStack {
                TextField("Enter new task", text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    addTask()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Task")
                    }
                    .padding()
                    .background(hovering ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .onHover { isHovering in
                    withAnimation {
                        hovering = isHovering
                    }
                }
                .scaleEffect(hovering ? 1.1 : 1.0)
                .animation(.spring(), value: hovering)
            }

            List {
                ForEach(tasks) { task in
                    VStack(alignment: .leading) {
                        Text(task.description)
                            .font(.headline)
                        Text("Created: \(formattedDate(task.timestamp))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: .gray, radius: 3, x: 0, y: 2)
                    )
                    .padding(.vertical, 5)
                    .transition(.opacity.combined(with: .slide))
                }
                .onDelete(perform: deleteTask)
            }
            .listStyle(SidebarListStyle()) // Updated for macOS compatibility
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                           startPoint: .top,
                           endPoint: .bottom)
        )
    }

    private func addTask() {
        if !newTask.isEmpty {
            let task = Task(description: newTask, timestamp: Date())
            withAnimation(.spring()) {
                tasks.append(task)
            }
            newTask = ""
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        withAnimation(.easeOut) {
            tasks.remove(atOffsets: offsets)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
