//
//  ContentView.swift
//  CoreDataToDo
//
//  Created by Mohammad Adil on 03/07/20.
//  Copyright © 2020 Mohd Yasir. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoItem.getAllToDoItems())  var todoItems: FetchedResults<ToDoItem>
    
    @State private var newTodoItem = ""
    
    
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("What next")){
                    HStack{
                        TextField("New Item",text: self.$newTodoItem)
                        Button(action: {
                            let toDoItem = ToDoItem(context: self.managedObjectContext)
                            toDoItem.title = self.newTodoItem
                            toDoItem.createdAt = Date()
                            
                            do{
                                try self.managedObjectContext.save()
                            }catch{
                                print(error)
                            }
                            
                            self.newTodoItem = ""
                        }){
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                    }
                }
                Section(header: Text("To DOs")){
                    ForEach(self.todoItems){ todoItem in
                        ToDoItemView(title: todoItem.title!, createdAt: "\(todoItem.createdAt!)")
                    }.onDelete { indexSet in
                        let deleteItem = self.todoItems[indexSet.first!]
                        self.managedObjectContext.delete(deleteItem)
                        
                        do{
                            try self.managedObjectContext.save()
                        }catch{
                            print(error)
                        }
                    }
                    
                }
            }
            .navigationBarTitle(Text("My List"))
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
