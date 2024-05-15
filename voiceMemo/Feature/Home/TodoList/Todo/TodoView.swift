//
//  TodoView.swift
//  voiceMemo
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @StateObject private var todoViewModel = TodoViewModel()
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                leftBtnAction: {
                    pathModel.paths.removeLast()
                },
                rightBtnAction: {
                    todoListViewModel.addTodo(
                        .init(
                            title: todoViewModel.title,
                            time: todoViewModel.time,
                            day: todoViewModel.time,
                            selected: false
                        )
                    )
                    pathModel.paths.removeLast()
                },
                rightBtnType: .create
            ) //CustomNavigationBar
            
            // 타이틀뷰
            TitleView()
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 20)
            
            // 투두 타이틀 뷰 (텍스트 필드제목 입력 뷰)
            TodoTitleView(todoViewModel: todoViewModel)
            
            // 시간 선택
            SelectTimeView(todoViewModel: todoViewModel)
            
            // 날짜 선택
            SelectDayView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            Spacer()
        }
    }
}

//MARK: - 타이틀뷰
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("TodoList를 \n추가해 보세요")
            
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

//MARK: - 투두 타이틀 뷰 (텍스트 필드 제목 입력 뷰)
private struct TodoTitleView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        TextField("제목을 입력하세요.", text: $todoViewModel.title)
    }
}

//MARK: - 시간 선택
private struct SelectTimeView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color("customGray0"))
                .frame(height: 1)
            
            DatePicker(
                "",
                selection: $todoViewModel.time,
                displayedComponents: [.hourAndMinute]
            )
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
            .frame(maxWidth: .infinity, alignment: .center)
            
            Rectangle()
                .fill(Color("customGray0"))
                .frame(height: 1)
        }
    }
}
//MARK: - 날짜 선택
private struct SelectDayView: View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            Text("날짜")
                .foregroundStyle(Color.customIconGray)
            Spacer()
                .frame(height: 10)
        }
        
        HStack {
            Button {
                todoViewModel.setIsDisplayCalendar(true)
            } label: {
                Text("\(todoViewModel.day.foremattedDay)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.customGreen)
            }
            .popover(
                isPresented: $todoViewModel.isDisplayCalendar) {
                    DatePicker(
                        "",
                        selection: $todoViewModel.day,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(minWidth: .infinity, alignment: .center)
                    .padding()
                    .onChange(of: todoViewModel.day) { _ in
                        //day가 변경되면 실행하는 로직
                        //캘린더 닫기
                        todoViewModel.setIsDisplayCalendar(false)
                    }
                    Spacer()
                }
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
