<a name="readme-top"></a>


<!-- PROJECT LOGO -->
<br />
<div align="center">
<!--  <a href="https://github.com/github_username/repo_name">-->
<!--    <img src="images/logo.png" alt="Logo" width="80" height="80">-->
<!--  </a>-->

<h3 align="center">EEN Two Way Audio iOS SDK </h3>
</div>


## Introduction

The Eagle Eye Networks 2-Way Audio iOS SDK is a wrapper for the communication between a client (ie. iOS app) and the 2-Way Audio Signaling Services using WebRTC. Developers can use the exposed methods to easily establish and disconnect sessions.

This SDK makes it possible to send and receive audio to the speakers available on the account.


## Initial requirements

Below are required for working with the 2-Way Audio SDK for iOS:

* Add the following to your podfile:

```sh
  pod 'EEN-Two-Way-Audio-iOS-SDK'
  pod 'GoogleWebRTC'
  pod 'SocketRocket'
```

* Add microphone permission description usage into the app info.plist:

```sh
  NSMicrophoneUsageDescription
```

```sh
  :construction: The SDK does not support bitcode since it has a dependency on GoogleWebRTC. :construction:
```

In order to be able to use the 2-Way Audio feature the account should have the following already

* For any API call you should already be logged in and have access token available to authenticate the API calls
* The account should have a camera that is associated with the speaker
* The bridge version should be 3.8.0 or higher as well as current camera support drivers

```sh
  :construction: 
  * When a speaker device is detectable by more than one bridge, all bridges must support using the speaker. They all need bridge version 3.8.0 or higher as well as current camera-support drivers. Contact Eagle Eye Support for help getting the latest version.
  * The maximum length of an audio session is 10 minutes. After 10 minutes session will be disconnected.
  :construction:
```

cameras API response will have "speakerId" value for all cameras with associated speakers. Below is an example response from cameras API with associated speaker:
```sh
  {
      "nextPageToken": "",
      "prevPageToken": "",
      "totalSize": 12,
      "results": [ 
         {
              "id": "1002c1f6",
              "accountId": "00032511",
              "name": "testNormalCam",
              "bridgeId": "1003171a",
              "locationId": "7803a2f4-32a8-43ff-816d-eb8c03cb739f",
              "speakerId": "100ea79e"
          },
       ]
  }
```


## Steps to implement 2-Way Audio

### Step 1: Get webRTC Url
Get the WebRTC URL, device esn and media type using the feeds API API.

```sh
  curl --location --request GET '<baseUrl>/api/v3.0/feeds?deviceId=1002c1f6&type=talkdown&include=webRtcUrl' \
  --header 'Accept: application/json' \
  --header 'Authorization: Bearer <access token>'
```

```sh
  {
      "nextPageToken": "",
      "prevPageToken": "",
      "results": [
          {
              "id": "1002c1f6-talkdown",
              "type": "talkdown",
              "mediaType": "halfDuplex",
              "webRtcUrl": "wss://edge.c013.eagleeyenetworks.com"
          }
      ]
  }
```

### Step 2: Initialize the SDK
Initialize the TwoWayAudioClient with a TwoWayAudioModel:

```sh
  self.twoWayAudioClient = TwoWayAudioClient(with: TwoWayAudioModel.init(webRtcUrl: twoWayAudioInfo.webRtcUrl,
                                                                         sourceID: twoWayAudioInfo.deviceId,
                                                                         type: .talkdown,
                                                                         mediaType: .halfDuplex,
                                                                         authKey: authCookie.value),
                                             delegate: self)
```

### Step 3: Implement delegate

```sh
  func twoWayAudioClient(_ twoWayAudioClient: TwoWayAudioClient, didChangeConnectionState status: TwoWayAudioStatus) {
      switch status {
      case .initial:
          break
          
      case .disconnected(let reason):
          switch reason {
          case .manual:
              // handle the UI for the disconnected state
              audioButton.setDisconnectedState()
              
          case .noPermissions:
              // handle the UI for the disconnected state
              audioButton.setDisconnectedState()
              
              // show user friendly message to the user
              showToast(with: "EnableMicrophone".localized)
              
          case .error(let message):
              // handle the UI for the error state
              audioButton.setErrorState()
              showToast(with: message.localized)
              
          @unknown default:
              break
          }
          
      case .connecting:
          // handle the UI for the loading state
          audioButton.setLoadingState()
          
      case .connected:
          // handle the UI for the connected state
          audioButton.setConnectedState()

      default:
          break
      }
  }
    
  func twoWayAudioClient(_ twoWayAudioClient: TwoWayAudioClient, didChangeAmplitude amplitude: Double) {
      // handle amplitude audio level
  }
```

### Step 4: Connect
To establish the webRTC connection, just call the connect() method and wait for the delegate method to return you either the connected or error state.

```sh
  twoWayAudioClient.connect()
```

### Step 5: Disconnect
To close the webRTC connection, just call the disconnect() method and wait for the delegate method to return you the disconnected state.

```sh
  twoWayAudioClient.disconnect()
```

## Methods and Models

### Models
To initialize the sdk you need to provide the following model:

```sh
  struct TwoWayAudioModel {
      let webRtcUrl: URL
      let sourceID: String
      let type: TwoWayAudioTypes
      let mediaType: TwoWayAudioMediaType
      let authKey: String
  }

  public enum TwoWayAudioTypes: String {
      case talkdown
  }

  public enum TwoWayAudioMediaType: String {
      case halfDuplex
  }
```

The twoWayAudio sdk can be in one of the self explaining states:

```sh
  enum TwoWayAudioStatus: Equatable {
      case initial
      case disconnected(reason: TwoWayAudioDisconnectReasons)
      case connecting
      case connected
  }

  public enum TwoWayAudioDisconnectReasons: Equatable {
      case manual
      case noDeviceAudioPermissions /// update the name
      case error(error: TwoWayAudioErrorType)
  }

  public enum TwoWayAudioErrorType: Equatable {
      case busy
      case timeout
      case generic(error: ErrorObjectFromVMS)
  }
```

### Methods
The SDK provides the following methods

```sh
  public func connect()
```

This method will start an audio session:
* It will start the connection with the signaling server.
* Once the connection is established, it will authorize it.
* Once the connection is authorized, it will request the Ice Servers.
* Once we receive the Ice Servers, the webRTC client will send an offer to the server.
* Once the offer is sent, we expect an answer from the server and the session will be created.

```sh
  public func disconnect()
```

This method will disconnect Signaling and webRTC clients and clean the memory.

```sh
  public func disconnect()
```

Set mute/unmute to send/stop sending the audio data.


### Delegates
The SDK provides the following delegate methods:

```sh
  func twoWayAudioClient(_ twoWayAudioClient: TwoWayAudioClient, didChangeConnectionState status: TwoWayAudioStatus)
```

This method allows the developer to keep track of all the connection status updates.

```sh
  func twoWayAudioClient(_ twoWayAudioClient: TwoWayAudioClient, didChangeAmplitude amplitude: Double)
```

This method allows the developer to keep track of microphone amplitude value, allowing to implement synchronized animations.


<!-- LICENSE -->
## License

Fill license here

<p align="right">(<a href="#readme-top">back to top</a>)</p>

