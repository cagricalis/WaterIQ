import Foundation
import SwiftUI

struct WaterBrand: Identifiable, Codable {
    var id: String { barcode }

    let name: String
    let imageName: String
    let qualityScore: Int
    let ph: Double?
    let tds: Double?
    let pfas: String?
    let fluoride: Double?
    let microplastics: String?
    let packaging: String? // “Glass”, “PET” vb.
    let sourceType: String? // “Natural”, “Purified” vb.
    let hardness: Double?
    let minerals: String?
    let description: String?
    let barcode: String

    // Bakteriyolojik
    let eColi: String?
    let enterokok: String?
    let cPerfringens: String?
    let koloni22: String?
    let koloni37: String?
    let koliform: String?
    let fekalKoliform: String?
    let pAeruginosa: String?
    let fekalStreptokok: String?
    let sulfReducing: String?
    let totalJerm: String?
    let parazitler: String?
    let digerPatojenler: String?

    // Kimyasal
    let akrilamid: String?
    let aluminyum: String?
    let antimon: String?
    let arsenik: String?
    let benzen: String?
    let benzoApyren: String?
    let baryum: String?
    let bor: String?
    let borat: String?
    let bromat: String?
    let civA: String?
    let fosfat: String?
    let amonyum: String?
    let kadmiyum: String?
    let krom: String?
    let kursun: String?
    let nikel: String?
    let nitrat: String?
    let nitrit: String?
    let selenyum: String?
    let siyanur: String?
    let dikloretan: String?
    let epikloridin: String?
    let tetrakloretan: String?
    let trihalometan: String?
    let vinilKlorur: String?
    let pestisitler: String?
    let pah: String?

    // Radyoaktif
    let trityum: String?
    let alfa: String?
    let beta: String?

    // Diğer
    let florur: String?
    let bikarbonat: String?
    let il: String?
    let ilce: String?
    let numuneAlanBirim: String?
    let analizYapanBirim: String?
    let ruhsatNo: String?


}
