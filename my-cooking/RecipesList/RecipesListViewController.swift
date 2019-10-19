//
//  RecipesListViewController.swift
//  my-cooking
//
//  Created by Vladas Drejeris on 16/09/2019.
//  Copyright © 2019 ito. All rights reserved.
//

import UIKit
import AlamofireImage


class RecipesListViewController: UIViewController {
    
    // MARK: - UI components
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: - Dependencies
    
    private let repository = RecipesRepository.shared
    
    private lazy var dataSource: TableDataSource = {
        let adapter = TableDataSource()
        adapter.didSelect = { [weak self] (element, _, _) in
            if let receipe = element as? Recipe{
                self?.performSegue(withIdentifier: "ShowDetailsScreen", sender: receipe)
            }
        }
        return adapter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        loadData()
    }
    
    private func loadData() {
        var sectionItem = [Section]()
        for diffculty in Difficulty.getAllValues(){
            repository.recipes(withDifficulty: diffculty) { [weak self] (result) in
                switch result {
                case .success(let recipes):
                    sectionItem.append(Section(diffculty.localizedString, footer: nil, recipes))
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
        dataSource.set(sectionItem)
        
        
    }
    
    private func handleError(_ error: Error) {
        // There are no errors at the moment, therefore we don't need to implement this method.
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let recipeViewController = segue.destination as? RecipeViewController,
            let recipe = sender as? Recipe {
            recipeViewController.recipe = recipe
        }
    }
    
    @IBAction func unwindFromRecipeViewController(_ segue: UIStoryboardSegue) {
        
    }
    
}

extension Recipe:Row{
    func configure(cell: ReceipeCell) {
        cell.textLabel?.text = title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        cell.detailTextLabel?.text = dificulty.localizedString
        cell.detailTextLabel?.textColor = dificulty.color
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        if let imageUrl = image {
            cell.imageView?.af_setImage(withURL: imageUrl,
                                        placeholderImage: UIImage(named: "placeholder_small"),
                                        filter: AspectScaledToFitSizeFilter(size: CGSize(width: 32, height: 32)))
        } else {
            cell.imageView?.image = UIImage(named: "placeholder_small")
        }
    }
    
}
class ReceipeCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
