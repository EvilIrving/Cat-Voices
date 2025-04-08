import SwiftUI
import PhotosUI
import AVFoundation

/// 添加和编辑猫咪的 Sheet 视图
struct AddAndEditCatView: View {
    // MARK: - Properties
    @StateObject private var languageManager = LanguageManager.shared
    @Binding var isPresented: Bool
    @Binding var cat: Cat?
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - State
    @State private var name: String = ""
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var breed: Breed = .other
    @State private var birthDate: Date = Date()
    @State private var adoptionDate: Date = Date()
    @State private var gender: Gender = .male
    @State private var neuteringStatus: NeuteringStatus = .unknown
    @State private var currentStatus: CurrentStatus = .present
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingCameraAlert = false
    @State private var showingPhotoLibraryAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information".localised(using: languageManager.selectedLanguage))) {
                    TextField("Name".localised(using: languageManager.selectedLanguage), text: $name)
                    
                    HStack {
                        Text("Avatar".localised(using: languageManager.selectedLanguage))
                        Spacer()
                        if let avatarImage = avatarImage {
                            avatarImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        } else {
                            Image(systemName: "photo")
                                .frame(width: 100, height: 100)
                        }
                    }
                    .onTapGesture {
                        checkPhotoLibraryPermission()
                    }
                    
                    Picker("Breed".localised(using: languageManager.selectedLanguage), selection: $breed) {
                        ForEach(Breed.allCases, id: \.self) { breed in
                            Text(breed.rawValue).tag(breed)
                        }
                    }
                }
                
                Section(header: Text("Date Information".localised(using: languageManager.selectedLanguage))) {
                    DatePicker("Birth Date".localised(using: languageManager.selectedLanguage), selection: $birthDate, displayedComponents: .date)
                    DatePicker("Arrival Date".localised(using: languageManager.selectedLanguage), selection: $adoptionDate, displayedComponents: .date)
                }

                Section(header: Text("Other Information".localised(using: languageManager.selectedLanguage))) {
                    Picker("Gender".localised(using: languageManager.selectedLanguage), selection: $gender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                    
                    Picker("Neutering Status".localised(using: languageManager.selectedLanguage), selection: $neuteringStatus) {
                        ForEach(NeuteringStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    
                    Picker("Current Status".localised(using: languageManager.selectedLanguage), selection: $currentStatus) {
                        ForEach(CurrentStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }
            }
            .navigationTitle(cat == nil ? "Add Cat".localised(using: languageManager.selectedLanguage) : "Edit Cat".localised(using: languageManager.selectedLanguage))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel".localised(using: languageManager.selectedLanguage)) {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save".localised(using: languageManager.selectedLanguage)) {
                        saveCat()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) {
                loadImage()
            }
            .alert(isPresented: $showingCameraAlert) {
                Alert(
                    title: Text("需要相机权限"),
                    message: Text("请在设置中允许此应用访问您的相机。"),
                    primaryButton: .default(Text("去设置")) {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .alert(isPresented: $showingPhotoLibraryAlert) {
                Alert(
                    title: Text("需要相册权限"),
                    message: Text("请在设置中允许此应用访问您的相册。"),
                    primaryButton: .default(Text("去设置")) {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .onAppear {
            if let cat = cat {
                name = cat.name
                breed = cat.breed
                birthDate = cat.birthDate ?? Date()
                adoptionDate = cat.adoptionDate ?? Date()
                gender = cat.gender
                neuteringStatus = cat.neuteringStatus
                currentStatus = cat.currentStatus
                if let avatarURL = cat.avatar {
                    loadAvatarFromURL(avatarURL)
                }
            }
        }
    }
    
    private func saveCat() {
        if let cat = cat {
            // 更新现有猫咪
            cat.name = name
            cat.breed = breed
            cat.birthDate = birthDate
            cat.adoptionDate = adoptionDate
            cat.gender = gender
            cat.neuteringStatus = neuteringStatus
            cat.currentStatus = currentStatus
            if let inputImage = inputImage {
                saveImage(inputImage, for: cat)
            }
        } else {
            // 创建新猫咪
            let newCat = Cat(name: name, breed: breed, birthDate: birthDate, adoptionDate: adoptionDate, gender: gender, neuteringStatus: neuteringStatus, currentStatus: currentStatus)
            if let inputImage = inputImage {
                saveImage(inputImage, for: newCat)
            }
            modelContext.insert(newCat)
        }
        isPresented = false
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        avatarImage = Image(uiImage: inputImage)
    }
    
    private func saveImage(_ image: UIImage, for cat: Cat) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let filename = cat.id.uuidString + ".jpg"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        try? data.write(to: fileURL)
        cat.avatar = fileURL
    }
    
    private func loadAvatarFromURL(_ url: URL) {
        guard let data = try? Data(contentsOf: url),
              let uiImage = UIImage(data: data) else { return }
        avatarImage = Image(uiImage: uiImage)
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showingImagePicker = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.showingImagePicker = true
                    }
                }
            }
        case .denied, .restricted:
            showingCameraAlert = true
        @unknown default:
            break
        }
    }

    private func checkPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized, .limited:
            showingImagePicker = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized || status == .limited {
                    DispatchQueue.main.async {
                        self.showingImagePicker = true
                    }
                }
            }
        case .denied, .restricted:
            showingPhotoLibraryAlert = true
        @unknown default:
            break
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }
}
