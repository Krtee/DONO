//
//  Calendar.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 28.07.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import Foundation
class CustomCalendar {
    // calendar variables
    
    let Months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    let DaysOfMonth = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    
    var NumberOfEmptyBox = Int() //Number of empty boxes at the start of the month
    
    var NextNumberOfEmptyBox = Int() //Number of empty boxes at the start of the next month
    
    var PrevNumberOfEmptyBox = Int() //Number of empty boxes at the start of the last month
    
    var Direction = 0 // =0 if we are at the current month , = 1 if we are in a future month , = -1 if we are in a past month
    
    var PositionIndex = 0 //here we will store the above vars of the empty boxes
    
    var LeapYearCounter = 2
    
    var dayCounter = 0
    
    var WeeklyBoxes: [[String]] = []
    
    var showWeek = 0
    
    var BoxArray: [String] = []
    
    init() {
        currentMonth = Months[month]
        
        if weekday == 0 {
            weekday = 7
        }
        GetStartDateDayPosition()
        //getDays(weeksAfterCurrent: 0)
        
        initWeeks()
    }
    
    
    func monthforward() {
        if showWeek == WeeklyBoxes.count - 1 {
            switch currentMonth {
            case "December":
                month = 0
                year += 1
                Direction = 1
                
                if LeapYearCounter < 5 {
                    LeapYearCounter += 1
                }
                
                if LeapYearCounter == 4 {
                    DaysInMonths[1] = 29
                }
                
                if LeapYearCounter == 5 {
                    LeapYearCounter = 1
                    DaysInMonths[1] = 28
                }
                
                
                GetStartDateDayPosition()
                
                currentMonth = Months[month]

                
                initWeeks()
                showWeek = 0

                
            default:
                Direction = 1
                GetStartDateDayPosition()
                
                month += 1


                currentMonth = Months[month]
                
                initWeeks()
                showWeek = 0

                
                print(WeeklyBoxes)
                
            }

            
        }
        else {
            showWeek = showWeek + 1

        }

    }
    
    
    func monthbackwards() {
        
        if showWeek == 0 {
        
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            Direction = -1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
                        
            initWeeks()
            showWeek = WeeklyBoxes.count - 1

        default:
            month -= 1
            Direction = -1
            
            currentMonth = Months[month]

            GetStartDateDayPosition()
            
            initWeeks()
            showWeek = WeeklyBoxes.count - 1

            
            
            }
            
        }
        else{
            showWeek = showWeek - 1
        }

    }
    
    
     func GetStartDateDayPosition() {
        switch Direction{
        case 0:
            NumberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter>0 {
                NumberOfEmptyBox = NumberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if NumberOfEmptyBox == 0 {
                    NumberOfEmptyBox = 7
                }
            }
            if NumberOfEmptyBox == 7 {
                NumberOfEmptyBox = 0
            }
            PositionIndex = NumberOfEmptyBox
            print(NumberOfEmptyBox)
        case 1...:
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
            PositionIndex = NextNumberOfEmptyBox
            print(NextNumberOfEmptyBox)
        case -1:
            PrevNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex)%7)
            if PrevNumberOfEmptyBox == 7 {
                PrevNumberOfEmptyBox = 0
            }
            PositionIndex = PrevNumberOfEmptyBox
            print(PrevNumberOfEmptyBox)
        default:
            fatalError()
        }
    }
        
        
        // initialize 2d-Array of weeks in a month
    func initWeeks() {
            BoxArray = []
            WeeklyBoxes = []
            
            for n in 0...getNumOfBoxes() {
                switch Direction {
                case 0:
                    BoxArray.append("\(n + 1 - NumberOfEmptyBox)")
                case 1:
                    BoxArray.append("\(n + 1 - NextNumberOfEmptyBox)")
                    print(BoxArray)
                case -1:
                    BoxArray.append("\(n + 1 - PrevNumberOfEmptyBox)")
                default:
                    fatalError()
                }
            }
            
            let weeksInThisMonth = Int(ceil(Double(BoxArray.count)/7))
                            
            var count = 0
            
            for n in 0...weeksInThisMonth-1 {
                var tempWeek: [String] = []
                for _ in 0...6 {
                    if count >= BoxArray.count-1 {
                        tempWeek.append("-1")
                    } else {
                        tempWeek.append(BoxArray[count])
                        if Int(BoxArray[count]) == day && currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) {
                            showWeek = n
                        }
                    }
                    count = count + 1
                }
                WeeklyBoxes.append(tempWeek)
            }
    }
        
    
    
    
    func getNumOfBoxes() -> Int{
        switch Direction {
        case 0:
            return DaysInMonths[month] + NumberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + NextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + PrevNumberOfEmptyBox
        default:
            fatalError()
        }
    }
}
