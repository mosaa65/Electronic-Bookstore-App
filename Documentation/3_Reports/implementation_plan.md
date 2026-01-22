# خطة إكمال متجر الكتب الإلكتروني 🚀

تم تشخيص الحالة الحالية للمشروع: الهيكل الأساسي موجود، المصادقة تعمل، ولكن واجهات المدير مفقودة وقاعدة البيانات فارغة.

## المقترحات والحلول

### 1. نظام صلاحيات المدير (Admin Access)
بما أنه لا يوجد حالياً واجهة لتسجيل مدير، سنتبع الطريقة التالية:
- **الطريقة المؤقتة:** سأقوم بتعديل دالة [register](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/presentation/providers/auth_provider.dart#94-151) لإضافة حقل `role` يسمح باختيار 'admin' أو استخدام 'Secret Token' عند التسجيل.
- **إصلاح أخطاء التسجيل:** معالجة مشكلة (Pigeon cast error) في `firebase_auth` لضمان استمرار العملية وحفظ البيانات في Firestore حتى في حال حدوث خطأ في استجابة المترجم.

### 2. البيانات الأولية (Data Seeding)
- تفعيل وظيفة [seedBooks](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/data/repositories/book_repository.dart#146-217) الموجودة في [BookRepository](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/data/repositories/book_repository.dart#4-218).
- إضافة وظيفة `seedCategories` لملء تصنيفات الكتب.
- ربط هذه الوظائف بزر "تهيأة المشروع" في شاشة مختفية أو عند تسجيل دخول المدير لأول مرة.

### 3. بناء الواجهات المفقودة (Missing UI)
- **مجلد `admin`:** إنشاء [AdminDashboard](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/presentation/screens/admin/admin_dashboard.dart#9-15), [AddEditBookScreen](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/presentation/screens/admin/add_edit_book_screen.dart#6-13), و `ManageCategories`.
- **مجلد `books`:** إكمال [BookDetailsScreen](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/presentation/screens/books/book_details_screen.dart#8-19) وربطها بالبيانات الحقيقية بدلاً من الـ placeholders.
- **مجلد `cart`:** تفعيل عمليات الحذف والإضافة الحقيقية في Firestore.

---

## المكونات المتأثرة

### [Presentation Layer]

#### [NEW] [admin_dashboard.dart](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/presentation/screens/admin/admin_dashboard.dart)
واجهة تعرض إحصائيات سريعة للكتب والمستخدمين وأزرار الإدارة.

#### [NEW] [add_edit_book_screen.dart](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/presentation/screens/admin/add_edit_book_screen.dart)
نموذج لإدخال بيانات كتاب جديد أو تعديل الحالي.

#### [MODIFY] [login_screen.dart](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/presentation/screens/auth/login_screen.dart)
إضافة منطق التوجيه: إذا كان المستخدم `admin` يتم نقله للوحة التحكم، وإذا كان `user` للصفحة الرئيسية.

---

## خطة التحقق

### الاختبارات اليدوية
1. تسجيل حساب جديد وتغيير رتبته يدوياً في Firestore (أو عبر الكود).
2. التأكد من ظهور خيارات "لوحة تحكم المدير" في القائمة الجانبية فقط للمدير.
3. إضافة كتاب جديد والتأكد من ظهوره فوراً في الصفحة الرئيسية.
4. محاكاة عملية شراء والتأكد من ظهور الكتاب في "مكتبتي".
