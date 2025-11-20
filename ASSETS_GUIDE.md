# 📱 133 앱 - 아이콘 및 스크린샷 가이드

> App Store 제출을 위한 필수 디자인 에셋 준비 가이드

**작성일**: 2025-01-15

---

## 📋 필요한 에셋 목록

### 1. 앱 아이콘
- **크기**: 1024 x 1024 픽셀
- **형식**: PNG (투명 배경 없음)
- **주의사항**:
  - 둥근 모서리 없음 (iOS가 자동 처리)
  - 알파 채널 없음
  - 색상 프로파일: sRGB

### 2. 앱 스크린샷
**필수 크기**:
- 6.7" (iPhone 14 Pro Max, 15 Pro Max): 1290 x 2796
- 6.5" (iPhone 11 Pro Max, XS Max): 1242 x 2688

**권장 개수**: 3-5장

---

## 🎨 앱 아이콘 디자인 가이드

### 디자인 컨셉
133 앱의 미니멀리즘 철학을 반영한 깔끔한 디자인

### 색상 팔레트 (현재 앱 테마)
```
- Soft Peach: #FFB4A2 (메인 색상)
- Gentle Lavender: #E5D9F2 (보조 색상)
- Powder Blue: #A6C0D9 (포인트 색상)
- Soft Mint: #C8E6C9 (액센트 색상)
```

### 디자인 옵션

#### 옵션 1: 숫자 강조형
```
┌─────────────────┐
│                 │
│       133       │
│                 │
│   (큰 굵은 폰트)  │
│                 │
│  배경: 그라데이션  │
│  (Peach→Lavender) │
│                 │
└─────────────────┘
```

#### 옵션 2: 미니멀 심플형
```
┌─────────────────┐
│                 │
│    ●  ●  ●      │
│                 │
│   세 개의 점     │
│   (할 일 3개)    │
│                 │
│  Soft Peach 배경 │
│                 │
└─────────────────┘
```

#### 옵션 3: 타이머 컨셉형
```
┌─────────────────┐
│                 │
│      ⏱️         │
│                 │
│      3 MIN      │
│                 │
│  원형 배경       │
│  (Peach 그라데이션)│
│                 │
└─────────────────┘
```

---

## 🖼️ 아이콘 제작 방법

### 방법 1: Figma (무료, 추천)
1. **Figma 접속**: https://www.figma.com
2. **새 프레임 생성**: 1024 x 1024px
3. **디자인 작업**:
   - 배경 그라데이션 추가
   - 텍스트/도형 추가
   - 색상 적용 (#FFB4A2 등)
4. **내보내기**:
   - File → Export → PNG
   - 2x 또는 3x 해상도 선택

### 방법 2: Canva (무료, 간단)
1. **Canva 접속**: https://www.canva.com
2. **사용자 지정 크기**: 1024 x 1024px
3. **템플릿 선택** 또는 직접 디자인
4. **PNG로 다운로드**

### 방법 3: macOS 기본 앱 (Keynote/Pages)
1. **Keynote 또는 Pages 실행**
2. **캔버스 크기**: 1024 x 1024px 설정
3. **도형, 텍스트 추가**
4. **파일 → 내보내기 → 이미지 → PNG**

### 방법 4: AI 생성 (실험적)
- DALL-E, Midjourney 등 사용
- 프롬프트 예시:
  ```
  "Minimalist iOS app icon for a todo app,
  number 133, soft peach gradient background,
  simple and clean design, flat style"
  ```

---

## 📸 스크린샷 촬영 가이드

### 촬영할 화면

#### 1번 스크린샷: 홈 화면 (메인)
- **내용**: 할 일 목록이 표시된 메인 화면
- **준비사항**:
  - 3개의 할 일 등록
  - 예시 할 일:
    - "아침 운동 30분" (3분)
    - "독서 하기" (3분)
    - "물 2L 마시기" (3분)
  - 시간대: 오전 (밝은 인사말 표시)

#### 2번 스크린샷: 타이머 화면
- **내용**: 타이머가 실행 중인 화면
- **준비사항**:
  - 할 일 하나 선택
  - 타이머 시작
  - 2분 정도 지난 상태 캡처

#### 3번 스크린샷: 통계 화면
- **내용**: 주간 통계 및 완료 기록
- **준비사항**:
  - 며칠간 데이터 누적 필요
  - 또는 테스트 데이터 추가

#### 4번 스크린샷 (선택): 다크 모드
- **내용**: 다크 모드가 적용된 홈 화면
- **준비사항**:
  - 설정 → 다크 모드 활성화
  - 홈 화면 다시 캡처

#### 5번 스크린샷 (선택): 설정 화면
- **내용**: 설정 화면
- **특징**: 미니멀한 디자인 강조

---

## 🎬 스크린샷 촬영 방법

### Xcode Simulator 사용 (추천)

1. **시뮬레이터 실행**
   ```bash
   cd /Users/yoonpro/07.swift/todo133/133App
   xcodebuild -project 133App.xcodeproj -scheme 133App \
     -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' \
     -sdk iphonesimulator
   ```

2. **원하는 화면으로 이동**

3. **스크린샷 촬영**
   - 방법 1: 메뉴 → Device → Screenshot
   - 방법 2: `Cmd + S`
   - 방법 3: 시뮬레이터 창 → File → New Screenshot

4. **저장 위치**: Desktop 폴더

5. **크기 확인**
   - iPhone 16 Pro Max 시뮬레이터 스크린샷은 자동으로 올바른 크기

### 실제 기기 사용

1. **앱을 기기에 설치**
2. **원하는 화면으로 이동**
3. **스크린샷 촬영**:
   - iPhone X 이상: 볼륨 위 + 사이드 버튼
   - iPhone 8 이하: 홈 버튼 + 전원 버튼
4. **Mac으로 전송**: AirDrop 또는 iCloud

---

## 📁 에셋 파일 구조

권장 폴더 구조:
```
133App/
├── AppStoreAssets/
│   ├── AppIcon/
│   │   └── AppIcon-1024.png          # 1024x1024 앱 아이콘
│   ├── Screenshots/
│   │   ├── 6.7-inch/                 # iPhone 14/15 Pro Max
│   │   │   ├── 01-home.png           # 1290 x 2796
│   │   │   ├── 02-timer.png
│   │   │   ├── 03-stats.png
│   │   │   ├── 04-dark-mode.png      # (선택)
│   │   │   └── 05-settings.png       # (선택)
│   │   └── 6.5-inch/                 # iPhone 11/XS Max
│   │       ├── 01-home.png           # 1242 x 2688
│   │       ├── 02-timer.png
│   │       └── 03-stats.png
│   └── Preview/                      # (선택) 앱 프리뷰 영상
│       └── preview-video.mp4
```

---

## 🔧 Xcode에 아이콘 추가하기

### 1. 아이콘 파일 준비
- 1024x1024 PNG 파일 준비
- 파일명: `AppIcon.png` (권장)

### 2. Assets.xcassets에 추가

#### 방법 A: Xcode에서 직접 추가
1. **Xcode에서 프로젝트 열기**
2. **Assets.xcassets 클릭**
3. **AppIcon 클릭**
4. **1024x1024 슬롯에 이미지 드래그 앤 드롭**

#### 방법 B: Finder에서 직접 추가
```bash
# 아이콘 파일을 AppIcon.appiconset 폴더에 복사
cp AppIcon.png 133App/133App/Assets.xcassets/AppIcon.appiconset/

# Contents.json 수정 (이미지 파일명 추가)
# 또는 Xcode에서 자동 인식
```

### 3. 빌드 및 확인
```bash
xcodebuild -project 133App.xcodeproj -scheme 133App \
  -sdk iphonesimulator clean build
```

시뮬레이터의 홈 화면에서 앱 아이콘 확인

---

## ✅ 체크리스트

### 아이콘
- [ ] 1024 x 1024 PNG 파일 생성
- [ ] 투명 배경 없음 확인
- [ ] sRGB 색상 프로파일 확인
- [ ] Assets.xcassets에 추가
- [ ] 시뮬레이터에서 확인

### 스크린샷
- [ ] iPhone 16 Pro Max (6.7") 스크린샷 3-5장
- [ ] 1290 x 2796 크기 확인
- [ ] 홈 화면 캡처
- [ ] 타이머 화면 캡처
- [ ] 통계 화면 캡처
- [ ] 다크 모드 화면 캡처 (선택)
- [ ] 설정 화면 캡처 (선택)

### 선택사항
- [ ] 앱 프리뷰 영상 (30초 이내)
- [ ] 6.5" 스크린샷 추가 (하위 호환성)

---

## 🎯 다음 단계

에셋 준비가 완료되면:

1. **DEPLOYMENT_CHECKLIST.md의 Phase 2 체크** ✅
2. **Phase 3: 프로젝트 설정** 진행 ✅ (이미 완료)
3. **Phase 4: 서명 및 프로비저닝** 진행
4. **Phase 5: Archive 빌드** 준비

---

## 💡 팁

### 빠른 아이콘 제작
시간이 부족하다면, 임시로 간단한 아이콘을 만들고 나중에 업데이트:
1. Figma에서 10분 안에 제작
2. 배경 그라데이션 + "133" 텍스트만으로도 충분
3. 앱 업데이트 시 더 나은 아이콘으로 교체 가능

### 스크린샷 품질 향상
- 시뮬레이터 해상도를 100%로 설정
- 밝기 조절로 화면이 선명하게 보이도록
- 의미 있는 데이터 표시 (빈 화면 지양)

### 현재 상태
- ✅ Bundle ID 수정 완료: `com.pyhu26.onethreethree`
- ✅ Deployment Target 수정 완료: iOS 17.0
- ✅ 권한 설명 추가 완료
- 🔲 앱 아이콘 제작 필요
- 🔲 스크린샷 촬영 필요

---

**준비가 되면 다음 명령어로 배포 진행!** 🚀
