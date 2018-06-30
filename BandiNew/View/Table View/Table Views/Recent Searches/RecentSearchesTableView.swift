//
//  RecentSearchesTableView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/13/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit
import CoreData

class RecentSearchesTableView: UITableView, UITableViewDelegate {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        dataSource = self
        delegate = self
        allowsSelection = true
        register(BaseTableViewCell.self, forCellReuseIdentifier: recentSearchCellId)
        setUpTheming()
        
        self.fetchRecentSearches()
    }
    
    let recentSearchCellId = "recentSearchCellId"
    var rowSelected: ((String)->())?
    
    private var persistentContainer = CoreDataHelper.shared.getPersistentContainer()
    private lazy var context = CoreDataHelper.shared.getContext()
    private lazy var fetchedResultsController: NSFetchedResultsController<RecentSearch> = {
        let fetchRequest: NSFetchRequest<RecentSearch> = RecentSearch.fetchRequest()
        fetchRequest.sortDescriptors = []
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private var hasSearches: Bool {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return false }
        return fetchedObjects.count > 0
    }
    
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
    
    lazy var recentSearchesHeader: RecentSearchesSectionHeader = {
        let view = RecentSearchesSectionHeader()
        view.label.text = "Recent"
        view.addSubview(clearButton)
        return view
    }()
    
    private func fetchRecentSearches() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error: \(error)")
        }
    }
    
    @objc func clearPressed() {
        DispatchQueue.global(qos: .userInteractive).async {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: self.fetchedResultsController.fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            do {
                try self.context.execute(batchDeleteRequest)
                try self.fetchedResultsController.performFetch()
                DispatchQueue.main.async {
                    self.reloadData()
                }
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    func addSearch(_ searchString: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            var searchFound = false
            if let fetchedObjects = self.fetchedResultsController.fetchedObjects {
                for object in fetchedObjects {
                    let recentSearch = object.recentSearch
                    searchFound = searchString == recentSearch
                    if searchFound { break }
                }
                if !searchFound {
                    self.context.perform({
                        let newRecentSearch = RecentSearch(context: self.context)
                        newRecentSearch.recentSearch = searchString
                    })
                    do {
                        try self.context.save()
                    } catch let error {
                        print("error: \(error)")
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fetchedObject = fetchedResultsController.object(at: indexPath)
        rowSelected?(fetchedObject.recentSearch!)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        NSLayoutConstraint.activate([
            clearButton.trailingAnchor.constraint(equalTo: recentSearchesHeader.trailingAnchor, constant: -15),
            clearButton.bottomAnchor.constraint(equalTo: recentSearchesHeader.bottomAnchor, constant: -5),
            clearButton.widthAnchor.constraint(equalToConstant: 80)
            ])
        return recentSearchesHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RecentSearchesTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fetchedObjects = fetchedResultsController.fetchedObjects {
            return fetchedObjects.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: recentSearchCellId, for: indexPath) as! BaseTableViewCell
        configure(cell, at: indexPath)
        return cell
    }
    
    func configure(_ cell: BaseTableViewCell, at indexPath: IndexPath) {
        let recentSearch = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = recentSearch.recentSearch
        let selectedView = UIView()
        selectedView.backgroundColor = Constants.Colors().primaryColor
        cell.selectedBackgroundView = selectedView
    }
    
}

extension RecentSearchesTableView: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = cellForRow(at: indexPath) as? BaseTableViewCell {
                configure(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
    
}

extension RecentSearchesTableView: Themed {
    func applyTheme(_ theme: AppTheme) {
        backgroundColor = theme.tableBackgroundColor
        separatorColor = theme.tableSeparatorColor
        recentSearchesHeader.label.textColor = theme.textColor
    }
}
