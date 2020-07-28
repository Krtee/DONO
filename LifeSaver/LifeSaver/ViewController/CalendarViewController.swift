//
//  CalendarViewController.swift
//  LifeSaver
//
//  Created by Minh Vu Nguyen on 25.06.20.
//  Copyright © 2020 Ansgar Gerlicher. All rights reserved.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    @IBAction func monthNext(_ sender: Any) {
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

                monthDisplay.text = "\(currentMonth), \(year)"
                
                initWeeks()
                showWeek = 0

                
                
                CalenderView.reloadData()
            default:
                Direction = 1
                GetStartDateDayPosition()
                
                month += 1


                currentMonth = Months[month]
                monthDisplay.text = "\(currentMonth), \(year)"
                
                initWeeks()
                showWeek = 0

                
                CalenderView.reloadData()
                
            }

            
        }
        else {
            showWeek = showWeek + 1
            CalenderView.reloadData()

        }

        
    }
    @IBAction func monthBack(_ sender: Any) {
        if showWeek == 0 {
        
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            Direction = -1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            
            monthDisplay.text = "\(currentMonth), \(year)"
            
            initWeeks()
            showWeek = WeeklyBoxes.count - 1

            
            CalenderView.reloadData()
        default:
            month -= 1
            Direction = -1
            
            currentMonth = Months[month]

            GetStartDateDayPosition()
            monthDisplay.text = "\(currentMonth), \(year)"
            
            initWeeks()
            showWeek = WeeklyBoxes.count - 1

            
            CalenderView.reloadData()
            
            }
            
        }
        else{
            showWeek = showWeek - 1
            CalenderView.reloadData()
        }
    }
    
    @IBAction func setAppointment(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        let hospital: String = defaults.string(forKey: "hospitalID") ?? ""
        let donateType: String = defaults.string(forKey: "DonateType") ?? ""
        let userId: String = defaults.string(forKey: "userID") ?? ""
        
        print("\(String(describing: hospital)) \(String(describing: donateType)) \(String(describing: userId))")
        
        if hospital != "" && donateType != "" && userId != "" {
            print("\(String(describing: hospital))+\(String(describing: donateType))+\(String(describing: userId))")

            if selectedDay != -1 && selectedTime != "" && selectedMonth != -1 {
                
                do{
                let timeArr = selectedTime.components(separatedBy: ":")
                let hour: String = timeArr[0]
                let minute: String = timeArr.count > 1 ? timeArr[1] : "00"
                
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = selectedMonth
                dateComponents.day = selectedDay
                dateComponents.timeZone = TimeZone(abbreviation: "CEST")
                dateComponents.hour = Int(hour)
                dateComponents.minute = Int(minute)

                // Create date from components
                let userCalendar = Calendar.current
                let appointmentDate = userCalendar.date(from: dateComponents)
                    
                    let appointment = CoreDataAppointmentService.defaults.createAppointment(hospitalID: hospital, userID: userId, donatetype: donateType, appointmentDate: appointmentDate!)
                
                    if appointment != nil {
                        print("successfully added appointment")
                        defaults.set(appointment?.appointmentID, forKey: "AppointmentID")
                        defaults.set("", forKey: "hospitalID")
                        defaults.set("", forKey: "DonateType")
                        
                        chosenAppointment = appointment
                        
                        self.performSegue(withIdentifier: "toQRGenerator", sender: self)

                    }
                    
                
                }
                catch let error{
                    print(error)
                }
                
            }
            else{
                print("no time selected")
            }
        }else{
            print("no hospital or user")

        }
    }
    
    
    @IBOutlet weak var monthDisplay: UILabel!
    @IBOutlet weak var CalenderView: UICollectionView!
    @IBOutlet weak var TimeTable: UICollectionView!
    
    //-------------------------------------------------------------------
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
    
    private let spacing:CGFloat = 16.0

        
    
    //--------------------------------------------------------------------------------------
    //timetable variables
    
    var TimeArray: [String] = []
    
    var openingTime: Int = 7
    
    var closingTime: Int = 15
    
    
    
    //------------------------------------------------------------------------------------
    
        
    var selectedDay: Int = -1
    
    var selectedMonth: Int = -1
    
    var selectedTime: String = ""
    
    var chosenAppointment: Appointment?
    //-------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMonth = Months[month]
        
        monthDisplay.text = "\(currentMonth), \(year)"
        if weekday == 0 {
            weekday = 7
        }
        GetStartDateDayPosition()
        //getDays(weeksAfterCurrent: 0)
        
        initWeeks()

        
        CalenderView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CalendarCollectionViewCell")

        initTimeTable()
        //print(dayArray)
        
        // Do any additional setup after loading the view.
    }
    
    func initTimeTable() {
        for n in openingTime...closingTime {
            TimeArray.append("\(n):00")
            TimeArray.append("\(n):30")
        }
    }
    
    // initialize 2d-Array of weeks in a month
    func initWeeks() {
        
        for n in 0...getNumOfBoxes() {
            switch Direction {
            case 0:
                BoxArray.append("\(n + 1 - NumberOfEmptyBox)")
            case 1:
                BoxArray.append("\(n + 1 - NextNumberOfEmptyBox)")
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
        case 1...:
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
            PositionIndex = NextNumberOfEmptyBox
            
        case -1 :
            PrevNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex )%7)
            if PrevNumberOfEmptyBox == 7 {
                PrevNumberOfEmptyBox = 0
            }
            PositionIndex = PrevNumberOfEmptyBox
        default:
            fatalError()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == CalenderView{
            return 7
        } else {
            return 12
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == CalenderView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCollectionViewCell
            //cell.backgroundColor = UIColor.clear
            cell.calendarDay.textColor = UIColor.black
            
            if cell.isHidden{
                cell.isHidden = false
            }
            
           /* switch Direction {      //the first cells that needs to be hidden (if needed) will be negative or zero so we can hide them
            case 0:
                cell.calendarDay.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
            case 1:
                cell.calendarDay.text = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
            case -1:
                cell.calendarDay.text = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
            default:
                fatalError()
            }
            */
            cell.calendarDay.text = WeeklyBoxes[showWeek][indexPath.row]
            
            if Int(cell.calendarDay.text!)! < 1 {
                cell.isHidden = true
            }

            
            switch indexPath.row {
            case 5,6:
                if Int(cell.calendarDay.text!)! > 0 {
                    cell.calendarDay.textColor = UIColor.lightGray
                }
            default:
                break
            }
            
            if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 == day{
                cell.calendarDay.textColor = UIColor.red
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! TimeCollectionViewCell
            
            
            cell.time.text = TimeArray[indexPath.row]
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CalenderView {
            print(WeeklyBoxes[showWeek][indexPath.row])
            selectedDay = Int(WeeklyBoxes[showWeek][indexPath.row]) ?? 0
            
            for index in 0...Months.count {
                if currentMonth == Months[index] {
                    selectedMonth = index
                    break
                }
            }
        } else {
            selectedTime = TimeArray[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == CalenderView{
            let numberOfItemsPerRow:CGFloat = 7
            let spacingBetweenCells:CGFloat = 16
            
            let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.CalenderView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
        else{
            return CGSize(width: 0, height: 0)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQRGenerator" {
            
            if let vc = segue.destination as? QRCodeGenerator {

                vc.fetchedAppointment = chosenAppointment

            }
            
        }
    }
    
}
