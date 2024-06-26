//
//  ToodoListView.swift
//  voiceMemo
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    var body: some View {
        ZStack {
            //Todo Cell List
            VStack {
                //투두가 없다면 네비게이션바가 X
                if !todoListViewModel.todos.isEmpty {
                    CustomNavigationBar(
                        isDisplayLeftBtn: false,
                        rightBtnAction: {
                            todoListViewModel.navigationRightButtonTapped()
                        },
                        rightBtnType: todoListViewModel.navigationBarRightBtnMode
                    )
                } else {
                    Spacer()
                        .frame(height: 30)
                }
                //titleView 하위뷰를 만드는 방법 1
                //titleView() 하위뷰를 만드는 방법 2
                titleView()
                    .padding(.top, 20)
                
                if todoListViewModel.todos.isEmpty {
                    AnnoucementView()
                } else {
                    TodoListContentView()
                        .padding(.top, 20)
                }
            }
            
            WriteTodoButtonView()
                .padding(.trailing, 20)
                .padding(.bottom, 50)
        }
        .alert(
            "To do List \(todoListViewModel.removeTodosCount)개 삭제 하시겠습니까?",
            isPresented: $todoListViewModel.isDisplayRemoveTodoAlert
        ) {
            Button("삭제", role: .destructive) {
                todoListViewModel.removeButtonTapped()
            }
            Button("취소", role: .cancel) {}
        }
    }
    
    //하위뷰를 만드는 방법 1
    //    var titleView: some View {
    //        Text("Title")
    //    }
    //하위뷰를 만드는 방법 2
    //    func titleView() -> some View {
    //        Text("Title")
    //    }
    
} //TodoListView

//하위뷰를 만드는 방법 3
//MARK: - TodoList 타이틀 뷰
private struct titleView: View {
    //@EnviromentObject 가 있을경우 주입을 해야함
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do List를\n추가해 보세요.")
            } else {
                Text("To do list \(todoListViewModel.todos.count)개가\n있습니다.")
            }
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

//MARK: - TodoList 안내뷰
private struct AnnoucementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            Image("pencil")
                .renderingMode(.template)
            Text("\"매일 아침 5시 운동 가라고 알려줘")
            Text("\"내일 8시 수강 신청하라고 알려줘")
            Text("\"1시 반 점심 약속 리마인드 해줘")
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(Color.customGray2)
    }
}

//MARK: - TodoList 컨텐츠 뷰
private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color("customGray0"))
                        .frame(height: 1)
                }
            }
            
            ForEach(todoListViewModel.todos, id: \.self) { todo in
                //Todo 셀 뷰 todo 넣어서 뷰 호출
                TodoCellView(todo: todo)
            }
        }
    }
}

//MARK: - Todo Cell View
private struct TodoCellView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool
    private var todo: Todo
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        todo: Todo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack {
                if !todoListViewModel.isEditTodoMode {
                    Button {
                        todoListViewModel.selectedBoxTapped(todo)
                    } label: {
                        todo.selected ? Image("selectedBox") : Image("unSelectedBox")
                    }
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundStyle(todo.selected ? Color.customIconGray : Color.customBlack)
                        .strikethrough(todo.selected)
                    
                    Text(todo.converterDayAndTime)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.customIconGray)
                }
                Spacer()
                
                if todoListViewModel.isEditTodoMode {
                    Button {
                        isRemoveSelected.toggle()
                        todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                    } label: {
                        isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        
        Rectangle()
            .fill(Color("customGray0"))
            .frame(height: 1)
    }
}

//MARK: - todo 작성 버튼 뷰
private struct WriteTodoButtonView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button{
                    pathModel.paths.append(.todoView)
                } label: {
                    Image("writeBtn")
                }
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
            .environmentObject(PathModel())
            .environmentObject(TodoListViewModel())
    }
}
