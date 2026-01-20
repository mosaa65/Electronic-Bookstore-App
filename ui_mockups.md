# 🎨 تصاميم واجهات المستخدم (UI Mockups)

## نظرة عامة
هذا الملف يحتوي على جميع تصاميم واجهات التطبيق مع شروحات تفصيلية.

---

## 📱 الشاشات الرئيسية

### 1. شاشة تسجيل الدخول

![شاشة تسجيل الدخول](C:/Users/mousa/.gemini/antigravity/brain/917f753b-6794-4f9d-9d18-e0b327c260f2/login_screen_design_1768937773511.png)

#### المكونات:
- ✅ شعار التطبيق (أيقونة كتاب)
- ✅ اسم التطبيق "متجر الكتب"
- ✅ حقل البريد الإلكتروني
- ✅ حقل كلمة المرور
- ✅ زر تسجيل الدخول
- ✅ تسجيل الدخول بـ Google
- ✅ رابط نسيت كلمة المرور
- ✅ رابط إنشاء حساب جديد

#### الألوان:
- Primary: Indigo (#6366F1)
- Background: Light gradient
- Text: Dark gray

---

### 2. الصفحة الرئيسية

![الصفحة الرئيسية](C:/Users/mousa/.gemini/antigravity/brain/917f753b-6794-4f9d-9d18-e0b327c260f2/home_screen_design_1768937793226.png)

#### الأقسام:
1. **شريط التنقل العلوي**
   - أيقونة القائمة
   - اسم التطبيق
   - أيقونة البحث
   - أيقونة الملف الشخصي

2. **الكتب المميزة**
   - عرض أفقي منزلق (Horizontal Scroll)
   - أغلفة كبيرة وجذابة
   - يعرض الكتب التي `isFeatured = true`

3. **الفئات**
   - أزرار دائرية ملونة
   - تصنيفات: (روايات، علمية، دينية، تقنية)
   - قابلة للتمرير أفقياً

4. **الأكثر مبيعاً**
   - عرض شبكي (Grid View)
   - بطاقات للكتب تحتوي على:
     - غلاف الكتاب
     - العنوان
     - التقييم (نجوم)
     - السعر

---

### 3. تفاصيل الكتاب

![تفاصيل الكتاب](C:/Users/mousa/.gemini/antigravity/brain/917f753b-6794-4f9d-9d18-e0b327c260f2/book_details_screen_1768937815695.png)

#### المكونات:
1. **الرأس**
   - زر الرجوع
   - أيقونة المفضلة
   - أيقونة السلة

2. **معلومات الكتاب**
   - غلاف كبير
   - العنوان
   - اسم المؤلف
   - التقييم (نجوم + رقم + عدد المراجعات)
   - السعر بخط كبير وواضح

3. **زر الإضافة للسلة**
   - زر كبير بتدرج لوني
   - نص "إضافة إلى السلة"

4. **الوصف**
   - عنوان "الوصف"
   - نص الوصف التفصيلي

5. **التفاصيل**
   - عدد الصفحات
   - الفئة
   - اللغة

6. **المراجعات**
   - عرض أولي للمراجعات
   - إمكانية عرض الكل

---

## 🎨 نظام التصميم (Design System)

### الألوان

```
Primary Color:    #6366F1 (Indigo)
Secondary Color:  #F59E0B (Amber)
Background:       #F9FAFB
Card:             #FFFFFF
Text Primary:     #111827
Text Secondary:   #6B7280
Success:          #10B981
Error:            #EF4444
```

### الخطوط

```
العربية: Cairo, Tajawal, Almarai
الإنجليزية: Inter, Roboto
```

### المسافات

```
Padding Small:    8px
Padding Medium:   16px
Padding Large:    24px
Border Radius:    12px
Card Radius:      16px
```

### الظلال

```dart
// Card Shadow
BoxShadow(
  color: Colors.black.withOpacity(0.08),
  blurRadius: 10,
  offset: Offset(0, 4),
)

// Elevated Shadow
BoxShadow(
  color: Colors.black.withOpacity(0.12),
  blurRadius: 16,
  offset: Offset(0, 6),
)
```

---

## 📐 المكونات القابلة لإعادة الاستخدام

### 1. بطاقة الكتاب (BookCard)

```dart
Widget buildBookCard(BookModel book) {
  return Container(
    width: 150,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Book Cover
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          child: CachedNetworkImage(
            imageUrl: book.coverImageURL,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                book.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              // Rating
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(' ${book.ratingText}'),
                ],
              ),
              SizedBox(height: 4),
              // Price
              Text(
                book.formattedPrice,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
```

### 2. زر مخصص (CustomButton)

```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
```

### 3. حقل إدخال مخصص (CustomTextField)

```dart
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.label,
    this.hint,
    this.icon,
    this.obscureText = false,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
```

---

## 🔄 الأنيميشن والتفاعل

### Navigation Transitions

```dart
// Hero Animation للانتقال بين قائمة الكتب وتفاصيل الكتاب
Hero(
  tag: 'book-${book.id}',
  child: Image.network(book.coverImageURL),
)

// Slide Transition
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOut;
    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  },
)
```

### Button Animation

```dart
// Scale animation عند الضغط
InkWell(
  onTap: () {},
  child: AnimatedContainer(
    duration: Duration(milliseconds: 200),
    curve: Curves.easeInOut,
    transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
    child: YourButton(),
  ),
)
```

---

## 📱 Responsive Design

### Breakpoints

```dart
class Responsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static int getCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }
}
```

---

## ✨ المميزات البصرية

### Shimmer Loading

```dart
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    width: 150,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
  ),
)
```

### Pull to Refresh

```dart
RefreshIndicator(
  onRefresh: () async {
    await bookProvider.fetchBooks();
  },
  child: ListView(...),
)
```

---

## 🎯 النصائح للتنفيذ

> [!TIP]
> **استخدم `cached_network_image` للصور**
> - يحسّن الأداء بشكل كبير
> - يقلل من استهلاك البيانات
> - يوفر placeholder و error widgets

> [!IMPORTANT]
> **التصميم المتجاوب مهم جداً**
> - اختبر على أحجام شاشات مختلفة
> - استخدم `MediaQuery` و `LayoutBuilder`
> - تجنب الأبعاد الثابتة

> [!WARNING]
> **الأداء والتحسين**
> - لا تحمّل جميع الكتب مرة واحدة
> - استخدم Pagination
> - استخدم `ListView.builder` بدلاً من `ListView`

---

## 🚀 الخطوات التالية

1. تطبيق هذه التصاميم في Flutter
2. إضافة الأنيميشن والتفاعلات
3. اختبار على أجهزة مختلفة
4. تحسين الأداء

**التصاميم جاهزة للتنفيذ! 🎨**
