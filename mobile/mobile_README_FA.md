<div style="text-align: right;direction: rtl;">

# اپلیکیشن موبایل (Flutter) – پروژه سفارش غذای آنلاین
[English <img src="https://raw.githubusercontent.com/hjnilsson/country-flags/master/svg/us.svg" width="20"/>](README.md)

این پوشه شامل کدهای اپلیکیشن چندسکویی Flutter برای پروژه سفارش غذای آنلاین است.

## فهرست

- [معرفی](#معرفی)
- [فناوری‌ها](#فناوری‌ها)
- [پیش‌نیازها](#پیش‌نیازها)
- [نصب](#نصب)
- [پیکربندی](#پیکربندی)
- [اجرای اپلیکیشن](#اجرای-اپلیکیشن)
- [آزمون‌ها](#آزمون‌ها)
- [هم‌کاری](#هم‌کاری)

## معرفی

اپلیکیشن Flutter یک رابط موبایل برای مشتریان و پیک‌ها فراهم می‌کند تا:
- مشاهده رستوران‌ها و منوها
- ثبت و پیگیری سفارش‌ها به صورت لحظه‌ای
- نمایش محدوده پوشش روی نقشه
- دریافت نوتیفیکیشن برای وضعیت سفارش

## فناوری‌ها

- **Flutter 2.x**
- **Dart 2.x**
- **Provider** (مدیریت وضعیت)
- **HTTP** (ارتباط با API)
- **Google Maps Flutter** (ادغام نقشه)
- **Firebase** (نوتیفیکیشن و آنالیتیکس)

## پیش‌نیازها

- Flutter SDK 2.0 یا بالاتر
- Dart 2.12 یا بالاتر
- Xcode (برای iOS)
- Android SDK و Android Studio (برای Android)

## نصب

1. کلون مخزن و ورود به پوشه موبایل:
   ```bash
   git clone <repo-url>
   cd mobile_app
   ```

2. نصب وابستگی‌ها:
   ```bash
   flutter pub get
   ```

3. (اختیاری) تولید کد سریال‌سازی JSON:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## پیکربندی

1. فایل `links.dart` موجود در پوشه `recource` را باز کنید:
   ```dotenv
     static String server = 'http://172.17.49.190:80'; #Change the address with server address
   ```

2. مطمئن شوید که سرور بک‌اند در حال اجرا است و دستور `process_trans` را قبلاً اجرا کرده‌اید.

## اجرای اپلیکیشن

- **اندروید**:
  ```bash
  flutter run -d android
  ```
- **iOS**:
  ```bash
  flutter run -d ios
  ```

## آزمون‌ها

اجرای تست‌ها:
```bash
flutter test
```

## هم‌کاری

1. پروژه را فورک کنید و یک شاخه جدید بسازید.
2. از الگوهای موجود پیروی کنید.
3. برای ویژگی‌ها یا رفع باگ‌ها تست بنویسید.
4. Pull Request ارسال کنید.
</div>