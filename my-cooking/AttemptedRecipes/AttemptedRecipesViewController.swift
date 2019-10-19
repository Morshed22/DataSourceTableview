//
//  AttemptedRecipesViewController.swift
//  my-cooking
//
//  Created by Vladas Drejeris on 16/09/2019.
//  Copyright © 2019 ito. All rights reserved.
//

import UIKit
import AlamofireImage

class AttemptedRecipesViewController: UIViewController {
    
    // MARK: - UI components
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Dependencies
    
    private let repository = DishesRepository.shared
    private lazy var dataSource: TableDataSource = {
        let dataSource = TableDataSource()
        dataSource.didSelect = { [weak self] (element, _, _) in
            if let dish = element as? Dish{
                self?.performSegue(withIdentifier: "ShowDetailsScreen", sender:dish.recipe)
            }
        }
        return dataSource
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    private func loadData() {
        repository.allDishes { [weak self] (result) in
            switch result {
            case .success(let dishes):
                dataSource.set(dishes)
            case .failure(let error):
                self?.handleError(error)
            }
        }
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

extension Dish:Row{
    func configure(cell:ReceipeCell) {
        cell.textLabel?.text = recipe.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        cell.detailTextLabel?.text = result.localizedString
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        if let imageUrl = recipe.image {
            cell.imageView?.af_setImage(withURL: imageUrl,
                                        placeholderImage: UIImage(named: "placeholder_small"),
                                        filter: ScaledToSizeFilter(size: CGSize(width: 32, height: 32)))
        } else {
            cell.imageView?.image = UIImage(named: "placeholder_small")
        }
    }
}


