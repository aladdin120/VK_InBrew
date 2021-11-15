//
//  ProductsManager.swift
//  InBrew
//
//  Created by Ольга Лемешева on 08.11.2021.
//

import Foundation


protocol ProductsManagerProtocol {
    func loadContent() -> [Product]
}

class ProductsManager: ProductsManagerProtocol {
    static let shared: ProductsManagerProtocol = ProductsManager()
    
    private init() {}
    
    func loadContent() -> [Product] {
        return [
            Product(name: "Corona", categories: "Light, Mexica", price: "20$", isFavourite: true, iconUrl: URL(string: "https://lh3.googleusercontent.com/proxy/VQMcVvLLpqAOZQeBPlr0--PPAOnWUquaMVm_6VTQr12fn71Kzh0NxElScYXQ8kuL68rYjYAsSdYzClqNUOjeRnVyPCnQUW_xOugyEJzhXounTNLU_7L1t2gUxUWy")),
            Product(name: "Corona", categories: "Light, Mexica", price: "20$", isFavourite: true, iconUrl: URL(string: "https://lh3.googleusercontent.com/proxy/VQMcVvLLpqAOZQeBPlr0--PPAOnWUquaMVm_6VTQr12fn71Kzh0NxElScYXQ8kuL68rYjYAsSdYzClqNUOjeRnVyPCnQUW_xOugyEJzhXounTNLU_7L1t2gUxUWy")),
            Product(name: "Corona", categories: "Light, Mexica", price: "20$", isFavourite: true, iconUrl: URL(string: "https://lh3.googleusercontent.com/proxy/VQMcVvLLpqAOZQeBPlr0--PPAOnWUquaMVm_6VTQr12fn71Kzh0NxElScYXQ8kuL68rYjYAsSdYzClqNUOjeRnVyPCnQUW_xOugyEJzhXounTNLU_7L1t2gUxUWy")),
            Product(name: "Corona", categories: "Light, Mexica", price: "20$", isFavourite: true, iconUrl: URL(string: "https://lh3.googleusercontent.com/proxy/VQMcVvLLpqAOZQeBPlr0--PPAOnWUquaMVm_6VTQr12fn71Kzh0NxElScYXQ8kuL68rYjYAsSdYzClqNUOjeRnVyPCnQUW_xOugyEJzhXounTNLU_7L1t2gUxUWy")),
            Product(name: "Corona", categories: "Light, Mexica", price: "20$", isFavourite: true, iconUrl: URL(string: "https://lh3.googleusercontent.com/proxy/VQMcVvLLpqAOZQeBPlr0--PPAOnWUquaMVm_6VTQr12fn71Kzh0NxElScYXQ8kuL68rYjYAsSdYzClqNUOjeRnVyPCnQUW_xOugyEJzhXounTNLU_7L1t2gUxUWy")),
            Product(name: "Corona", categories: "Light, Mexica", price: "20$", isFavourite: true, iconUrl: URL(string: "https://lh3.googleusercontent.com/proxy/VQMcVvLLpqAOZQeBPlr0--PPAOnWUquaMVm_6VTQr12fn71Kzh0NxElScYXQ8kuL68rYjYAsSdYzClqNUOjeRnVyPCnQUW_xOugyEJzhXounTNLU_7L1t2gUxUWy")),
            Product(name: "Corona", categories: "Light, Mexica", price: "20$", isFavourite: true, iconUrl: URL(string: "https://lh3.googleusercontent.com/proxy/VQMcVvLLpqAOZQeBPlr0--PPAOnWUquaMVm_6VTQr12fn71Kzh0NxElScYXQ8kuL68rYjYAsSdYzClqNUOjeRnVyPCnQUW_xOugyEJzhXounTNLU_7L1t2gUxUWy")),
            Product(name: "Corona", categories: "Light, Mexica", price: "20$", isFavourite: true, iconUrl: URL(string: "https://lh3.googleusercontent.com/proxy/VQMcVvLLpqAOZQeBPlr0--PPAOnWUquaMVm_6VTQr12fn71Kzh0NxElScYXQ8kuL68rYjYAsSdYzClqNUOjeRnVyPCnQUW_xOugyEJzhXounTNLU_7L1t2gUxUWy")),
            Product(name: "Corona", categories: "Light, Mexica", price: "20$", isFavourite: true, iconUrl: URL(string: "https://lh3.googleusercontent.com/proxy/VQMcVvLLpqAOZQeBPlr0--PPAOnWUquaMVm_6VTQr12fn71Kzh0NxElScYXQ8kuL68rYjYAsSdYzClqNUOjeRnVyPCnQUW_xOugyEJzhXounTNLU_7L1t2gUxUWy")),
            Product(name: "Corona", categories: "Light, Mexica", price: "20$", isFavourite: true, iconUrl: URL(string: "https://lh3.googleusercontent.com/proxy/VQMcVvLLpqAOZQeBPlr0--PPAOnWUquaMVm_6VTQr12fn71Kzh0NxElScYXQ8kuL68rYjYAsSdYzClqNUOjeRnVyPCnQUW_xOugyEJzhXounTNLU_7L1t2gUxUWy"))
        ]
    }
}
