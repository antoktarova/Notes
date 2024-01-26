import Foundation
import UIKit

class TaskService {
    
    static let shared = TaskService()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func getTasks() -> [Task] {
        guard let data = userDefaults.data(forKey: "tasks") else {
            return []
        }
        
        let decoder = PropertyListDecoder()
        let tasks = try? decoder.decode([Task].self, from: data)
        return tasks ?? []
    }
    
    func saveTasks(tasks: [Task]) {
        let encoder = PropertyListEncoder()
        let data = try! encoder.encode(tasks)
        userDefaults.set(data, forKey: "tasks")
    }
    
    func appendOrUpdate(task: Task) {
        var tasks = getTasks()
        
        var targetIndex: Int? = nil
        for (index, element) in tasks.enumerated() {
            if element.id == task.id {
                targetIndex = index
            }
        }
        
        if let targetIndex = targetIndex {
            tasks[targetIndex] = task
        } else {
            tasks.append(task)
        }
        
        saveTasks(tasks: tasks)
    }
    
    func deleteTask(task: Task) {
        var tasks = getTasks()
        
        for (index, element) in tasks.enumerated() {
            if element.id == task.id {
                tasks.remove(at: index)
            }
        }
        
        saveTasks(tasks: tasks)
    }
    
    func getPendingTasks() -> [Task] {
        var pendingTasks: [Task] = []
        
        for element in getTasks() {
            if !element.isDone {
                pendingTasks.append(element)
            }
        }
        return pendingTasks
    }
    
    func getNumberTasksIsDone() -> Int {
        var numberTasksIsDone = 0
        
        for element in getTasks() {
            if element.isDone {
                numberTasksIsDone += 1
            }
        }
        
        return numberTasksIsDone
    }
    
}
