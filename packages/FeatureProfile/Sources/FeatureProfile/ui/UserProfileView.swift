//
//  UserProfileView.swift
//  profile
//
//  Created by builder on 5/8/25.
//

import SwiftUI
import model

public struct UserProfileView: View {
    @State private var user: User

    public init(user: User) {
        _user = State(initialValue: user)
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Profile Header
                    VStack(spacing: 12) {
                        ProfileImageView(url: user.profilePictureUrl)

                        // Name + Verified badge
                        HStack(spacing: 6) {
                            Text(user.name ?? "Unnamed User")
                                .font(.title2)
                                .fontWeight(.semibold)

                            if user.verified {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.blue)
                                    .imageScale(.medium)
                            }
                        }
                    }

                    // MARK: - User Info Card
                    VStack(spacing: 12) {
                        if let email = user.email {
                            InfoRow(label: "Email", value: email, icon: "envelope")
                        }

                        if let phone = user.phoneNumber {
                            InfoRow(label: "Phone", value: phone, icon: "phone")
                        }

                        InfoRow(label: "Account Type", value: user.userType.rawValue.capitalized, icon: "person.crop.circle")
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
                    .padding(.horizontal)

                    // MARK: - Liked Properties
                    VStack(spacing: 4) {
                        Text("Liked Properties")
                            .font(.headline)

                        Text("\(user.likedProperties.count)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)
                    }

                    Spacer()
                }
                .padding(.top, 24)
                .navigationTitle("Profile")
            }
        }
    }
}

// MARK: - Components
struct ProfileImageView: View {
    let url: String?
    let size: CGFloat = 100

    var body: some View {
        if let url = url, url.starts(with: "http"), let imageUrl = URL(string: url) {
            // Remote image
            AsyncImage(url: imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size, height: size)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                case .failure:
                    fallbackImage
                @unknown default:
                    EmptyView()
                }
            }
        } else if let localAsset = url {
            // Local asset image
            Image(localAsset)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .shadow(radius: 4)
        } else {
            // Nil URL: fallback
            fallbackImage
        }
    }

    private var fallbackImage: some View {
        Image(systemName: "person.circle")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(Circle())
            .foregroundColor(.gray)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }
            Spacer()
        }
    }
}

#Preview {
    let mockUser = User(
        userId: "123",
        name: "Harry Kibet",
        email: "harry@example.com",
        phoneNumber: "+254712345678",
        profilePictureUrl:"https://i.pravatar.cc/150?img=3",
        userType: .landlord,
        verified: true,
        likedProperties: ["property_1", "property_2"]    )

    UserProfileView(user: mockUser)
}
