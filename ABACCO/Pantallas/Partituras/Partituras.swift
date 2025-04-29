//
//  Partituras.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 29/4/25.
//

import SwiftUI

struct Partituras: View {
    
    @StateObject var partituraViewModel: PartituraViewModel
    
    var body: some View {
        
        ScrollPartituras(partituraViewModel: partituraViewModel)
    }
}

#Preview {
    Partituras(partituraViewModel: PartituraViewModel())
}
