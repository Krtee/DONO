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
    
    var notifications = NotificationDelegate()
    
    
    @IBAction func monthNext(_ sender: Any) {
        customCalendar?.monthforward()
        monthDisplay.text = "\(customCalendar!.currentMonth), \(year)"
        CalenderView.reloadData()
    }
    @IBAction func monthBack(_ sender: Any) {
        
        customCalendar?.monthbackwards()
        monthDisplay.text = "\(customCalendar!.currentMonth), \(year)"
        CalenderView.reloadData()

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
                        
                        notifications.scheduleNotification(notificationTitle: "Reminder", identifier: " First Reminder", notificationBody: "We will remind you a day before your Appointment", triggerdate: Date(timeIntervalSinceNow: 3))
                        
                        if chosenAppointment != nil {
                            print("itll come")
                            notifications.scheduleNotification(notificationTitle: "Reminder", identifier: "AppointmentReminder", notificationBody: "Your is tomorrow! Don't forget it :)", triggerdate: (chosenAppointment?.date)!)
                        }
                                                
                        self.performSegue(withIdentifier: "toQRGenerator", sender: self)
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
    
    var customCalendar: CustomCalendar?
    

    
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
        customCalendar = CustomCalendar.init()
        
        
        customCalendar!.currentMonth = customCalendar!.Months[month]
        
        monthDisplay.text = "\(customCalendar!.currentMonth), \(year)"

        
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
            
            cell.calendarDay.text = customCalendar!.WeeklyBoxes[customCalendar!.showWeek][indexPath.row]
            
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
            
            if customCalendar!.currentMonth == customCalendar!.Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 == day{
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
            selectedDay = Int(customCalendar!.WeeklyBoxes[customCalendar!.showWeek][indexPath.row]) ?? 0
            
            for index in 0...customCalendar!.Months.count {
                if customCalendar!.currentMonth == customCalendar!.Months[index] {
                    selectedMonth = index+1
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQRGenerator" {
            
            if let vc = segue.destination as? QRCodeGenerator {

                vc.fetchedAppointment = chosenAppointment

            }
            
        }
    }
    
}
