import SwiftUI

struct WaterDetailView: View {
    let brand: WaterBrand

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(brand.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                
                Text(brand.name)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                
                HStack {
                    Text("Quality Score:")
                        .font(.headline)
                    Text("\(brand.qualityScore)/100")
                        .font(.headline)
                        .foregroundColor(brand.qualityColor)
                }
                .padding(.horizontal)
                
                if let ph = brand.ph {
                    Text("pH: \(ph, specifier: "%.1f")")
                        .padding(.horizontal)
                }
                
                if let hardness = brand.hardness {
                    Text("Hardness: \(hardness) ppm")
                        .padding(.horizontal)
                }
                
                if let minerals = brand.minerals {
                    Text("Minerals: \(minerals)")
                        .padding(.horizontal)
                }
                
                if let description = brand.description {
                    Text(description)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }
                
                Spacer()
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
