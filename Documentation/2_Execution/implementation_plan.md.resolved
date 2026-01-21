# 🛒 خطة تنفيذ: السلة والبيانات الأولية (Cart & Seeding)

## الأهداف
1. تفعيل وظائف سلة التسوق (إضافة، حذف، عرض).
2. ملء قاعدة البيانات بكتب تجريبية (Seeding) لتجربة التطبيق.

## التغييرات المقترحة

### 1. مزود السلة (CartProvider)
إنشاء ملف جديد `lib/presentation/providers/cart_provider.dart` يحتوي على:
- قائمة العناصر في السلة `List<CartItemModel>`.
- دوال:
  - `addToCart(BookModel book)`
  - `removeFromCart(String bookId)`
  - `clearCart()`
  - `get totalAmount`
  - `get itemCount`

### 2. تحديث [main.dart](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/main.dart)
- إضافة `CartProvider` إلى `MultiProvider`.

### 3. إضافة بيانات وهمية (Data Seeding)
تحديث [lib/data/repositories/book_repository.dart](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/data/repositories/book_repository.dart):
- إضافة دالة `seedBooks()` تقوم بإضافة مجموعة كتب تجريبية إلى Firestore إذا كانت المجموعة فارغة.

### 4. واجهة المستخدم
- تحديث [book_details_screen.dart](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/presentation/screens/books/book_details_screen.dart): ربط زر "إضافة للسلة" بـ `CartProvider`.
- تحديث [cart_screen.dart](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/presentation/screens/cart/cart_screen.dart): عرض العناصر الفعلية من `CartProvider`.
- إضافة زر مؤقت في [profile_screen.dart](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/presentation/screens/profile/profile_screen.dart) (أو مكان آخر) لتشغيل `seedBooks()`.

## خطة التحقق (Verification Plan)

### التحقق اليدوي
1. **Seeding**:
   - الدخول للتطبيق.
   - الضغط على زر "Seed Data" (المؤقت).
   - التحقق من ظهور الكتب في [HomeScreen](file:///c:/Users/mousa/Desktop/rakan/ebook_store/lib/presentation/screens/home/home_screen.dart#11-17).
   
2. **Shop Flow**:
   - فتح كتاب من الصفحة الرئيسية.
   - الضغط على "إضافة للسلة".
   - الذهاب للسلة والتحقق من وجود الكتاب.
   - التحقق من السعر الإجمالي.
   - حذف الكتاب والتحقق من تحديث السلة.

### الأوامر
```bash
flutter run -d windows
```
