# الدرس 1: QA بصري — الـ AI بيشوف الشاشة بعيونه

## 🗣️ بالعامية

كل الحراس اللي بنيناهم لهلق **عميان**: الحكم بيفحص أرقام، المراجع بيقرأ كود — بس ولا واحد فيهم بيشوف **الشاشة**. والمشاكل اللي بيشتكي منها المستخدمين (والمتجر!) غالباً بصرية: نص طالع برا حدوده، لون مش مقروء، زر مدفون. هاي ما بتنمسك بفحص كود — بدها **عيون**.

المفاجأة: Claude عنده عيون فعلاً — بيقدر يقرأ الصور. فالوصفة: يبني التطبيق، يشغله عالـ simulator، ياخد **سكرين شوت**، يقرأها كصورة، ويكتبلك تقرير QA بصري. وبعدين — متل حلقة التصحيح الذاتي بدرس الـ Hooks — **يصلّح ويعيد التصوير ويثبت إنه الشكل صار سليم**.

## 🔧 بالتقني

السلسلة كلها أوامر تيرمينال عادية (يعني الـ AI بينفذها بأداة Bash تبعته):

| خطوة | الأمر |
|---|---|
| بناء نسخة simulator | `flutter build ios --simulator` |
| تنصيب على الجهاز المقلع | `xcrun simctl install booted <path>.app` |
| تشغيل | `xcrun simctl launch booted <bundle-id>` |
| **التصوير** | `xcrun simctl io booted screenshot shot.png` |
| **الرؤية** | Claude بيقرأ الـ PNG بأداة Read — الصورة بتدخل بالمحادثة |

الجديد الجوهري هو آخر سطر: لما Claude يقرأ ملف صورة، **بيشوفها فعلاً** (vision) — مش بيقرأ bytes. من هون جاي التقرير البصري.

## 🎯 الـ playground

تطبيق Flutter مصغر "Car Market": قائمة سيارات بستايل ArabGT، فيه **خطأين بصريين مزروعين** (لا تقرأ الكود قبل التجربة 😄 — خلي الـ AI يكتشفهم من الصورة وبعدين قارن).

## 🧪 التجربة

### 0. جهّز المشروع (مرة وحدة)

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/06-qa-mobile-testing/lesson-1-visual-qa/playground
flutter create . --platforms=ios
flutter pub get
open -a Simulator
```

(الـ `flutter create .` بيولّد مجلد iOS محلياً — مقصود مش مرفوع عالريبو. واستنى الـ Simulator يقلع بجهاز iPhone)

### 1. جلسة QA كاملة — برومبت واحد

```bash
claude
```

> Act as a visual QA engineer. Build this app for the iOS simulator, install and launch it on the booted device, take a screenshot with `xcrun simctl io booted screenshot`, then READ the screenshot and write a visual QA report: list every visual defect you can SEE (layout, readability, overflow, contrast), each with severity and the likely offending widget. Do not fix anything yet.

**شو تتوقع:** بعد البناء والتشغيل والتصوير، تقرير فيه (عالأقل) الخطأين المزروعين — واحد منهم صارخ بالصورة 😄

### 2. حلقة التصحيح البصري

> Fix the defects you found, hot-restart or relaunch the app, take a NEW screenshot, and show me before/after proof that the issues are gone.

هاي اللقطة الذهبية: **شاف → صلّح → أعاد التصوير → أثبت بالصورة**. QA بصري بحلقة مغلقة.

### 3. تحقق انت (القاعدة الذهبية)

بص عالـ Simulator بعينك انت: الاسم الطويل ملفوف/مقصوص منيح؟ السعر صار مقروء؟ وافتح الكود وشوف شو غيّر بالضبط.

### سؤال التثبيت

شو الفرق بين ما عمله الـ AI هون وبين `flutter test` عادي — وليش منحتاج **الاثنين**؟ *(فكر: الفحص المنطقي بيمسك "الزر بيعمل شو"، والبصري بيمسك "الزر شكله شو" — والمستخدم بيتعامل مع الاثنين)*

## 🏢 كيف تنقلها لمشاريع الشركة

*(للمستقبل — بجلسة النقل المخصصة)*

عالتطبيق الحقيقي: نفس البرومبت على شاشات المتجر — "صوّر كل شاشة رئيسية بالعربي والإنجليزي وقارن" — بيمسك مشاكل الـ RTL والترجمة اللي انحكت بالميتنغ. والدرس الجاي بيكمل الصورة: بدل شاشة واحدة، **رحلة مستخدم كاملة** بتمشي وتتفحص لحالها.
