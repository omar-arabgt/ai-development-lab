# الدرس 2: الصبحية — تقرير يومي بيكتب حاله من مصدرين

## 🗣️ بالعامية

كل صبح، بالشركات المرتبة، حدا بيفتح Sentry يشوف شو انكسر بالليل، وبيفتح التحليلات يشوف كيف كان اليوم، وبيكتب رسالة للفريق. نص ساعة يومياً، وبتنتسى أول ما الدنيا تزحم.

هالدرس منحولها لأمر واحد: **claude -p بيسأل Sentry (شو انكسر؟) وPostHog (شو صار؟) بنفس المهمة**، وبيكتب تقرير صباحي واحد منظم بملف. أول مرة بالمختبر **مصدرين خارجيين بيشتغلوا سوا** — وهاد جوهر الـ AI Factory: القيمة مش بكل أداة لحالها، بالتركيب.

(وبموديول 09: هاد الأمر نفسه بينحط على مؤقت الساعة 7 الصبح — وبتصحى والتقرير جاهز)

## 🔧 بالتقني

القطعة المفهومية: **التركيب (Composition)**. الجلسة الوحدة عندها بصندوق عدتها أدوات من سيرفرين MCP مختلفين + أدوات الملفات المحلية — والبرومبت بيأمرها تجمع بينهم. ما في أي "تكامل" مبرمج بين Sentry وPostHog — **الـ AI هو نقطة التكامل.**

ولاحظ بالبرومبت: التقرير بينكتب **بملف markdown بمجلد reports/** — مش بس شاشة. الأتمتة الحقيقية بتنتج **artifacts** قابلة للأرشفة والمشاركة، مش كلام بيضيع.

## 🧪 التجربة

### الأمر الواحد

من مجلد الدرس (عشان التقرير ينحفظ هون):

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/07-analytics-posthog/lesson-2-morning-report
claude -p "Write the daily morning report for the car-market lab. Gather: (1) from Sentry lab org (sentrytest): unresolved issues, anything new in the last 24h, and current status of previously fixed ones; (2) from PostHog: yesterday's activity vs the 7-day average — events, platforms, any notable shift. Then write reports/morning-$(date +%Y-%m-%d).md in Arabic with three sections: 🔴 شو انكسر (Sentry), 📊 شو صار (PostHog), ✅ توصية اليوم (one concrete action). Be honest about small-sample noise — hedge where data is thin. Do NOT touch the arabgt org." --allowedTools "mcp__sentry__*,mcp__posthog__*,Write,Bash(date *)"
```

### اقرأ التقرير

```bash
cat reports/morning-*.md
```

**معايير القبول** (صرت بتعرفها 😄): ثلاث أقسام موجودة؟ أرقام PostHog متسقة مع اللي شفته بدرس 1؟ التوصية **فعل ملموس** مش كلام عام؟ وفي **تحوط** عن العينة الصغيرة؟

### سؤال التثبيت — الأخير بالموديول

بالبرومبت حددنا `--allowedTools` بقائمة فيها `Write` بس بدون `Edit` وبدون `Bash` عام (بس `date`). ليش هالتشدد بمهمة قراءة-وتقرير؟ *(تلميح: تذكر المراجع المشلول والوجه الثاني لمبدأ أقل الصلاحيات — القائمة الصح هي بالضبط قد المهمة: يقرأ من مصدرين، يكتب ملف واحد، وخلص. أي شي زيادة = مساحة خطأ ببلاش)*

## 🏢 كيف تنقلها لمشاريع الشركة

*(للمستقبل — بجلسة النقل المخصصة)*

نفس الأمر على Sentry الشركة (قراءة بس) + PostHog الشركة لو تبنوه — والتقرير بيروح لقناة Slack الفريق كل صباح عبر جدولة موديول 09. "الصبحية" اللي بياخدها التيم ليدر من موظف نص ساعة، بتوصله جاهزة الساعة 7:00 — والموظف بيصرف النص ساعة على القرارات بدل التجميع.
