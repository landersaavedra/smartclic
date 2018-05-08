//
//  MainAlarmViewController.swift
//  SmartPlugRC1
//
//  Created by Lander Saavedra on 11/03/18.
//  Copyright © 2018 com.RudyLLantoy. All rights reserved.
//

import UIKit


class MainAlarmViewController: UITableViewController{
    
    var alarmDelegate: AlarmApplicationDelegate = AppDelegate()
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarmModel: Alarms = Alarms()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmScheduler.checkNotification()
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alarmModel = Alarms()
        tableView.reloadData()
        //añada dinámicamente el botón editar
        if alarmModel.count != 0 {
            self.navigationItem.leftBarButtonItem = editButtonItem
        }
        else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Fuente de datos de vista de tabla
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Devuelve la cantidad de secciones.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Devuelve el número de filas en la sección.
        if alarmModel.count == 0 {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        else {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        return alarmModel.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            performSegue(withIdentifier: Id.editSegueIdentifier, sender: SegueInfo(curCellIndex: indexPath.row, isEditMode: true, label: alarmModel.alarms[indexPath.row].label, mediaLabel: alarmModel.alarms[indexPath.row].mediaLabel, mediaID: alarmModel.alarms[indexPath.row].mediaID, repeatWeekdays: alarmModel.alarms[indexPath.row].repeatWeekdays, enabled: alarmModel.alarms[indexPath.row].enabled, snoozeEnabled: alarmModel.alarms[indexPath.row].snoozeEnabled))
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Id.alarmCellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: Id.alarmCellIdentifier)
        }
        //texto cedula
        cell!.selectionStyle = .none
        cell!.tag = indexPath.row
        let alarm: Alarm = alarmModel.alarms[indexPath.row]
        let amAttr: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 20.0)]
        let str = NSMutableAttributedString(string: alarm.formattedTime, attributes: amAttr)
        let timeAttr: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 45.0)]
        str.addAttributes(timeAttr, range: NSMakeRange(0, str.length-2))
        cell!.textLabel?.attributedText = str
        cell!.detailTextLabel?.text = alarm.label
        //agregar el botón de cambio
        let sw = UISwitch(frame: CGRect())
        sw.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
        
        //etiqueta se usa para indicar qué fila se tocó
        sw.tag = indexPath.row
        sw.addTarget(self, action: #selector(MainAlarmViewController.switchTapped(_:)), for: UIControlEvents.valueChanged)
        if alarm.enabled {
            cell!.backgroundColor = UIColor.white
            cell!.textLabel?.alpha = 1.0
            cell!.detailTextLabel?.alpha = 1.0
            sw.setOn(true, animated: false)
        } else {
            cell!.backgroundColor = UIColor.groupTableViewBackground
            cell!.textLabel?.alpha = 0.5
            cell!.detailTextLabel?.alpha = 0.5
        }
        cell!.accessoryView = sw
        
        //eliminar la línea de separación vacía
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return cell!
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        let index = sender.tag
        alarmModel.alarms[index].enabled = sender.isOn
        if sender.isOn {
            print("switch on")
            alarmScheduler.setNotificationWithDate(alarmModel.alarms[index].date, onWeekdaysForNotify: alarmModel.alarms[index].repeatWeekdays, snoozeEnabled: alarmModel.alarms[index].snoozeEnabled, onSnooze: false, soundName: alarmModel.alarms[index].mediaLabel, index: index)
            tableView.reloadData()
        }
        else {
            print("switch off")
            alarmScheduler.reSchedule()
            tableView.reloadData()
        }
    }
    
    // Anular para admitir la edición de la vista de tabla.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            alarmModel.alarms.remove(at: index)
            let cells = tableView.visibleCells
            for cell in cells {
                let sw = cell.accessoryView as! UISwitch
                //ajustar el índice guardado cuando se eliminó la fila
                if sw.tag > index {
                    sw.tag -= 1
                }
            }
            if alarmModel.count == 0 {
                self.navigationItem.leftBarButtonItem = nil
            }
            
            // Eliminar la fila de la fuente de datos
            tableView.deleteRows(at: [indexPath], with: .fade)
            alarmScheduler.reSchedule()
        }
    }
    
    // En una aplicación basada en un guión gráfico, a menudo querrás hacer un poco de preparación antes de la navegación
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Obtenga el nuevo controlador de vista usando segue.destinationViewController.
        // Pase el objeto seleccionado al nuevo controlador de vista.
        let dist = segue.destination as! UINavigationController
        let addEditController = dist.topViewController as! AlarmAddEditViewController
        if segue.identifier == Id.addSegueIdentifier {
            addEditController.navigationItem.title = "Add Alarm"
            addEditController.segueInfo = SegueInfo(curCellIndex: alarmModel.count, isEditMode: false, label: "Alarm", mediaLabel: "bell", mediaID: "", repeatWeekdays: [], enabled: false, snoozeEnabled: false)
        }
        else if segue.identifier == Id.editSegueIdentifier {
            addEditController.navigationItem.title = "Edit Alarm"
            addEditController.segueInfo = sender as! SegueInfo
        }
    }
    
    @IBAction func unwindFromAddEditAlarmView(_ segue: UIStoryboardSegue) {
        isEditing = false
    }
    
    public func changeSwitchButtonState(index: Int) {
        //let info = notification.userInfo as! [String: AnyObject]
        //let index: Int = info["index"] as! Int
        alarmModel = Alarms()
        if alarmModel.alarms[index].repeatWeekdays.isEmpty {
            alarmModel.alarms[index].enabled = false
        }
        let cells = tableView.visibleCells
        for cell in cells {
            if cell.tag == index {
                let sw = cell.accessoryView as! UISwitch
                if alarmModel.alarms[index].repeatWeekdays.isEmpty {
                    sw.setOn(false, animated: false)
                    cell.backgroundColor = UIColor.groupTableViewBackground
                    cell.textLabel?.alpha = 0.5
                    cell.detailTextLabel?.alpha = 0.5
                }
            }
        }
    }
}


