

# 셀터뷰 Selterview
<!---- 배너 이미지 추가 ---->
 'Selterview'는 Self + Interview로 혼자서도 인터뷰 연습을 할 수 있도록 도와주는 iOS Application 입니다.
 <br/>
 <br/>


 </div>
<br/>
<br/>

## 📱 Features

### 1. 카테고리 및 질문 등록
   \- 사용자가 직접 연습이 필요한 카테고리를 생성해 해당 카테고리와 연관된 질문들을 등록할 수 있습니다.<br/>
   \- 등록한 질문들을 카테고리 별로 확인할 수 있습니다.<br/>
   \- 직접 연습하고 싶은 질문을 선택할 수 있고 랜덤 질문을 받을 수 있습니다.

### 2. 질문에 대한 답변 정리 및 꼬리질문 활용
   \- 질문에 대한 답변을 텍스트로 적어 정리할 수 있습니다.<br/>
   \- 답변을 활용하여 예상 꼬리질문을 생성할 수 있습니다.

<br/>
 
## 🖼 Screenshot



## 🛠 Development

### Tech Skills

<img width="80" alt="SwiftUI" src="https://img.shields.io/badge/SwiftUI-9cf">  <img width="90" alt="Combine" src="https://img.shields.io/badge/Combine-DBCFC1">


### Libraries
<img width="200" alt="Composable Architecture" src="https://img.shields.io/badge/Composable Architecture-blueviolet">  <img width="75" alt="ChatGPT" src="https://img.shields.io/badge/ChatGPT-ff69b4">  <img width="60"  alt="Realm" src="https://img.shields.io/badge/Realm-yellow">

### Environment

<img width="85" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://img.shields.io/badge/iOS-15.0+-silver">  <img width="95" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://img.shields.io/badge/Xcode-15.1-blue">

### Project Structure

```
Selterview
    |
    ├── Resources
    │       ├── Assets.xcassets       
    │       ├── Selterview++Bundle
    │       ├── API_Key  
    │
    ├── Sources
    │       ├── SelterviewApp
    │       ├──                  
    │       ├── Presentation
    |       │       ├── Main
    |       |       │     ├── MainReducer
    |       |       │     └── View
    |       │       │
    |       │       ├── Problem
    |       |       │       ├── ProblemReducer
    |       |       │       ├── Client
    |       │       │       └── View
    |       │       │
    |       │       ├── Common
    |       |       │       ├── Modifier
    |       |       │       └── View
    |       |
    │       ├── Model
    │       └── Extensions
    │
    └── Info.plist
```

<br/>
