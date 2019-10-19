//
//  RecomendationViewController.swift
//  my-cooking
//
//  Created by Morshed Alam on 19/10/19.
//  Copyright © 2019 ito. All rights reserved.
//

import UIKit
import AlamofireImage

class RecomendationViewController: UIViewController {
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    private let repository = DishesRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        repository.recommendedRecipe { [weak self]  recipe in
            guard let `self` = self, let recipe = recipe else { return }
            self.recipeTitleLabel.text = recipe.title
            if let imageUrl = recipe.image {
                recipeImageView.af_setImage(withURL: imageUrl, placeholderImage: UIImage(named: "placeholder_big"))
            } else {
                recipeImageView.image = UIImage(named: "placeholder_small")
            }
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
    
}
