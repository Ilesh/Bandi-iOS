//
//  RecentSearchesTableView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/13/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

class RecentSearchesTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        dataSource = self
        delegate = self
        allowsSelection = true
        backgroundColor = Constants.Colors().darkTableCell
        separatorColor = Constants.Colors().darkTableSeparator
    }
    
    var recentSearches: [String] = []
    var rowSelected: ((String)->())?
    
    let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(Constants.Colors().primaryColor, for: .normal)
        button.contentHorizontalAlignment = .right
        button.tintColor = Constants.Colors().primaryColor
        button.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func clearPressed() {
        print("sadfasdf")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        DispatchQueue.global(qos: .userInitiated).async {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<RecentSearches> = RecentSearches.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                try context.execute(batchDeleteRequest)
                var recentSearchStrings: [String] = []
                let recentSearchesSave = try context.fetch(fetchRequest)
                for recentSearch in recentSearchesSave {
                    let recentSearch = recentSearch.recentSearch
                    recentSearchStrings.append(recentSearch!)
                }
                print(recentSearchStrings)
                self.recentSearches = recentSearchStrings
                DispatchQueue.main.async {
                    self.reloadData()
                }
            } catch let error {
                print("error: \(error)")
            }
        }
        

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = recentSearches[indexPath.row]
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelected?(recentSearches[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = RecentSearchesSectionHeader()
        view.label.text = "Recent"
        view.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            clearButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            clearButton.widthAnchor.constraint(equalToConstant: 80)
            ])
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count > 4 ? 4 : recentSearches.count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
