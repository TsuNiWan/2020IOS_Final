//
//  BusFavorite.swift
//  Final
//
//  Created by 林子平 on 2020/6/21.
//  Copyright © 2020 林子平. All rights reserved.
//

import Foundation
import Combine

class BusFavorite: ObservableObject {
    @Published var bus = [BusFavoriteData]()
    var cancellable: AnyCancellable?
    
    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let url = documentsDirectory.appendingPathComponent("myFavoriteBus")
        
        if let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([BusFavoriteData].self, from: data) {
                bus = decodedData
            }
        }
        
        cancellable = $bus
            .sink { (value) in
                let encoder = JSONEncoder()
                do {
                    let data = try encoder.encode(value)
                    try? data.write(to: url)
                } catch {
                    
                }
        }
    }
}
