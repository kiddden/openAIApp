# openAIApp

An app that allows you to try OpenAI text completions and image generation features using simple iOS app.

### Warning

Despite the fact that the widely known ChatGPT was also made by OpenAI company, still the AI you will be using in this app is not exactly the same, but still smart enough.

## Getting Started

In order to make this app running, you should finish a couple of steps:
- Create OpenAI account;
- Generate private API key on OpenAI website;
- In the project, navigate to "openAIapp - Services - OpenAIService.swift" and change the empty APIKey field to your own.
```swift
class OpenAIService {
    
    private let baseURL = "https://api.openai.com/v1/"
    private let APIKey = "YOUR API KEY GOES HERE"
   
    ...
}
```

## Built With

* [UIKit](https://developer.apple.com/documentation/uikit) - The main framework app built with
* [SwiftUI](https://developer.apple.com/xcode/swiftui/) - The framework that was used to build 'Chat'(text completions) screen
* [Alamofire](https://github.com/Alamofire/Alamofire) - The framework for making API calls
* [Combine](https://developer.apple.com/documentation/combine) - The framework for reactive programming

## To-do
#### Chat screen
- [x] ~~Live communication with model~~
- [x] ~~Error handling with alerts~~ 
- Settings section with ability to change model of completions and temperature(changing the determinacy of answers of the AI)
- Saving the chat history
- Ability to create multiple chat sessions

#### Image generation screen
- [x] ~~Generating images~~ 
- [x] ~~Error handling with alerts~~ 
- Saving\sharing images
- Ability to generate more than one image at once

#### Overall
- [x] ~~Dark theme~~
