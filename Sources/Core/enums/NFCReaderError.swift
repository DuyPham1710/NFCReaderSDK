import Foundation

public enum NFCReaderError: Error, LocalizedError {
    case notSupported
    case userCanceled
    case timeout
    case connectionError
    case invalidMRZKey
    case tagNotValid
    case moreThanOneTagFound
    case responseError(String)
    case unknown(Error?)
    
    public var errorDescription: String? {
        localizedDescription(language: .current)

//        switch self {
//        case .notSupported:
//            return "Thiết bị không hỗ trợ đọc NFC (yêu cầu iPhone 7 trở lên, iOS 13+)."
//        case .userCanceled:
//            return "Người dùng đã huỷ phiên quét."
//        case .timeout:
//            return "Phiên quét đã hết thời gian chờ."
//        case .connectionError:
//            return "Không thể kết nối tới chip trên thẻ CCCD."
//        case .invalidMRZKey:
//            return "Thông tin MRZ (số CCCD/ngày sinh/ngày hết hạn) không hợp lệ."
//        case .tagNotValid:
//            return "Thẻ được phát hiện không phải là thẻ CCCD hợp lệ."
//        case .moreThanOneTagFound:
//            return "Phát hiện nhiều hơn 1 thẻ. Vui lòng chỉ để 1 thẻ CCCD gần iPhone!"
//        case .responseError(let msg):
//            return "Lỗi phản hồi từ chip: \(msg)"
//        case .unknown(let err):
//            return "Lỗi không xác định: \(err?.localizedDescription ?? "N/A")"
//        }
    }
    
    public func localizedDescription(language: NFCReaderLanguage) -> String {
        switch language {
        case .vi: return viDescription
        case .en: return enDescription
        }
    }
 
    private var viDescription: String {
        switch self {
        case .notSupported:
            return "Thiết bị không hỗ trợ đọc NFC (yêu cầu iPhone 7 trở lên, iOS 13+)."
        case .userCanceled:
            return "Người dùng đã huỷ phiên quét."
        case .timeout:
            return "Phiên quét đã hết thời gian chờ."
        case .connectionError:
            return "Không thể kết nối tới chip trên thẻ CCCD."
        case .invalidMRZKey:
            return "Thông tin MRZ (số CCCD/ngày sinh/ngày hết hạn) không hợp lệ."
        case .tagNotValid:
            return "Thẻ được phát hiện không phải là thẻ CCCD hợp lệ."
        case .moreThanOneTagFound:
            return "Phát hiện nhiều hơn 1 thẻ. Vui lòng chỉ để 1 thẻ CCCD gần iPhone!"
        case .responseError(let msg):
            return "Lỗi phản hồi từ chip: \(msg)"
        case .unknown(let err):
            return "Lỗi không xác định: \(err?.localizedDescription ?? "N/A")"
        }
    }
 
    private var enDescription: String {
        switch self {
        case .notSupported:
            return "NFC is not supported on this device (requires iPhone 7 or later, iOS 13+)."
        case .userCanceled:
            return "The user canceled the scan session."
        case .timeout:
            return "The scan session timed out."
        case .connectionError:
            return "Unable to connect to the chip on the ID card."
        case .invalidMRZKey:
            return "Invalid MRZ information (document number/date of birth/date of expiry)."
        case .tagNotValid:
            return "The detected tag is not a valid ID card."
        case .moreThanOneTagFound:
            return "More than one tag detected. Please keep only one ID card near the iPhone!"
        case .responseError(let msg):
            return "Error response from chip: \(msg)"
        case .unknown(let err):
            return "Unknown error: \(err?.localizedDescription ?? "N/A")"
        }
    }

    
}
