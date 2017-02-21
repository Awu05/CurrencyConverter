//
//  TrackingCurrencyTableViewController.swift
//  CurrencyConverter
//
//  Created by Andy Wu on 2/16/17.
//  Copyright © 2017 Andy Wu. All rights reserved.
//

import UIKit

class TrackingCurrencyTableViewController: UITableViewController {
    
    
    var mySharedData = DataAccessObject.sharedManager

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib.init(nibName: "TrackedCurrencyTableViewCell", bundle: nil)
        
        //Register the nib/xib with the tableview
        tableView.register(cellNib, forCellReuseIdentifier: "trackedCurrency")
        
        
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        self.refreshControl?.addTarget(self, action: #selector(TrackingCurrencyTableViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
    }
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        Utilities.refreshRates()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mySharedData.currencyArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackedCurrency", for: indexPath) as! TrackedCurrencyTableViewCell
        
        let currentCurrency = mySharedData.currencyArray[indexPath.row]
        
        let fromCurr:String = currentCurrency.fromCurrency!
        let toCurr:String = currentCurrency.toCurrency!
        let currExchgRate:Double = currentCurrency.currentRate
        
        let currLbl = String(format: "1 %@ is %f %@", fromCurr, currExchgRate, toCurr)
        
        cell.currencyLbl.text = currLbl

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            mySharedData.deleteTrackedCurrency(trackedCurrencyIndex: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
