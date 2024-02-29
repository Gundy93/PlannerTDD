# 📅 플래너 TDD

`To do`, `Doing`, `Done`의 3 가지 상태로 계획을 관리하는 플래너 앱입니다.

기존 iPad용 프로젝트인 [ios-project-manager](https://github.com/Gundy93/ios-project-manager)를 iPhone용으로 리팩토링한 프로젝트입니다.

## 📚 목차

- [🔑 **키워드**](#-키워드)
- [🏗️ **앱 구조**](#-앱-구조)
- [📱 **실행 화면**](#-실행-화면)
- [❤️‍🩹 **트러블 슈팅**](#-트러블-슈팅)
- [💭 **이유 있는 코드**](#-이유-있는-코드)

## 🔑 키워드

- **MVVM** + **Clean Architecture**
- **Unit Test**
- **P**rotocol **O**riented **P**rogramming

[⬆️ 목차로 돌아가기](#-목차)

## 🏗️ 앱 구조

### MVVM + Clean Architecture

Cocoa MVC보다 테스터블한 코드를 만들고자 했기 때문에 뷰와 로직을 완전히 분리시킬 수 있는 MVVM을 선택하였습니다.

또한 레이어를 나누고 의존성 방향의 규칙을 지키는 선에서 Clean Architecture를 적용하면 테스터블함은 물론이고 OCP 등의 객체 지향 원칙들을 더욱 잘 준수할 수 있으리라 생각해 같이 적용하기로 하였습니다.

### Unit Test

이번 프로젝트의 아키텍처 선정 사유중 가장 중요한 부분이 테스터블함이기 때문에 모든 기능에 대해 Unit Test를 실시하는 것을 목표로 하였습니다.

### Protocol Oriented Programming

프로토콜과 값 타입을 사용해 프로토콜 지향으로 개발을 하면 클래스를 사용한 객체 지향보다 여러 성능적인 이점을 얻을 수 있습니다. 이번 프로젝트에서는 애플에서 적극 권장하는 POP를 토대로 개발을 진행하는 것을 목표로 합니다.

[⬆️ 목차로 돌아가기](#-목차)

## 📱 실행 화면

// 실행 화면

[⬆️ 목차로 돌아가기](#-목차)

## ❤️‍🩹 트러블 슈팅

### // 트러블 제목

// 트러블 내용

[⬆️ 목차로 돌아가기](#-목차)

## 💭 이유 있는 코드

### setUpWithError, tearDownWithError의 super 호출

[setUpWithError()](https://developer.apple.com/documentation/xctest/xctest/3521150-setupwitherror), [tearDownWithError()](https://developer.apple.com/documentation/xctest/xctest/3521151-teardownwitherror)의 공식문서에서는 `super`에 대한 언급이 없습니다. 이런 경우 Xcode나 공식문서로는 내부 구현을 알지 못하고, `override`이기 때문에 리스코프 치환 원칙 등을 고려해 `super` 호출을 합니다. 하지만 이번에는 '꼭 `super` 호출을 해야하는가?' 하는 생각이 들어 여러 방면으로 알아보았습니다.

![스크린샷 2024-02-08 오후 3.53.39](https://hackmd.io/_uploads/rygt5eMop.png)

Apple에서 깃헙에 공개한 코드를 보면 각 메서드는 내부가 빈 구현이기 때문에 `supre`를 호출하지 않는 것으로 결정하였습니다.

### Domain의 Entity와 Presentation에서 쓰는 타입 분리

Clean Architecture의 레이어 구분에서, 외부 레이어의 변경사항으로 인해 내부 레이어까지 수정하면 안 된다고 생각합니다.

```swift
// Domain의 Plan 구조체
struct Plan: Identifiable, Hashable {
    
    let id: UUID
    var title: String
    var deadline: Date
    var description: String
    var state: State
}

// Presentation의 Content 구조체
struct Content: Hashable {
    
    let title: String
    let description: String
    let deadline: String
    let isOverdue: Bool
    let id: UUID
}
```

그래서 저는 Domain의 `Plan`을 매핑하여 `Content`로 만들어서 사용하고 있습니다. 이미 `Plan`과 다른 부분도 있고, 화면에 보여져야하는 항목이 변경되더라도 이 `Content`만 수정하면 Domain 레이어를 손보지 않아도 가능하다고 생각했습니다.

### ViewModel Protocol

MVVM 아키텍처에서 뷰모델은 뷰와 1:N으로 연결될 수 있습니다. 특히 목록과 상세로 이어지는 이번 프로젝트의 경우 더욱 1:N으로 연결하기에 적합하다고 생각합니다. 관련 기능이 모여있기 때문입니다.

```swift
// 목록 관련 기능 요구사항
protocol ListViewModel: AnyObject { ... }

// 상세 관련 기능 요구사항
protocol DetailViewModel: AnyObject { ... }

// 뷰모델
final class PlannerViewModel: ListViewModel, DetailViewModel { ... }

// 목록 화면을 보여주는 뷰컨트롤러
final class PlanListViewController: UIViewController {
    private let viewModel: ListViewModel
    ...
}

// 상세 화면을 보여주는 뷰컨트롤러
final class PlanDetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    ...
}
```

이로 인해 각 뷰컨트롤러는 자신이 알아야 하는 만큼만 뷰모델에 대해 알 수 있게 구현할 수 있었습니다. 또한 POP에 적합한 방식이라고 생각했습니다.

[⬆️ 목차로 돌아가기](#-목차)
