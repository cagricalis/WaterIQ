import Foundation
import SwiftUI

struct MineralWaterBrand: Identifiable, Codable {
    var id: String { barcode }

    let name: String
    let imageName: String
    let qualityScore: Int
    let ph: Double?
    let tds: Double?
    let pfas: String?
    let fluoride: Double?
    let microplastics: String?
    let packaging: String?
    let sourceType: String?
    let description: String?
    let barcode: String

    // Mineraller
    let kalsiyum: String?
    let magnezyum: String?
    let sodyum: String?
    let potasyum: String?
    let bikarbonat: String?
    let sulfat: String?
    let klorur: String?
    let florur: String?

    // Kimyasal bileşenler
    let arsenik: String?
    let kursun: String?
    let nitrat: String?
    let nitrit: String?
    let bor: String?
    let amonyum: String?
    let kadmiyum: String?
    let nikel: String?
    let aluminyum: String?

    // Radyoaktif bileşenler
    let trityum: String?
    let alfa: String?
    let beta: String?

    // Ruhsat bilgileri
    let il: String?
    let ilce: String?
    let numuneAlanBirim: String?
    let analizYapanBirim: String?
    let ruhsatNo: String?


}
