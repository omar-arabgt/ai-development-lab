# الدرس 2: الرحلة — user journey بيتفحص لحاله

## 🗣️ بالعامية

درس 1 فحص **لقطة**: شاشة وحدة، لحظة وحدة. بس المستخدم ما بيعيش بلقطة — بيعيش **رحلة**: بيفتح التطبيق، بيكبس على سيارة، بيشوف تفاصيلها، بيكبس "احجز"، بيستنى تأكيد. وأي حلقة بهالسلسلة تنكسر — الرحلة كلها خربت، حتى لو كل شاشة لحالها "شكلها تمام".

هالدرس منكتب **الرحلة كفحص**: سكربت بيمشي الرحلة كاملة على الـ simulator — بيكبس فعلياً، بينتقل فعلياً، وبيتأكد من كل محطة. وأهم شي: **منثبت إنه حارس حقيقي بالبرهان العكسي** (تذكر أول درس بالمختبر؟) — منكسر الرحلة عمداً ومنشوف الفحص بيصرخ.

## 🔧 بالتقني

الأداة: **integration_test** — باكج رسمي من Flutter (موجود أصلاً بالـ pubspec تبعنا). الفرق عن الـ widget test العادي:

| | Widget test (`flutter test`) | Integration test |
|---|---|---|
| وين بيركض | بيئة اختبار افتراضية | **جهاز/simulator حقيقي** |
| شو بيغطي | widget أو شاشة معزولة | التطبيق كامل من الإقلاع |
| بيمسك | منطق الواجهة | الرحلة الفعلية: تنقّل، حالة، تكامل |

الفحص بيستعمل `WidgetTester`: `tester.tap(find.text('Toyota Corolla 2022'))` → `tester.pumpAndSettle()` (استنى الانتقالات تخلص) → `expect(find.text(...), findsOneWidget)`.

## 🧪 التجربة — بنفس playground درس 1

### 1. وسّع التطبيق (رحلة بدها محطات)

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/06-qa-mobile-testing/lesson-1-visual-qa/playground && claude
```

> Add a details page to this app: tapping a listing opens a page showing the car's name and price and a "احجز الآن" button; tapping it shows a confirmation SnackBar. Keep the design consistent with the list page (including the RTL handling you added).

### 2. اكتب الرحلة كفحص وشغّلها

> Now write integration_test/booking_journey_test.dart covering the full user journey: app launches → listings visible → tap "Toyota Corolla 2022" → details page shows the right name and price → tap the reserve button → confirmation SnackBar appears. Run it on the booted simulator and keep going until it passes.

(بيشغّلها بـ `flutter test integration_test -d <device>` — رح تشوف التطبيق **يتحرك لحاله** عالـ simulator: يكبس، ينتقل، يرجع. لا تلمس شي، هاد الفحص 😄)

### 3. البرهان العكسي — أهم خطوة 🔨

> Now deliberately break the journey: make the reserve button do nothing. Re-run the journey test and show me it FAILS with a clear message. Then restore the fix and show it passing again.

أحمر عند الكسر، أخضر عند الإصلاح — هيك منعرف إنه الفحص **حارس فعلي** مش ديكور. (فحص ما بيقدر يفشل = ما بيحرس شي)

### سؤال التثبيت — الأخير بالموديول

عندك هلق ثلاث طبقات فحص للتطبيق: `flutter test` (منطق) + رحلات integration (سلوك) + الفحص البصري (شكل). بريبو الشركة، **أي وحدة منهم بتحطها بالـ CI على كل PR، وأي وحدة بتخليها بجدولة يومية — وليش؟** *(فكر بالكلفة مقابل التغطية: السريع الرخيص عالبوابة، والبطيء الشامل عالجدول)*

## 🏢 كيف تنقلها لمشاريع الشركة

*(للمستقبل — بجلسة النقل المخصصة)*

الرحلات الذهبية بتطبيقكم (بحث → تفاصيل → تواصل مع البائع، إعلان → حجز...) بتنكتب مرة كـ integration tests — والـ AI بيكتبها بسرعة من وصف الرحلة بالعامية. بعدها: الرحلات بالـ CI الليلي، والفحص البصري بجدولة أسبوعية على الشاشات الرئيسية بالعربي والإنجليزي — ومشاكل "شكله خربان عالآيفون الصغير" بتنمسك قبل ما يشوفها زبون.
