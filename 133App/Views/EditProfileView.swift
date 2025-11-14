//
//  EditProfileView.swift
//  133App
//
//  프로필 편집 화면
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Bindable var settingsManager: SettingsManager
    @Binding var isPresented: Bool
    
    @State private var userName: String
    @State private var selectedIcon: String
    @State private var profileImage: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?
    @FocusState private var isNameFocused: Bool
    
    // 사용 가능한 프로필 아이콘 목록
    private let availableIcons = [
        "person.fill",
        "face.smiling",
        "heart.fill",
        "star.fill",
        "moon.fill",
        "sun.max.fill",
        "leaf.fill",
        "flame.fill",
        "drop.fill",
        "bolt.fill",
        "sparkles",
        "rainbow"
    ]
    
    init(settingsManager: SettingsManager, isPresented: Binding<Bool>) {
        self.settingsManager = settingsManager
        self._isPresented = isPresented
        self._userName = State(initialValue: settingsManager.userName)
        self._selectedIcon = State(initialValue: settingsManager.userProfileIcon)
        
        // 저장된 이미지 로드
        if let imageData = settingsManager.userProfileImageData,
           let uiImage = UIImage(data: imageData) {
            self._profileImage = State(initialValue: uiImage)
        }
    }
    
    var body: some View {
        ZStack {
            // Background dimmed overlay
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 0) {
                Spacer()
                
                // Bottom Sheet Container
                VStack(spacing: Spacing.xl) {
                    // Handle Bar
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.lightGray)
                        .frame(width: 36, height: 4)
                        .padding(.top, Spacing.md)
                    
                    // Header
                    VStack(spacing: Spacing.xs) {
                        Text("프로필 편집")
                            .textStyle(.headingMedium)
                        
                        Text("이름과 아이콘을 수정하세요")
                            .textStyle(.bodySmall)
                            .foregroundColor(.mediumGray)
                    }
                    
                    // Profile Avatar
                    ZStack {
                        Circle()
                            .fill(Color.peachGradient)
                            .frame(width: 100, height: 100)
                            .shadow(
                                color: Color.softPeach.opacity(0.3),
                                radius: 12,
                                y: 8
                            )
                        
                        if let profileImage = profileImage {
                            // 사용자가 선택한 이미지
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            // SF Symbol 아이콘
                            Image(systemName: selectedIcon)
                                .font(.system(size: 50))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        // 사진 변경 버튼
                        PhotosPicker(selection: $photoPickerItem, matching: .images) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.softPeach)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 4, y: 2)
                        }
                        .offset(x: 35, y: 35)
                    }
                    .padding(.vertical, Spacing.md)
                    
                    // Icon Selector
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        HStack {
                            Text(profileImage == nil ? "아이콘 선택" : "아이콘으로 되돌리기")
                                .textStyle(.bodySmall)
                                .foregroundColor(.adaptiveSecondaryText)
                            
                            Spacer()
                            
                            if profileImage != nil {
                                Button(action: {
                                    withAnimation {
                                        profileImage = nil
                                        HapticManager.shared.light()
                                    }
                                }) {
                                    Text("이미지 삭제")
                                        .textStyle(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        if profileImage == nil {
                            LazyVGrid(
                                columns: Array(repeating: GridItem(.flexible(), spacing: Spacing.sm), count: 6),
                                spacing: Spacing.sm
                            ) {
                                ForEach(availableIcons, id: \.self) { icon in
                                    ProfileIconButton(
                                        icon: icon,
                                        isSelected: selectedIcon == icon
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedIcon = icon
                                            HapticManager.shared.light()
                                        }
                                    }
                                }
                            }
                        } else {
                            Text("사진을 사용 중입니다. 아이콘을 사용하려면 '이미지 삭제'를 탭하세요.")
                                .textStyle(.caption)
                                .foregroundColor(.adaptiveSecondaryText)
                                .padding(.vertical, Spacing.sm)
                        }
                    }
                    
                    // Name Input
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("이름")
                            .textStyle(.bodySmall)
                            .foregroundColor(.adaptiveSecondaryText)
                        
                        TextField("이름을 입력하세요", text: $userName)
                            .textStyle(.bodyRegular)
                            .multilineTextAlignment(.center)
                            .padding(Spacing.md)
                            .background(Color.adaptiveInputBackground)
                            .mediumRadius()
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        isNameFocused ? Color.softPeach : Color.adaptiveBorder,
                                        lineWidth: 2
                                    )
                            )
                            .lightShadow()
                            .focused($isNameFocused)
                    }
                    
                    // Character Count
                    HStack {
                        Spacer()
                        Text("\(userName.count)/10")
                            .textStyle(.caption)
                            .foregroundColor(userName.count > 10 ? .red : .adaptiveSecondaryText)
                    }
                    
                    // Buttons
                    VStack(spacing: Spacing.sm) {
                        CustomButton(
                            title: "저장하기",
                            icon: "checkmark.circle.fill",
                            style: .primary
                        ) {
                            saveProfile()
                        }
                        .disabled(userName.isEmpty || userName.count > 10)
                        
                        CustomButton(
                            title: "취소",
                            style: .text
                        ) {
                            isPresented = false
                        }
                    }
                    
                    // Info
                    Text("이름은 최대 10자까지 입력 가능해요")
                        .textStyle(.caption)
                        .foregroundColor(.adaptiveSecondaryText)
                }
                .padding(Spacing.xl)
                .background(
                    Color.adaptiveSecondaryBackground
                        .clipShape(
                            .rect(
                                topLeadingRadius: 24,
                                topTrailingRadius: 24
                            )
                        )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 20, y: -5)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            isNameFocused = true
        }
        .onChange(of: photoPickerItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        profileImage = uiImage
                        HapticManager.shared.success()
                    }
                }
            }
        }
    }
    
    private func saveProfile() {
        guard !userName.isEmpty && userName.count <= 10 else { return }
        
        // 이름과 아이콘 저장
        settingsManager.userName = userName
        settingsManager.userProfileIcon = selectedIcon
        
        // 프로필 이미지 저장
        if let profileImage = profileImage {
            // 이미지를 JPEG로 압축하여 저장 (0.7 품질)
            settingsManager.userProfileImageData = profileImage.jpegData(compressionQuality: 0.7)
        } else {
            // 이미지가 없으면 nil로 설정
            settingsManager.userProfileImageData = nil
        }
        
        // 햅틱 피드백
        HapticManager.shared.success()
        
        // 화면 닫기
        isPresented = false
    }
}

// MARK: - Profile Icon Button

struct ProfileIconButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isSelected ? AnyShapeStyle(Color.peachGradient) : AnyShapeStyle(Color.adaptiveCardBackground))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.clear : Color.adaptiveBorder, lineWidth: 2)
                    )
                    .shadow(
                        color: isSelected ? Color.softPeach.opacity(0.3) : Color.black.opacity(0.05),
                        radius: isSelected ? 8 : 4,
                        y: isSelected ? 4 : 2
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .white : .adaptiveText)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.adaptiveBackground
            .ignoresSafeArea()
        
        Text("Settings Screen")
            .font(.largeTitle)
    }
    .sheet(isPresented: .constant(true)) {
        EditProfileView(
            settingsManager: SettingsManager(),
            isPresented: .constant(true)
        )
    }
}
