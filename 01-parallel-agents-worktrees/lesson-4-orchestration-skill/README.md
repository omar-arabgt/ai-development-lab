# الدرس 4: الأوركسترا كـ Skill — ختام الموديول

## 🗣️ بالعامية

بدرس 3 كتبت برومبت مايسترو طويل ولصقته. حلو — بس بكرة بدك تعيده، وبعده، وكل مرة يمكن تنسى جملة (مثلاً "commit your work" — وشفنا شو بيصير لما تنتسى 😄).

بموديول 00 تعلمنا القاعدة: **إجراء بتكرره = Skill بتكتبه مرة وحدة**. هالدرس منطبقها على أهم إجراء تعلمناه: برومبت المايسترو بيتحول لـ **`/parallel-tasks`** — بتحكيله شو التاسكات وبس، وكل الباقي (worktrees، agents، merge، تنظيف، تقرير) إجراء مكتوب ومضمون.

**والإضافة الذهبية:** حطينا **قانون درس 2 جوا الـ skill كسياسة صارمة** — قبل ما يشغّل شي بالتوازي، بيفحص: في تاسكين بيلمسوا نفس الملف؟ إذا آه، بيرفض يوازيهم وبيعرض يشغلهم بالتسلسل. يعني الخطأ اللي شفته بعينك بدرس 2، صار **مستحيل يصير بالغلط** — الحكمة انخبزت بالإجراء.

هيك بيكتمل الموديول: تعلمت الآلية بإيدك (درس 1)، شفت وين بتنكسر (درس 2)، فوضتها لمايسترو (درس 3)، وهلق **عبّيتها بزجاجة** قابلة لإعادة الاستخدام (درس 4). هاي الرحلة نفسها اللي رح نعيدها مع كل أتمتة بالمختبر: يدوي → فهم الحدود → تفويض → إجراء ثابت.

## 🔧 بالتقني

الـ skill بـ `.claude/skills/parallel-tasks/SKILL.md` — اقرأه، هو حرفياً برومبت درس 3 بس **مهيكل كإجراء رسمي** مع إضافتين ما كانوا بالبرومبت اليدوي:

1. **Safety checks قبل أي شي:** الريبو موجود؟ الـ working tree نظيف؟ (ما منبلش أوركسترا وفي شغل غير محفوظ ممكن يضيع)
2. **File-overlap check (السياسة الصارمة):** تحديد ملفات كل تاسك → أي تقاطع = ممنوع التوازي لهدول، بيشرح ليش وبيعرض التسلسل كبديل

لاحظ الفرق بين "برومبت بيطلب" و"skill بيفرض": البرومبت بينسى وبيتغير كل مرة؛ الـ skill إجراء موثق، بيتفعل يا يدوياً (`/parallel-tasks`) يا **لحاله** لما يشم طلب توازي من كلامك (الـ description هو الأنف — متل درس 5 موديول 00 بالضبط).

## 🎯 الـ playground

- **الـ skill:** `.claude/skills/parallel-tasks/SKILL.md`
- **3 تاسكات مستقلة:** `lib/loan_calculator.dart` (قسط شهري)، `lib/fuel_cost_estimator.dart` (كلفة بنزين)، `lib/engine_size_formatter.dart` (حجم المحرك cc → لتر)

## 🧪 التجربة — 3 مشاهد

### 0. التجهيز المعتاد

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/01-parallel-agents-worktrees/lesson-4-orchestration-skill/playground
git init
git branch -m main
git add lib/ .claude/
git commit -m "Initial state: parallel-tasks skill + three independent TODOs"
claude
```

> ⚠️ نفس فحص الأمان: `git rev-parse --show-toplevel` → لازم ينتهي بـ `.../lesson-4-orchestration-skill/playground`

### المشهد 1 — الاستدعاء اليدوي

اكتب:

> /parallel-tasks implement the three TODO files under lib/

بتشوف نفس فيلم درس 3 بالضبط (worktrees → 3 agents بالتوازي → merges → رسم → تنظيف) — بس هالمرة **بسطر واحد بدل برومبت فقرة**. بالآخر تحقق: `git log --oneline --graph`.

### المشهد 2 — اختبار السياسة المخبوزة 😈

بجلسة جديدة (أو نفسها)، اطلب:

> Run these two tasks in parallel: (1) add a "price" filter to lib/loan_calculator.dart's docs, (2) rename a variable in lib/loan_calculator.dart

تاسكين على **نفس الملف** — الـ skill لازم **يرفض التوازي**، يشرحلك خطر التعارض، ويعرض التسلسل. قانون درس 2 صار حارس أوتوماتيكي.

### المشهد 3 — التفعيل التلقائي (بدون سلاش)

جلسة جديدة، بدون ما تذكر الـ skill:

> I have three independent TODOs in lib/ — run them at the same time please

لازم يشم الـ skill لحاله من الـ description ("run several tasks in parallel") ويطبق الإجراء كامل — بما فيه الفحوصات.

## 🏢 كيف تنقلها لمشاريع الشركة

*(للمستقبل — بجلسة النقل المخصصة)*

هاد الـ skill هو **أول قطعة بمصنع الشركة**: نفس الملف بينحط بريبو الـ Flutter، وبتصير "شغّل هدول التاسكات بالتوازي" أمر يومي عادي. ولما نوصل لموديول Linear (05)، مصدر التاسكات بيصير التذاكر نفسها بدل كتابتك اليدوية — والـ skill هاد ما بيتغير ولا حرف.
