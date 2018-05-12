//
//  SearchSuggestionsTableView.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/11/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SearchSuggestionsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        dataSource = self
        delegate = self
        alwaysBounceVertical = true
        backgroundColor = Constants.Colors().darkTableCell
        separatorInset = UIEdgeInsets(top: 0, left: 46, bottom: 0, right: 0)
        separatorColor = Constants.Colors().darkTableSeparator
        allowsSelection = true
    }
    
    let searchSearchSuggestionsCellId = "searchSearchSuggestionsCellId"
    var suggestions: [String] = []
    var suggestionSelected: ((String) -> ())?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = suggestions[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        let searchImage = UIImageView(image: #imageLiteral(resourceName: "search-90").withRenderingMode(.alwaysTemplate))
        searchImage.tintColor = .lightGray
        searchImage.contentMode = .scaleAspectFit
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(searchImage)
        NSLayoutConstraint.activate([
            searchImage.widthAnchor.constraint(equalToConstant: 20),
            searchImage.heightAnchor.constraint(equalToConstant: 20),
            searchImage.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -15),
            searchImage.topAnchor.constraint(equalTo: cell.topAnchor, constant: 20)
            ])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        suggestionSelected?(suggestions[indexPath.row])
    }
    
//    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
//        <#code#>
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
