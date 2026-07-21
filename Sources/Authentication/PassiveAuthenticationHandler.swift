//  Xác minh toàn vẹn dữ liệu bằng cách Hash lại
//  nội dung của các Data Group và đối chiếu với mã Hash được lưu trữ trong EF.SOD

import Foundation
import CryptoKit

@available(iOS 13, *)
public class PassiveAuthenticationHandler {
    public static func verifyDataIntegrity(sod: SOD, rawDataGroups: [DataGroupId: [UInt8]]) throws {
        
        print("[PassiveAuth] Bắt đầu xác thực vẹn toàn dữ liệu với \(rawDataGroups.count) Data Groups...")
        print("[PassiveAuth] Thuật toán băm theo SOD (OID): \(sod.hashAlgorithmOid) - \(HashAlgorithmOID.algorithmName(for: sod.hashAlgorithmOid))")
        
        for (dgId, rawBytes) in rawDataGroups {
            // Lấy Hash chuẩn từ SOD
            guard let expectedHash = sod.dataGroupHashes[dgId] else {
                print("[PassiveAuth] Cảnh báo: \(dgId) không có mã Hash trong SOD để đối chiếu.")
                continue
            }
            
            // Tính toán lại Hash từ rawBytes
            let calculatedHash = calculateHash(data: rawBytes, algorithmOID: sod.hashAlgorithmOid, expectedHashLength: expectedHash.count)
            
            // Đối chiếu
            if calculatedHash == expectedHash {
                print("[PassiveAuth] \(dgId): Tính toàn vẹn được xác nhận. (Khớp Hash)")
            } else {
                print("[PassiveAuth] \(dgId): PHÁT HIỆN DỮ LIỆU BỊ THAY ĐỔI!")
                print("  - Expected : \(expectedHash.map { String(format: "%02x", $0) }.joined())")
                print("  - Calculated: \(calculatedHash.map { String(format: "%02x", $0) }.joined())")
                throw NFCReaderError.responseError("Passive Auth Thất Bại: Dữ liệu \(dgId) đã bị chỉnh sửa!")
            }
        }
        
        print("[PassiveAuth] Hoàn tất! Toàn bộ dữ liệu đều nguyên bản và an toàn.")
    }
    
    private static func calculateHash(data: [UInt8], algorithmOID: String, expectedHashLength: Int) -> [UInt8] {
            let inputData = Data(data)
     
            switch algorithmOID {
            case HashAlgorithmOID.sha1:
                return Array(Insecure.SHA1.hash(data: inputData))
            case HashAlgorithmOID.sha256:
                return Array(SHA256.hash(data: inputData))
            case HashAlgorithmOID.sha384:
                return Array(SHA384.hash(data: inputData))
            case HashAlgorithmOID.sha512:
                return Array(SHA512.hash(data: inputData))
            case HashAlgorithmOID.sha224:
                print("[PassiveAuth] Cảnh báo: SHA-224 chưa được CryptoKit hỗ trợ trực tiếp, dùng fallback theo độ dài.")
                return calculateHashByLength(data: inputData, expectedHashLength: expectedHashLength)
            default:
                print("[PassiveAuth] Cảnh báo: OID thuật toán băm '\(algorithmOID)' không nhận diện được, dùng fallback theo độ dài.")
                return calculateHashByLength(data: inputData, expectedHashLength: expectedHashLength)
            }
        }
     
        /// đoán thuật toán dựa vào độ dài hash mong đợi trong SOD.
        private static func calculateHashByLength(data: Data, expectedHashLength: Int) -> [UInt8] {
            switch expectedHashLength {
            case 20: // SHA-1
                return Array(Insecure.SHA1.hash(data: data))
            case 32: // SHA-256
                return Array(SHA256.hash(data: data))
            case 48: // SHA-384
                return Array(SHA384.hash(data: data))
            case 64: // SHA-512
                return Array(SHA512.hash(data: data))
            default:
                print("[PassiveAuth] Cảnh báo: Chiều dài Hash không chuẩn (\(expectedHashLength) bytes). Fallback SHA-256.")
                return Array(SHA256.hash(data: data))
            }
        }
}
