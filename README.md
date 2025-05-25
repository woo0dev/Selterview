

# 셀터뷰 Selterview
<!---- 배너 이미지 추가 ---->
 'Selterview'는 Self + Interview로 혼자서도 인터뷰 연습을 할 수 있도록 도와주는 iOS Application 입니다.

 </div>

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
### 메인화면
<img width="200" src="https://github.com/user-attachments/assets/fc7abf90-2642-4b08-9360-d6216f464bea">
<img width="200" src="https://github.com/user-attachments/assets/752766bc-7019-4b88-bfef-d5be5a071f2a">

### 질문 추가 화면
<img width="200" src="https://github.com/user-attachments/assets/c8093b63-12e5-4867-afab-e65e182d67cf">
<img width="200" src="https://github.com/user-attachments/assets/b80d879b-1c70-446f-b866-e70776ed091c">
<img width="200" src="https://github.com/user-attachments/assets/cf691b03-0c5c-4073-abf7-6357a6fe17e9">

### 질문 화면
<img width="200" src="https://github.com/user-attachments/assets/ad327874-a511-4842-accb-137fb5250233">
<img width="200" src="https://github.com/user-attachments/assets/f7faa375-231b-4989-8e3b-3ded21d3b338">
<img width="200" src="https://github.com/user-attachments/assets/52b58ab2-49e3-4dd2-8aa5-5362d550ae3f">
<img width="200" src="https://github.com/user-attachments/assets/c32d39a6-e582-4579-9636-b283f1278291">





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
    │       │                  
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
    |       │       └── Common
    |       |               ├── Modifier
    |       |               └── View
    |       |
    │       ├── Model
    │       └── Extensions
    │
    └── Info.plist
```

<br/>
