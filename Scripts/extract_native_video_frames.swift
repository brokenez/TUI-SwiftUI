import Foundation
import AVFoundation
import CoreImage
import AppKit

// macOS helper: decode XCTest's native recording without retiming its frames.
// Usage: swift Scripts/extract_native_video_frames.swift video output start end
let arguments = CommandLine.arguments
guard arguments.count == 5, let start = Double(arguments[3]), let end = Double(arguments[4]), end > start else {
    fputs("Usage: swift Scripts/extract_native_video_frames.swift VIDEO OUTPUT START_SECONDS END_SECONDS\n", stderr)
    exit(2)
}

do {
    let asset = AVURLAsset(url: URL(fileURLWithPath: arguments[1]))
    guard let track = try await asset.loadTracks(withMediaType: .video).first else {
        throw NSError(domain: "NativeVideoFrames", code: 1, userInfo: [NSLocalizedDescriptionKey: "Video track is missing"])
    }
    let reader = try AVAssetReader(asset: asset)
    let output = AVAssetReaderTrackOutput(track: track,
        outputSettings: [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA])
    reader.add(output)
    let context = CIContext()
    let target = URL(fileURLWithPath: arguments[2], isDirectory: true)
    try FileManager.default.createDirectory(at: target, withIntermediateDirectories: true)
    var frames: [[String: Any]] = []
    var index = 0
    guard reader.startReading() else {
        throw reader.error ?? NSError(domain: "NativeVideoFrames", code: 2)
    }
    while let sample = output.copyNextSampleBuffer() {
        let time = CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sample))
        if time >= start && time <= end, let buffer = CMSampleBufferGetImageBuffer(sample) {
            let image = CIImage(cvPixelBuffer: buffer)
            if let cg = context.createCGImage(image, from: image.extent),
               let png = NSBitmapImageRep(cgImage: cg).representation(using: .png, properties: [:]) {
                let filename = String(format: "frame-%05d.png", index)
                try png.write(to: target.appendingPathComponent(filename))
                frames.append(["time": time, "path": filename, "width": cg.width, "height": cg.height])
            }
        }
        index += 1
    }
    if reader.status == .failed { throw reader.error ?? NSError(domain: "NativeVideoFrames", code: 3) }
    let json = try JSONSerialization.data(withJSONObject: frames, options: [.prettyPrinted, .sortedKeys])
    try json.write(to: target.appendingPathComponent("frames.json"))
    print("Decoded \(index) native frames; exported \(frames.count).")
} catch {
    fputs("Cannot decode native recording: \(error.localizedDescription)\n", stderr)
    exit(1)
}
