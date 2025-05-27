# Air App - Setup Instructions

This project implements a complete authentication system for Flutter that connects to the Backend_Air_App_Users API.

## ✅ Completed Implementation

The authentication system has been fully implemented with the following components:

### 📱 Models
- `User` - User data model with JSON serialization
- `AuthResponse` - Authentication response models (login, register, etc.)
- Generated JSON serialization files

### 🔧 Services
- `ApiService` - HTTP communication with backend API
- `AuthService` - Authentication business logic
- `SecureStorageService` - Secure local storage for tokens

### 🎛️ State Management
- `AuthProvider` - Provider for authentication state management

### 🖥️ Screens
- `LoginScreen` - Modern login interface
- `RegisterScreen` - Complete registration form
- `ProfileScreen` - User profile management
- `HomeScreen` - Main app dashboard

### 🔗 Navigation
- `AuthWrapper` - Automatic navigation based on auth state

## 🚀 How to Run

### 1. Install Flutter
```bash
# Install Flutter using your preferred method
# Or use FVM for version management
curl -fsSL https://fvm.app/install.sh | bash
fvm install stable
fvm use stable
```

### 2. Install Dependencies
```bash
cd /root/air_app
flutter pub get
```

### 3. Generate JSON Serialization Code
```bash
flutter pub run build_runner build
```

### 4. Start Backend API
Make sure the Backend_Air_App_Users is running:
```bash
cd /root/Backend_Air_App_Users
npm run docker:up
```

### 5. Configure API URL
For testing on physical devices, update the API URL in `lib/config/app_config.dart`:
```dart
static const String apiBaseUrl = 'http://YOUR_MACHINE_IP:3000/api';
```

### 6. Run the App
```bash
flutter run
```

## 📚 API Endpoints Used

The app connects to these Backend_Air_App_Users endpoints:

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/logout` - User logout
- `POST /api/auth/refresh-token` - Token refresh
- `GET /api/auth/verify-token` - Token verification

### User Management
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile

## 🔒 Security Features

### Secure Storage
- Access tokens stored using `flutter_secure_storage`
- Automatic encryption on Android/iOS
- Biometric protection when available

### Token Management
- Automatic token refresh
- Secure logout (removes tokens from device and server)
- Token validation before API calls

### Input Validation
- Email format validation
- Password strength requirements
- Username length validation
- Form validation throughout the app

## 🏗️ Architecture

### Service Layer
- **ApiService**: Handles all HTTP requests to the backend
- **AuthService**: Manages authentication flow and token lifecycle
- **SecureStorageService**: Handles secure local storage

### State Management
- **AuthProvider**: Uses Provider pattern for state management
- Reactive UI updates based on authentication state
- Automatic navigation between auth and main app

### UI Components
- Modern Material Design 3 interface
- Responsive layouts
- Loading states and error handling
- User-friendly error messages

## 🧪 Testing

### Manual Testing Checklist

1. **Registration Flow**
   - [ ] Create new account
   - [ ] Validate required fields
   - [ ] Handle duplicate email/username
   - [ ] Success message and navigation

2. **Login Flow**
   - [ ] Login with valid credentials
   - [ ] Handle invalid credentials
   - [ ] Remember login state
   - [ ] Navigate to home screen

3. **Profile Management**
   - [ ] View profile information
   - [ ] Edit profile fields
   - [ ] Save changes
   - [ ] Handle validation errors

4. **Authentication State**
   - [ ] Auto-login on app restart
   - [ ] Token refresh on expiry
   - [ ] Logout functionality
   - [ ] Navigation based on auth state

## 🔧 Troubleshooting

### Common Issues

1. **Connection Errors**
   - Verify backend is running on port 3000
   - Check API URL configuration
   - For physical devices, use machine IP instead of localhost

2. **Build Errors**
   - Run `flutter clean && flutter pub get`
   - Regenerate code: `flutter pub run build_runner build --delete-conflicting-outputs`

3. **Storage Issues**
   - Clear app data on device
   - Check secure storage permissions

### Development Tips

1. **API Testing**
   - Use backend's health endpoint: `http://localhost:3000/health`
   - Test API endpoints directly with curl or Postman

2. **State Debugging**
   - AuthProvider includes debugging prints
   - Check Flutter DevTools for state changes

3. **Network Issues**
   - Enable network access in Android manifest
   - Configure iOS info.plist for HTTP connections

## 📈 Next Steps

The authentication system is ready for production use. Consider adding:

1. **Email Verification**
2. **Password Reset**
3. **Biometric Authentication**
4. **Social Login**
5. **Multi-factor Authentication**

## 📄 File Structure

```
lib/
├── config/
│   └── app_config.dart
├── models/
│   ├── user.dart
│   ├── user.g.dart
│   ├── auth_response.dart
│   └── auth_response.g.dart
├── providers/
│   └── auth_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── profile_screen.dart
│   └── register_screen.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── secure_storage_service.dart
├── widgets/
│   └── auth_wrapper.dart
└── main.dart
```

The system is complete and ready for use! 🎉
