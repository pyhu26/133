# 📱 133 앱 배포 체크리스트

> iOS App Store 배포를 위한 단계별 가이드

**최종 업데이트**: 2025-01-15
**현재 상태**: 준비 중 🚧

---

## 📋 배포 전 체크리스트

### ✅ Phase 1: 사전 준비 (필수)

- [ ] **1.1 Apple Developer Program 등록**
  - 비용: $99/년 (USD)
  - 링크: https://developer.apple.com/programs/
  - 소요 시간: 승인까지 24-48시간
  - 필요 항목:
    - Apple ID
    - 신용카드
    - 신분증 (개인) 또는 사업자 등록증 (회사)

- [x] **1.2 앱 정보 최종 확인**
  - 앱 이름: `133`
  - Bundle ID: ✅ `com.pyhu26.onethreethree`
  - 버전: ✅ `1.0`
  - 빌드 번호: ✅ `1`
  - 최소 iOS 버전: ✅ `iOS 17.0`

- [ ] **1.3 개인정보 처리방침 및 이용약관**
  - ✅ 개인정보 처리방침 작성 완료
  - ✅ 이용약관 작성 완료
  - [ ] 웹 호스팅 (선택사항 - App Store 제출 시 URL 필요)

---

### 🎨 Phase 2: 디자인 에셋 준비

- [ ] **2.1 앱 아이콘**
  - [ ] 1024x1024px PNG (App Store용)
  - [ ] 투명 배경 없음
  - [ ] 둥근 모서리 없음 (iOS가 자동 처리)
  - 현재 상태: Assets.xcassets에 기본 아이콘 있음 → **교체 필요**

- [ ] **2.2 스크린샷 준비**
  - 필수 기기 크기:
    - [ ] 6.7" (iPhone 14 Pro Max, 15 Pro Max) - 1290 x 2796
    - [ ] 6.5" (iPhone 11 Pro Max, XS Max) - 1242 x 2688
  - 권장 개수: 3-5장
  - 필요한 화면:
    - [ ] 홈 화면 (할 일 목록)
    - [ ] 타이머 화면
    - [ ] 통계 화면
    - [ ] 설정 화면 (선택)

- [ ] **2.3 앱 프리뷰 영상 (선택)**
  - 최대 30초
  - 세로 방향 권장

---

### 🔧 Phase 3: 프로젝트 설정

- [x] **3.1 Bundle Identifier 설정**
  - ~~현재: `com.pyhu26.133App.-33App`~~ ⚠️ **수정 완료**
  - ✅ 수정됨: `com.pyhu26.onethreethree`
  - 설정 위치: Xcode → Target → Signing & Capabilities

- [ ] **3.2 Display Name 설정**
  - 현재: `133App`
  - 권장: `133` (간단하게)
  - 설정 위치: Info.plist → Bundle display name

- [ ] **3.3 버전 정보 확인**
  - Version: `1.0.0` ✅
  - Build: `1` ✅
  - 설정 위치: Xcode → Target → General → Identity

- [x] **3.4 앱 권한 설명 추가**
  - [x] ~~알림 권한 설명~~ (로컬 알림은 자동 처리)
  - [x] 사진 라이브러리 권한 설명 (NSPhotoLibraryUsageDescription) ✅
  - 설정 위치: project.pbxproj (INFOPLIST_KEY)

- [ ] **3.5 배포 설정 최적화**
  - [ ] Build Configuration: Release
  - [ ] Optimization Level: `-Os` (크기 최적화)
  - [ ] Bitcode: Enable (선택)
  - [ ] Strip Debug Symbols: Yes

---

### 🔐 Phase 4: 서명 및 프로비저닝

- [ ] **4.1 Signing Certificate 생성**
  - Developer 계정에서 생성
  - Xcode에서 자동 관리 가능 (권장)

- [ ] **4.2 App ID 등록**
  - Apple Developer Portal에서 등록
  - Bundle ID와 일치해야 함

- [ ] **4.3 프로비저닝 프로파일 생성**
  - Distribution 프로파일 필요
  - Xcode 자동 관리 권장

- [ ] **4.4 서명 설정**
  - Xcode → Target → Signing & Capabilities
  - Team 선택
  - "Automatically manage signing" 체크 권장

---

### 📦 Phase 5: Archive 빌드

- [ ] **5.1 배포용 빌드 설정**
  ```
  1. Xcode 메뉴 → Product → Scheme → Edit Scheme
  2. Run → Build Configuration → Release 선택
  3. Archive → Build Configuration → Release 확인
  ```

- [ ] **5.2 실제 기기에서 테스트**
  - [ ] iPhone에서 정상 작동 확인
  - [ ] 라이트 모드 테스트
  - [ ] 다크 모드 테스트
  - [ ] 모든 기능 동작 확인
  - [ ] 권한 요청 정상 확인

- [ ] **5.3 Archive 생성**
  ```
  1. Generic iOS Device 선택
  2. Product → Archive
  3. Organizer 창에서 확인
  ```

- [ ] **5.4 Archive 검증**
  - Validate App 실행
  - 에러/경고 확인 및 수정

---

### 🚀 Phase 6: App Store Connect 설정

- [ ] **6.1 App Store Connect 앱 등록**
  - https://appstoreconnect.apple.com
  - "나의 앱" → "+" → "새로운 앱"
  - 정보 입력:
    - [ ] 플랫폼: iOS
    - [ ] 이름: `133`
    - [ ] 기본 언어: 한국어
    - [ ] Bundle ID: 선택
    - [ ] SKU: 임의의 고유 값 (예: `133-app-2025`)

- [ ] **6.2 앱 정보 작성**
  - [ ] **이름**: `133` (30자 이내)
  - [ ] **부제**: `하루 3분, 3개만 하자` (30자 이내)
  - [ ] **설명**: 상세 설명 작성 (4000자 이내)
  ```
  133은 미니멀리스트를 위한 할 일 관리 앱입니다.

  하루에 딱 3개의 작은 일만 집중하세요. 3분이면 충분합니다.

  주요 기능:
  • 하루 최대 3개의 할 일만 등록
  • 집중을 돕는 타이머
  • 실천 기록 통계
  • 다크 모드 지원

  못해도 괜찮아요. 1개만 해도 당신은 오늘 어제와 달라요.
  ```
  - [ ] **키워드**: (최대 100자, 쉼표로 구분)
  ```
  할일,todo,미니멀리스트,생산성,타이머,포커스,집중,습관,133
  ```
  - [ ] **지원 URL**: 필요 (개인 웹사이트 또는 GitHub 페이지)
  - [ ] **마케팅 URL**: 선택사항

- [ ] **6.3 카테고리 선택**
  - 주 카테고리: 생산성 (Productivity)
  - 부 카테고리: 라이프스타일 (Lifestyle) - 선택사항

- [ ] **6.4 가격 및 판매 가능 여부**
  - [ ] 가격: 무료
  - [ ] 판매 국가: 대한민국 (또는 전체)

- [ ] **6.5 개인정보 보호**
  - [ ] 개인정보 수집 여부: 아니요
  - [ ] 개인정보 처리방침 URL: (웹 호스팅된 URL)

---

### 📱 Phase 7: TestFlight (선택사항)

- [ ] **7.1 내부 테스터 초대**
  - 최대 100명까지 무료
  - 즉시 테스트 가능

- [ ] **7.2 외부 테스터 초대 (선택)**
  - 최대 10,000명
  - App Review 필요

- [ ] **7.3 베타 테스트 피드백 수집**
  - 버그 수정
  - 기능 개선

---

### 📤 Phase 8: App Store 제출

- [ ] **8.1 빌드 업로드**
  ```
  Xcode Organizer → Distribute App → App Store Connect
  ```

- [ ] **8.2 빌드 선택**
  - App Store Connect → 버전 정보 → 빌드 선택

- [ ] **8.3 Export Compliance (수출 규정)**
  - 암호화 사용 여부: 아니요 (일반적으로)

- [ ] **8.4 광고 식별자 (IDFA)**
  - 광고 사용: 아니요

- [ ] **8.5 콘텐츠 권리**
  - 제3자 콘텐츠 포함 여부 확인

- [ ] **8.6 연령 등급**
  - 설문 작성
  - 예상 등급: 4+ (모든 연령)

- [ ] **8.7 심사 정보**
  - [ ] 연락처 정보
  - [ ] 데모 계정 (필요시)
  - [ ] 추가 설명

- [ ] **8.8 제출**
  - "심사 제출" 버튼 클릭
  - 상태: "심사 대기 중"

---

### ⏳ Phase 9: 심사 대기

- [ ] **9.1 심사 진행 상황 확인**
  - App Store Connect에서 확인
  - 이메일 알림 받기

- [ ] **9.2 예상 심사 기간**
  - 평균: 24-48시간
  - 최대: 1주일

- [ ] **9.3 심사 통과**
  - 상태: "판매 준비 완료"
  - 자동 출시 또는 수동 출시 선택

- [ ] **9.4 심사 거부 시**
  - 거부 사유 확인
  - 수정 후 재제출

---

## 🎯 배포 후 체크리스트

- [ ] **App Store에서 앱 확인**
  - 검색으로 앱 찾기
  - 정보 정확성 확인

- [ ] **초기 리뷰 모니터링**
  - 사용자 피드백 확인
  - 버그 리포트 대응

- [ ] **업데이트 계획 수립**
  - 버그 수정 업데이트
  - 새 기능 추가

---

## 📝 중요 링크

- **Apple Developer**: https://developer.apple.com
- **App Store Connect**: https://appstoreconnect.apple.com
- **Human Interface Guidelines**: https://developer.apple.com/design/human-interface-guidelines/
- **App Store Review Guidelines**: https://developer.apple.com/app-store/review/guidelines/
- **App Store Marketing Guidelines**: https://developer.apple.com/app-store/marketing/guidelines/

---

## ⚠️ 주의사항

### 자주 거부되는 사유
1. **불완전한 앱**: 크래시, 버그, 미완성 기능
2. **메타데이터 문제**: 스크린샷과 앱 기능 불일치
3. **개인정보 처리방침 누락**: URL 필수
4. **부적절한 콘텐츠**: 가이드라인 위반
5. **최소 기능 미달**: 너무 단순한 앱

### 133 앱 체크포인트
- ✅ 완전히 작동하는 기능
- ✅ 크래시 없음
- ✅ 개인정보 처리방침 있음
- ✅ 이용약관 있음
- ⚠️ 웹 호스팅 URL 필요 (처리방침/약관)

---

## 🚦 현재 진행 상태

```
[■■■■■■■□□□] 70% - Phase 3 완료, Phase 2 진행 중

완료:
✅ Phase 1: 개인정보/이용약관 작성
✅ Phase 2: 기본 앱 기능 완성
✅ Phase 3: 다크 테마 적용
✅ 성능 최적화
✅ Bundle Identifier 수정
✅ Deployment Target 수정 (iOS 17.0)
✅ 권한 설명 추가

진행 필요:
🔲 Phase 1: Apple Developer 등록 확인
🔲 Phase 2: 앱 아이콘 제작 (ASSETS_GUIDE.md 참고)
🔲 Phase 2: 스크린샷 촬영 (3-5장)
```

---

## 🎓 다음 단계

1. **Apple Developer Program 등록 여부 확인**
   - 이미 등록되어 있나요?
   - 등록되지 않았다면 등록 시작 ($99/년)

2. **Bundle ID 수정**
   - 현재 Bundle ID 확인 및 수정 필요

3. **앱 아이콘 제작**
   - 1024x1024px 디자인 필요

4. **스크린샷 촬영**
   - 시뮬레이터에서 스크린샷 생성

**준비되셨으면 순서대로 진행하겠습니다!** 🚀
