# 📱 133App - App Store 출시 체크리스트

## 📋 출시 전 필수 작업

### 1️⃣ 앱 정보 및 메타데이터 준비

#### 앱 기본 정보
- [ ] **앱 이름 확정**
  - 한글: "133" 또는 "하루 셋"
  - 영문: "133" 또는 "Three Daily Tasks"
  - 부제목 (최대 30자): 예) "하루 3가지 할일 실천 앱"

- [ ] **카테고리 선택**
  - 주 카테고리: 생산성 (Productivity)
  - 부 카테고리: 생활 (Lifestyle) 또는 자기계발

- [ ] **가격 정책 결정**
  - 무료 or 유료
  - 인앱 구매 계획 (선택사항)

- [ ] **연령 등급 확인**
  - 만 4세 이상 권장

#### 앱 설명 작성
- [ ] **앱 설명 (한국어)** - 최대 4,000자
  ```
  예시:
  
  🎯 하루 3가지만 집중하세요
  
  할일이 너무 많아 무엇부터 해야 할지 막막하신가요?
  133은 하루에 꼭 해야 할 3가지만 선택하게 해서
  집중력을 높이고 성취감을 느끼게 해줍니다.
  
  ✨ 주요 기능
  • 하루 3개만! 할일 관리
  • 집중 타이머로 몰입
  • 실시간 통계로 성장 확인
  • 알림으로 습관 만들기
  • 아름다운 디자인
  
  📊 당신의 성장을 추적하세요
  • 완료 개수 & 집중 시간
  • 연속 실천 일수
  • 주간 진행률
  • 완료율 통계
  
  ⏱️ 집중 타이머
  • 백그라운드에서도 정확한 시간 측정
  • 실제 작업 시간 자동 기록
  • 완료 시 축하 애니메이션
  
  🔔 스마트 알림
  • 매일 아침 알림
  • 저녁 리마인더
  • 타이머 완료 알림
  
  적게 하고, 잘하세요. 133과 함께라면 가능합니다! 💪
  ```

- [ ] **홍보 문구** - 최대 170자
  ```
  예시: "하루 3가지에만 집중하세요! 할일 관리, 집중 타이머, 통계로 당신의 성장을 지원합니다."
  ```

- [ ] **키워드** - 최대 100자, 쉼표로 구분
  ```
  예시: "할일,투두,생산성,집중,타이머,습관,목표,자기계발,시간관리,pomodoro"
  ```

- [ ] **지원 URL** (선택사항)
  - 개인 웹사이트 or GitHub 저장소

- [ ] **마케팅 URL** (선택사항)
  - 앱 소개 페이지

#### 스크린샷 준비 (필수!)
- [ ] **iPhone 6.7" (iPhone 15 Pro Max)** - 필수
  - 1290 x 2796 pixels
  - 3-10장 필요
  
- [ ] **iPhone 6.5" (iPhone 11 Pro Max)** - 필수
  - 1242 x 2688 pixels
  - 3-10장 필요

- [ ] **스크린샷 내용 추천**
  1. 홈 화면 (할일 목록)
  2. 할일 추가 화면
  3. 타이머 화면
  4. 통계 화면
  5. 설정 화면

- [ ] **앱 미리보기 비디오** (선택사항)
  - 15-30초
  - 주요 기능 시연

#### 앱 아이콘
- [ ] **App Icon 준비**
  - 1024 x 1024 pixels (App Store용)
  - 다양한 크기 자동 생성 확인
  - 투명도 없이, 정사각형
  - 권장: 단순하고 인식하기 쉬운 디자인

---

### 2️⃣ 개발자 계정 및 인증서 설정

- [ ] **Apple Developer Program 가입** ($99/년)
  - https://developer.apple.com/programs/

- [ ] **App ID 등록**
  - Bundle Identifier 설정
  - 예: `com.yourname.133app`

- [ ] **Certificates 생성**
  - iOS Distribution Certificate

- [ ] **Provisioning Profile 생성**
  - App Store Distribution Profile

- [ ] **Xcode에서 Signing 설정**
  - Team 선택
  - Automatically manage signing 체크 (권장)

---

### 3️⃣ 프로젝트 설정 확인

#### Info.plist 및 권한
- [ ] **알림 권한 설명 추가**
  ```xml
  <key>NSUserNotificationsUsageDescription</key>
  <string>할일 리마인더와 타이머 완료 알림을 위해 알림 권한이 필요합니다.</string>
  ```

- [ ] **사진 라이브러리 권한 설명** (프로필 이미지 기능 사용 시)
  ```xml
  <key>NSPhotoLibraryUsageDescription</key>
  <string>프로필 이미지를 설정하기 위해 사진 라이브러리 접근 권한이 필요합니다.</string>
  ```

- [ ] **앱 버전 확인**
  - Version: 1.0
  - Build: 1

- [ ] **지원 iOS 버전 설정**
  - Deployment Target: iOS 17.0 이상 권장

- [ ] **지원 기기 설정**
  - iPhone only or Universal (iPhone + iPad)

- [ ] **지원 방향 설정**
  - Portrait only 권장 (세로 모드만)

#### App Store Connect 연결
- [ ] **Bundle Identifier 확인**
  - Xcode의 Bundle ID와 App Store Connect의 Bundle ID 일치 확인

- [ ] **App Icon 등록**
  - Assets.xcassets에 AppIcon 세트 완성

---

### 4️⃣ 코드 품질 및 테스트

#### 필수 테스트
- [ ] **실제 기기 테스트**
  - iPhone 실물로 모든 기능 테스트
  - 다양한 화면 크기 확인

- [ ] **기능 테스트**
  - [ ] 할일 추가/편집/삭제
  - [ ] 할일 완료 토글
  - [ ] 타이머 시작/정지/리셋/완료
  - [ ] 백그라운드 타이머 정확도
  - [ ] 알림 수신 확인
  - [ ] 통계 데이터 정확성
  - [ ] 설정 저장/불러오기
  - [ ] 프로필 편집
  - [ ] 데이터 내보내기
  - [ ] 데이터 삭제

- [ ] **에지 케이스 테스트**
  - [ ] 빈 할일 목록
  - [ ] 3개 할일 추가 후 추가 시도
  - [ ] 매우 긴 제목/메모 입력
  - [ ] 타이머 0초 완료
  - [ ] 앱 강제 종료 후 재실행
  - [ ] 날짜 변경 (자정 넘기기)
  - [ ] 알림 권한 거부 시나리오
  - [ ] 메모리 부족 상황

- [ ] **성능 테스트**
  - [ ] 앱 실행 속도 (2초 이내)
  - [ ] 화면 전환 부드러움
  - [ ] 메모리 사용량 확인
  - [ ] 배터리 소모 확인 (타이머 장시간 실행)

- [ ] **크래시 테스트**
  - [ ] 다양한 사용자 입력
  - [ ] 빠른 연속 탭
  - [ ] 네트워크 연결 끊김 (향후 서버 연동 시)

#### 코드 정리
- [ ] **경고(Warnings) 제거**
  - Xcode Build Warnings 모두 해결

- [ ] **미사용 코드 제거**
  - 주석 처리된 코드 정리
  - 미사용 import 제거

- [ ] **콘솔 로그 제거**
  - print() 문 제거 또는 #if DEBUG로 감싸기

- [ ] **TODO/FIXME 주석 확인**
  - 중요한 TODO 해결

---

### 5️⃣ 개인정보 보호 및 법적 요구사항

- [ ] **개인정보 처리방침 작성** (필수!)
  ```
  수집하는 데이터:
  • 없음 (로컬 저장만 사용)
  또는
  • 사용자 이름 (기기 내부 저장)
  • 할일 데이터 (기기 내부 저장)
  • 통계 데이터 (기기 내부 저장)
  
  데이터 사용 목적:
  • 앱 기능 제공
  
  제3자 공유:
  • 없음
  
  데이터 보관 기간:
  • 사용자가 앱 삭제 시까지
  ```

- [ ] **App Privacy 정보 입력** (App Store Connect)
  - Data Types Collected: 수집하는 데이터 유형 선택
  - 로컬 저장만 사용하면 "Data Not Collected" 선택 가능

- [ ] **이용 약관 작성** (선택사항)

- [ ] **라이선스 확인**
  - 사용한 오픈소스 라이브러리 라이선스 표기
  - SF Symbols 사용 규정 확인

---

### 6️⃣ App Store Connect 설정

- [ ] **App Store Connect에 앱 등록**
  - https://appstoreconnect.apple.com
  - "My Apps" → "+" → "New App"

- [ ] **앱 정보 입력**
  - [ ] App Name
  - [ ] Subtitle
  - [ ] Primary Language (Korean)
  - [ ] Bundle ID
  - [ ] SKU (고유 식별자)

- [ ] **가격 및 배포**
  - [ ] 가격 선택 (무료 권장)
  - [ ] 배포 국가 선택 (대한민국 필수)

- [ ] **버전 정보**
  - [ ] 버전 번호: 1.0
  - [ ] 저작권 정보
  - [ ] 카테고리

- [ ] **연령 등급 설정**
  - 질문지 작성

- [ ] **앱 심사 정보**
  - [ ] 연락처 정보
  - [ ] 데모 계정 (로그인 필요 시)
  - [ ] 심사 노트 (선택사항)

- [ ] **버전 출시 옵션**
  - 수동 출시 or 자동 출시

---

### 7️⃣ 빌드 및 업로드

- [ ] **Release 빌드 설정**
  - Xcode → Product → Scheme → Edit Scheme
  - Run Configuration을 "Release"로 변경

- [ ] **빌드 최적화 확인**
  - Build Settings → Optimization Level → "Optimize for Speed"

- [ ] **Archive 생성**
  - Xcode → Product → Archive
  - 성공적으로 Archive 생성 확인

- [ ] **Archive 유효성 검사**
  - Organizer → Validate App
  - 모든 검증 통과 확인

- [ ] **App Store에 업로드**
  - Organizer → Distribute App → App Store Connect
  - 업로드 완료 대기 (10-30분)

- [ ] **TestFlight 테스트** (선택사항, 권장!)
  - 내부 테스터 추가
  - TestFlight에서 테스트
  - 버그 수정 후 재업로드

---

### 8️⃣ 심사 제출

- [ ] **모든 메타데이터 확인**
  - 스크린샷, 설명, 아이콘 모두 업로드 확인

- [ ] **빌드 선택**
  - App Store Connect에서 업로드된 빌드 선택

- [ ] **심사 제출**
  - "Submit for Review" 버튼 클릭

- [ ] **심사 상태 모니터링**
  - "Waiting for Review" → "In Review" → "Ready for Sale"
  - 평균 심사 기간: 1-3일

---

### 9️⃣ 출시 후 관리

- [ ] **버전 1.0 출시 확인**
  - App Store에서 검색 가능한지 확인

- [ ] **크래시 리포트 모니터링**
  - Xcode Organizer → Crashes
  - App Store Connect → Analytics

- [ ] **리뷰 응답**
  - 사용자 리뷰에 적극적으로 답변

- [ ] **업데이트 계획**
  - TODO.md의 부가 기능 구현
  - 버그 수정
  - 버전 1.1, 1.2... 계획

---

## 📊 체크리스트 진행 상황

### 필수 항목 (반드시 완료)
- [ ] 1. 앱 정보 및 메타데이터 (1️⃣)
- [ ] 2. 개발자 계정 (2️⃣)
- [ ] 3. 프로젝트 설정 (3️⃣)
- [ ] 4. 테스트 (4️⃣)
- [ ] 5. 개인정보 보호 (5️⃣)
- [ ] 6. App Store Connect (6️⃣),
- [ ] 7. 빌드 업로드 (7️⃣)
- [ ] 8. 심사 제출 (8️⃣)

### 선택 항목 (권장)
- [ ] TestFlight 베타 테스트
- [ ] 앱 미리보기 비디오
- [ ] 마케팅 계획

---

## 🎯 권장 출시 순서

### Phase 1: 준비 (1-2일)
1. Apple Developer 계정 가입 (아직 안 했다면)
2. 앱 이름, 설명, 키워드 작성
3. 스크린샷 촬영 (시뮬레이터 or 실제 기기)
4. 앱 아이콘 최종 확인

### Phase 2: 설정 (1일)
5. App Store Connect에 앱 등록
6. 메타데이터 입력
7. 개인정보 처리방침 작성
8. 권한 설명 추가

### Phase 3: 테스트 (2-3일)
9. 실제 기기에서 전체 기능 테스트
10. 에지 케이스 테스트
11. 크래시 테스트
12. 코드 정리 (Warning 제거)

### Phase 4: 빌드 (1일)
13. Archive 생성
14. 유효성 검사
15. 업로드

### Phase 5: 출시 (1-3일)
16. TestFlight 테스트 (선택)
17. 심사 제출
18. 심사 대기 (1-3일)
19. 출시! 🎉

**예상 소요 시간: 약 1주일**

---

## ⚠️ 주의사항

### 심사 거부 사유 방지
- [ ] **기능 미완성**
  - 모든 버튼과 기능이 작동해야 함
  - "Coming Soon" 기능 없어야 함

- [ ] **크래시**
  - 심사 중 크래시 발생 시 즉시 거부
  - 철저한 테스트 필수!

- [ ] **개인정보 보호**
  - 권한 요청 시 반드시 설명 제공
  - 개인정보 처리방침 필수

- [ ] **메타데이터 부정확**
  - 스크린샷과 실제 앱이 일치해야 함
  - 설명과 실제 기능이 일치해야 함

- [ ] **저작권 침해**
  - 타인의 디자인/아이디어 무단 사용 금지
  - SF Symbols는 사용 가능

### 참고 링크
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)

---

## 🎉 출시 성공을 응원합니다!

현재 TODO.md에 따르면 **MVP가 100% 완성**되었으므로,
지금 바로 출시 준비를 시작할 수 있습니다! 💪

화이팅! 🚀
