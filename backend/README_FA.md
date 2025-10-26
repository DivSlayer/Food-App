<div dir="rtl" style="text-align: right">

# بک‌اند (Django) – پروژه تحویل غذا
[English <img src="https://raw.githubusercontent.com/hjnilsson/country-flags/master/svg/us.svg" width="20"/>](README.md)

## فهرست مطالب

- [بک‌اند (Django) – پروژه تحویل غذا](#بکاند-django--پروژه-تحویل-غذا)
   - [فهرست مطالب](#فهرست-مطالب)
   - [بررسی اجمالی](#بررسی-اجمالی)
   - [فناوری‌ها](#فناوریها)
   - [پیش‌نیازها](#پیشنیازها)
   - [نصب](#نصب)
- [Windows](#windows)
- [Linux / macOS](#linux--macos)
   - [پیکربندی](#پیکربندی)
   - [مهاجرت دیتابیس](#مهاجرت-دیتابیس)
   - [دستورات مدیریت](#دستورات-مدیریت)
   - [اجرای سرور](#اجرای-سرور)
   - [اندپوینت های API](#نقاط-انتهایی-api)
      - [API داشبورد](#api-داشبورد)
      - [API مشتری](#api-مشتری)
   - [اجرای تست‌ها](#اجرای-تستها)
   - [مشارکت](#مشارکت)

## بررسی اجمالی

این بک‌اند بر پایه Django REST API اندپوینت های زیر را فراهم می‌کند:
- احراز هویت کاربران (مالکین، مشتریان، پیک‌ها)
- مدیریت رستوران‌ها، شعب و منوها
- مدیریت مناطق تحت پوشش روی نقشه
- محاسبه برآوردهای مالی
- پردازش و پیگیری سرعت و وضعیت تحویل

## فناوری‌ها

- **پایتون ۳.۸ به بالا**
- **Django ۳.x**
- **Django REST Framework**
- **PostgreSQL** (پیشنهاد شده) یا **SQLite**

## پیش‌نیازها

- پایتون ۳.۸ یا بالاتر
- pip
- Virtualenv (اختیاری ولی پیشنهاد شده)
- دیتابیس PostgreSQL (یا SQLite برای توسعه)

## نصب

1. رپوزیتوری را کلون کرده و به دایرکتوری backend بروید:
<pre dir="rtl" style="text-align: right"><code>
git clone https://github.com/DivSlayer/Food-App.git
cd backend
</code></pre>

2. ساخت و فعال‌سازی محیط مجازی (اختیاری):
<pre dir="rtl" style="text-align: right"><code>
python -m venv venv
# Windows
.env\Scriptsctivate   
# Linux / macOS
source venv/bin/activate
</code></pre>

3. نصب پیش نیاز ها:
<pre dir="rtl" style="text-align: right"><code>
pip install -r requirements.txt
</code></pre>

## پیکربندی

1. فایل `current_server.txt` را باز کرده و آدرس سرور خود را در آن بنویسید.

## مهاجرت دیتابیس

1. ابتدا مایگریشن‌ها را بسازید:
<pre dir="rtl" style="text-align: right"><code>
python manage.py makemigrations
</code></pre>

2. مایگریشن‌ها را اعمال کنید تا اسکیمای دیتابیس تنظیم شود:
<pre dir="rtl" style="text-align: right"><code>
python manage.py migrate
</code></pre>

## دستورات مدیریت

قبل از شروع سرور، **باید** دستور مدیریت سفارشی `process_trans` را اجرا کنید تا جداول ترجمه و سایر پیش‌نیازها راه‌اندازی شوند:
<pre dir="rtl" style="text-align: right"><code>
python manage.py process_trans
</code></pre>

## اجرای سرور

سرور در حالت توسعه را اجرا کنید:
<pre dir="rtl" style="text-align: right"><code>
python manage.py runserver
</code></pre>
<p dir='rtl' style="text-direction:rtl">API در دسترس خواهد بود در `http://localhost:8000/api/`.</p>

## اندپوینت های API

### API داشبورد

| اندپوینت                    | روش         | توضیحات                                                |
|---------------------------------|-------------|--------------------------------------------------------|
| `/api/dashboard/token/`         | POST        | دریافت توکن احراز هویت                                 |
| `/api/dashboard/token/refresh/` | POST        | بررسی توکن رفرش و بازگرداندن توکن دسترسی جدید          |
| `/api/dashboard/details`        | GET         | بازگرداندن جزئیات رستوران                              |
| `/api/dashboard/transaction/`   | GET یا POST | بازگرداندن لیست تراکنش‌های رستوران و ایجاد تراکنش جدید |
| `/api/dashboard/food/`          | GET یا POST | بازگرداندن لیست غذاهای رستوران و ایجاد غذای جدید       |
| ...                             | ...         | ...                                                    |

### API مشتری

| اندپوینت                  | روش         | توضیحات                                              |
|-------------------------------|-------------|------------------------------------------------------|
| `/api/account/token/`         | POST        | دریافت توکن احراز هویت                               |
| `/api/account/token/refresh/` | POST        | بررسی توکن رفرش و بازگرداندن توکن دسترسی جدید        |
| `/api/account/details`        | GET         | بازگرداندن جزئیات مشتری                              |
| `/api/transaction/`           | GET یا POST | بازگرداندن لیست تراکنش‌های مشتری و ایجاد تراکنش جدید |
| `/api/close-res/`             | GET یا POST | بازگرداندن لیست غذاهای نزدیک‌ترین رستوران‌ها         |
| ...                           | ...         | ...                                                  |

*(برای لیست کامل اندپوینت های به کد یا اسکیمای API مراجعه کنید.)*

## اجرای تست‌ها

برای اجرای مجموعه تست‌ها:
<pre dir="rtl" style="text-align: right"><code>
python manage.py test
</code></pre>

## مشارکت

1. مخزن را فورک کنید.
2. یک شاخه جدید برای قابلیت یا رفع باگ خود ایجاد کنید.
3. برای تغییرات خود تست و مستندات بنویسید.
4. درخواست Pull Request ارسال کنید.

---

کدنویسی خوش بگذره! 🍔🚀

</div>
