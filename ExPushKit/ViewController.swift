//
//  ViewController.swift
//  ExPushKit
//
//  Created by Jake.K on 2022/02/10.
//

import UIKit
import CallKit
import PushKit

class ViewController: UIViewController {
  let provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "jake"))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let registry = PKPushRegistry(queue: nil)
    registry.delegate = self
    registry.desiredPushTypes = [PKPushType.voIP]
  }
}

extension ViewController: CXProviderDelegate {
  func providerDidReset(_ provider: CXProvider) {
  }
  
  func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
    action.fulfill()
  }
  
  func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
    action.fulfill()
  }
}

extension ViewController: PKPushRegistryDelegate {
  func pushRegistry(
    _ registry: PKPushRegistry,
    didUpdate pushCredentials: PKPushCredentials,
    for type: PKPushType
  ) {
    print(pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
  }
  
  func pushRegistry(
    _ registry: PKPushRegistry,
    didReceiveIncomingPushWith payload: PKPushPayload,
    for type: PKPushType, completion: @escaping () -> Void
  ) {
    self.provider.setDelegate(self, queue: nil)
    let update = CXCallUpdate()
    update.remoteHandle = CXHandle(type: .generic, value: "jake")
    update.hasVideo = false
    self.provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
  }
}
