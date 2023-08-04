//
//  Home.swift
//  Task Management
//
//  Created by Panchenko Oleg on 02.08.2023.
//

import SwiftUI

struct Home: View {
    //Task Manager Properties
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 0
    @State private var createWeek: Bool = false
    @State private var tasks: [Task] = sampleTasks.sorted(by: {$1.creationDate > $0.creationDate } )
    @State private var createNewTask: Bool = false

    //Animation Namespace
    @Namespace private var animation

    var body: some View {
       //Header View
        VStack(alignment: .leading, spacing: 0) {
            HeaderView()

            ScrollView(.vertical) {
                VStack {
                    //Tasks View
                    TasksView()
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
        }
        .vSpacing(.top)
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                createNewTask.toggle()
            }) {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 55, height: 55)
                    .background(Color("darkBlue").shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: Circle())
            }
            .padding(15)
        })
        .onAppear {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()

                if let firstDay = currentWeek.first?.date {
                    weekSlider.append(firstDay.createPreviousWeek())
                }
                weekSlider.append(currentWeek)

                if let lastDay = currentWeek.last?.date {
                    weekSlider.append(lastDay.createNextWeek())
                }
            }
        }
        .sheet(isPresented: $createNewTask) {
            NewTaskView()
                .presentationDetents([.height(300)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(Color("BG"))
        }
    }

    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 5) {
                Text(currentDate.format("MMMM"))
                    .foregroundStyle(Color("darkBlue"))

                Text(currentDate.format("YYYY"))
                    .foregroundStyle(.gray)
            }
            .font(.title.bold())

            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWidth(.condensed)
                .fontWeight(.semibold)
                .foregroundColor(.gray)

            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
        }
        .hSpacing(.leading)
        .overlay(alignment: .topTrailing, content: {
            Button(action: {} ) {
                Image("pic")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
        })
        .padding(15)
        .background(.white)
        .onChange(of: currentWeekIndex) { newValue in
            //Creating when it reaches first/last Page
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
    }

    ///Week View
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .fontWidth(.condensed)
                        .foregroundColor(.gray)

                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .fontWidth(.condensed)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(Color("darkBlue"))
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }

                            //Indicator to show which is today's date
                            if day.date.isToday {
                                Circle()
                                    .fill(.cyan)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 12)

                            }
                        })
                        .background(.white.shadow(.drop(radius: 1)), in: Circle())
                }
                .hSpacing(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    //Updating current date
                    withAnimation(Animation.easeInOut) {
                        currentDate = day.date
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX

                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        ///When the Offset reaches 15 and if the createWeek is toggled then
                        ///simply generating next set of week
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }

    @ViewBuilder
    func TasksView() -> some View {
        VStack(alignment: .leading, spacing: 35) {
            ForEach($tasks) { $task in
                TaskRowView(task: $task)
                    .background(alignment: .leading) {
                        if tasks.last?.id != task.id {
                            Rectangle()
                                .frame(width: 1)
                                .offset(x: 8)
                                .padding(.bottom, -35)
                        }
                    }
            }
        }
        .padding([.vertical, .horizontal], 15)
        .padding(.top, 15)
    }

    func paginateWeek() {
        //SafeCheck
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                //Inserting new week at 0th and removing last array item
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }

            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex ==
                (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
