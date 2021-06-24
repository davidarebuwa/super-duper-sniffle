//
//  ScanView+CoreML.swift
//  BeamDemo
//
//  Created by Tiana  on 23/02/2021.
//

import UIKit
import CoreML
import Vision

extension ScanView {
    func performCoreML() {
        predictionQueue.async {
            //are we already performing predictions?
            guard !self.isPerformingCoreML else { return }
            guard let imageBuffer = self.sceneView.session.currentFrame?.capturedImage else { return }
            self.isPerformingCoreML = true
            let handler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, options: [:])
            let request = self.coreMLRequest()
            do {
                try handler.perform([request])
            } catch {
                print(error)
                self.isPerformingCoreML = false
            }

        }
    }
    
    func coreMLRequest() -> VNCoreMLRequest {
        let request = VNCoreMLRequest(model: model, completionHandler: { (request, _) in

            guard let bestResult = request.results?.first as? VNRecognizedObjectObservation else {
                self.isPerformingCoreML = false
                return
            }
            

            DispatchQueue.main.async {

                print("coreMlRequest: \(String(describing: bestResult.labels.first?.identifier)), \(String(describing: bestResult.labels.first?.confidence))")
                self.bubbleName = bestResult.labels.first?.identifier ?? "no object detected"

                self.isDetected = true
            }

            if bestResult.confidence < 0.3 {
                self.isPerformingCoreML = false
                return
            }

            if self.isFirstOrBestResult(result: bestResult) {
                self.latestResult = bestResult
                self.hitTest()
            }

            self.isPerformingCoreML = false
        })

        request.preferBackgroundProcessing = true
        request.imageCropAndScaleOption = .scaleFill

        return request

    }


func pauseCoreML() {
    if isPerformingCoreML {
        predictionQueue.suspend()
        isPerformingCoreML = !isPerformingCoreML
    } else {
        predictionQueue.resume()
    }
}

//check if the object prediction has improved
private func isFirstOrBestResult(result: VNRecognizedObjectObservation) -> Bool {
    for bubble in bubbles {
        guard let previousResults = bubble.objectObservation else { continue }
        if previousResults.labels.first?.identifier == result.labels.first?.identifier {
            //When the result is more confident, remove the previous
            if previousResults.confidence < result.confidence {

                if let  index = bubbles.firstIndex(of: bubble) {
                    bubbles.remove(at: index)
                }
                bubble.removeFromParentNode()

                resetBubbles()
                return true
            }
            //previous result had a better confidence
            return false
        }
    }
    //first result is better
    return true
}

}
