import 'package:get/get.dart';

class MyLocale implements Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'ar': {
          // Language
          '1': 'عربي',
          '2': 'انكليزي',
          // Login
          'welcome': 'مرحبا',
          'glad to see you!': 'سعيد برؤيتك',
          'login': 'تسجيل دخول',
          'forgotPassword': 'نسيت كلمة المرور',
          'enterEmail': 'أدخل الايميل',
          'enterPassword': 'أدخل كلمة السر',
          'remember me': 'تذكرني',
          'sign in with google': 'تسجيل دخول مع',
          'create account': 'إنشاء حساب',
          'to get started now': 'من أجل أن تبدأ الاّن!',
          'do not have': 'لا تملك حساب؟',
          'Sign in': 'إنشاء حساب',
          'Already have an': 'هل لديك حساب؟',
          'warning': 'تحذير',
          'no Internet Connection': 'لا يوجد اتصال بالانترنت',
          'form':'استمارة',
          'form field is not valid':'حقل الاستمارة غير صحيح',
          'please enter an email':'الرجاء إدخال الايميل',
          'please enter a valid email':'الرجاء إدخال الايميل الصحيح',
          'please enter a password':'الرجاء إدخال كلمة المرور',
          'password must be at least 6 characters long':'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
          'display name cannot be empty':'الرجاء إدخال الاسم الكامل',
          'display name must be between 3 and 20 characters':'الاسم يجب أن يكون بين 3 إلى 20 حرف',
          // Sign In
          'enterFullName': 'أدخل الاسم الكامل',
          'enterBio': 'أدخل السيرة الذاتية',
          'resetPassword': 'إعادة تعيين كلمة المرور',
          'pleaseEnter':
              'الرجاء إدخال عنوان البريد الالكتروني الذي ترغب في إرسال معلومات إعادة تعيين كلمة مرور إليه',
          'success': 'نجاح',
          'loginSuccess': 'تم تسجيل الدخول بنجاح',
          'Account has been created': 'تم إنشاء الجساب',
          // Home Screen
          'home':'منزل',
          'search':'بحث',
          'following':'متابعهم',
          'me':'أنا',
          // Comment Screen
          'new Comment...':'تعليق جديد...',
          // Search Screen
          'searchs': 'ابحث هنا...',
          // Profile Screen
          'Loading': 'تحميل...',
          'followers': 'متابعون',
          'likes':'إعجابات',
          'signOut': 'تسجيل خروج',
          'follow': 'متابعة',
          'unFollow': 'عدم متابعة',
          'settings': 'الاعدادات',
          'translation': 'الترجمة',
          'theme': 'السمة',
          // Settings Screen
          'account Settings': 'اعدادات الحساب',
          'update your profile:': 'تحديث الملف الشخصي:',
          'update Now': 'تحديث الاّن',
        },
        'en': {
          // Language
          '1': 'Arabic',
          '2': 'English',
          // Login
          'welcome': 'Welcome',
          'glad to see you!': 'Glad to see you!',
          'login': 'Login',
          'forgotPassword': 'Forgot Password',
          'remember me': 'Remember Me',
          'sign in with google': 'SignIn With Google',
          'enterEmail': 'Enter Email Address',
          'enterPassword': 'Enter Password',
          'do not have': 'Don\'t have an account?',
          'Sign in': 'Sign in',
          'create account': 'Create Account',
          'to get started now': 'to get Started Now!',
          'Already have an': 'Already have an account?',
          'warning': 'Warning',
          'no Internet Connection': 'No Internet Connection',
          'form':'Form',
          'form field is not valid':'Form field is not valid',
          'please enter an email':'Please enter an email',
          'please enter a valid email':'Please enter a valid email',
          'please enter a password':'Please enter a password',
          'password must be at least 6 characters long':'Password must be at least 6 characters long',
          'display name cannot be empty':'Please enter the fullName',
          'display name must be between 3 and 20 characters':'The name must be between 3 and 20 characters',
          // Sign In
          'enterFullName': 'Enter Full Name',
          'enterBio': 'Enter Bio',
          'resetPassword': 'Reset Password',
          'pleaseEnter':
              'Please enter the email address you\'d like your password reset information sent to',
          'success': 'Success',
          'loginSuccess': 'Login Success',
          'Account has been created': 'Account has been created',
          // Home Screen
          'home':'Home',
          'search':'Search',
          'following':'Following',
          'me':'Me',
          // Comment Screen
          'new Comment...':'New Comment...',
          // Search Screen
          'searchs': 'Search here...',
          // Profile Screen
          'Loading': 'Loading...',
          'followers': 'Followers',
          'likes':'Likes',
          'signOut': 'Sign Out',
          'follow': 'Follow',
          'unFollow': 'UnFollow',
          'settings': 'Settings',
          'translation': 'Translation',
          'theme': 'Theme',
          // Settings Screen
          'account Settings': 'Account Settings',
          'update your profile:': 'Update your profile:',
          'update Now': 'Update Now',
        }
      };
}
