import Photos
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var image = UIImage()
    @State private var filterImage = UIImage()
    @State private var showSheet = false
    
    private let filter = GrayscaleFilter()

    var body: some View {
        NavigationSplitView {
            HStack(alignment: .center, spacing: 10, content: {
                Image(uiImage: self.image)
                    .resizable()
                    .frame(width: 350, height: 350)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .padding(8)
//                Text("Select Photo")
//                    .font(.headline)
//                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50)
//                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
//                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
//                    .foregroundStyle(Color.white)
//                    .onTapGesture {
//                        showSheet = true
//                    }
//                    .sheet(isPresented: $showSheet, content: {
////                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, outputImage: self.$filterImage).onChange(of: image) {
////                            self.saveImage(self.filterImage.copy() as! UIImage)
////                        }
//                    }).onChange(of: showSheet) { oldValue, newValue in
//                        print(self.image, self.filterImage)
//                    }
                Image(uiImage: self.filterImage)
                    .resizable()
                    .frame(width: 350, height: 350)
                    .background(Color.black.opacity(0.2))
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .padding(8)
            }).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button {
                        showSheet = true
                    } label: {
                        Label("Add Item", systemImage: "photo")
                    }

                }
            }
            .sheet(isPresented: $showSheet) {
                ImagePicker(sourceType: .photoLibrary,
                            selectedImage: self.$image,
                            outputImage: self.$filterImage)
            }
        } detail: {
            Text("Select an item")
        }
    }
    
    private func saveImage(_ image: UIImage) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { (isSuccess: Bool, error: Error?) in
                        if isSuccess {
                            print("保存成功!")
                        } else{
                            print("保存失败：", error!.localizedDescription)
                        }
                    }
                }
            })
        } else if status == .authorized {
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { (isSuccess: Bool, error: Error?) in
                if isSuccess {
                    print("保存成功!")
                } else{
                    print("保存失败：", error!.localizedDescription)
                }
            }
        }
    }
    
    private func selectPhotoAndApplyFilter() {
        
//        let picker = ImagePicker(sourceType: .photoLibrary,
//                                 selectedImage: self.$image,
//                                 outputImage: self.$filterImage)
//        present
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
