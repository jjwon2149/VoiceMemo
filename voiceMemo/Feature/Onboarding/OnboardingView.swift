//
//  OnboardingView.swift
//  voiceMemo
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var pathModel = PathModel()
    @StateObject private var todoListViewModel = TodoListViewModel()
    
    var body: some View {
        
        //TODO: - 화면 전환 구현 필요
        NavigationStack(path: $pathModel.paths) {
//            OnboardingContentView(onboardingViewModel: onboardingViewModel)
            TodoListView()
                .environmentObject(todoListViewModel)
                .navigationDestination(for: PathType.self) { pathType in
                    switch pathType {
                    case .homView:
                        HomeView()
                            .navigationBarBackButtonHidden() //커스텀한 네비게이션 바 사용을 위해
                    case .todoView:
                        TodoView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(todoListViewModel)
                    case .memoView:
                        MemoView()
                            .navigationBarBackButtonHidden()
                    }
                }
        }
        .environmentObject(pathModel) //pathModel을 전역적으로 사용
    }
}

//MARK: - 온보딩 컨텐츠 뷰
private struct OnboardingContentView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            //온보딩 셀리스트 뷰
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            //시작버튼 뷰
            StartBtnView()
        }
        .ignoresSafeArea()
    }
}

//MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var selectedIndex = 0
    
    fileprivate init(
        onboardingViewModel: OnboardingViewModel,
        selectedIndex: Int = 0
    ) {
        self.onboardingViewModel = onboardingViewModel
        self.selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View {
        TabView(selection: $selectedIndex) {
            //온보딩 셀
            ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element) { index, onboardingContent in
                OnboardingCellView(onboardingContent: onboardingContent)
                    .tag(index)
                
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
        .background(
            selectedIndex % 2 == 0 ? Color.customSky : Color.customGreen
        )
        .clipped()
    }
}

//MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
    private var onboardingContent: OnboardingContent
    
    fileprivate init(onboardingContent: OnboardingContent
    ) {
        self.onboardingContent = onboardingContent
    }
    
    fileprivate var body: some View {
        VStack {
            Image(onboardingContent.imageFileName)
                .resizable()
                .scaledToFit()
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 46)
                    
                    Text(onboardingContent.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text(onboardingContent.subTitle)
                        .font(.system(size: 16))
                    
                }
                Spacer()
            }
            .background(Color.customWhite)
            //            .clipShape(RoundedRectangle(cornerRadius: 0))
            .cornerRadius(0)
        }
        .shadow(radius: 10)
    }
}
//MARK: - 시작하기 버튼 뷰
private struct StartBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        Button {
            pathModel.paths.append(.homView)
        } label: {
            HStack {
                Text("시작하기")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.customGreen)
                
                Image("startHome")
                    .renderingMode(.template)
                    .foregroundColor(.customGreen)
            }
        }

    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
