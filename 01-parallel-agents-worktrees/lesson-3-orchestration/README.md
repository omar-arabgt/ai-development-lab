# الدرس 3: Orchestration — المايسترو

## 🗣️ بالعامية

بدرس 1 و2 **انت** كنت المدير التنفيذي: بتفتح worktrees بإيدك، بتفتح تبويب لكل agent، بتدمج بإيدك. اشتغلت وفهمت الآلية — بس تخيل هيك مع 5 تاسكات؟ 10؟ بتصير سكرتير للـ agents بدل ما يكونوا هم موظفينك 😅

هالدرس منقلب الطاولة: **جلسة Claude وحدة بتصير "المايسترو"** — بتحكيلها شو التاسكات، وهي بتفتح الـ worktrees، بتطلق agent لكل تاسك **بالتوازي**، بتستنى الكل يخلص، بتدمج الشغل، وبتسلمك الرسم النهائي. انت بتطلب مرة وحدة وبتتفرج.

هاي هي الـ **AI Factory** اللي حكى عنها التيم ليدر — بس مصغّرة على طاولة المختبر: مدير واحد، ثلاث عمال، خط إنتاج كامل بيلف لحاله.

## 🔧 بالتقني

اللي بيصير تحت الغطا لما تعطي المايسترو الطلب:

```
جلستك (المايسترو)
│
├─ 1. git worktree add ×3        ← بيجهز مكتب لكل تاسك
│
├─ 2. بيطلق 3 subagents بالتوازي  ← كل واحد context خاص (درس 4 موديول 00!)
│      agent A → مكتبه: task-a/  → بينفذ ويعمل commit
│      agent B → مكتبه: task-b/  → بينفذ ويعمل commit
│      agent C → مكتبه: task-c/  → بينفذ ويعمل commit
│
├─ 3. بيستنى الثلاثة يرجعوا بتقاريرهم
│
└─ 4. git merge ×3 + تنظيف        ← بيجمع الشغل وبيسكّر المكاتب
```

لاحظ كيف الدروس عم تتراكب: subagents (موديول 00 درس 4) + worktrees (درس 1) + قانون تقسيم الملفات (درس 2) = orchestration. كل قطعة تعلمتها لحالها، وهلق بيشتغلوا كفرقة.

**نقطة مهمة:** المايسترو نفسه ما بيكتب كود التاسكات — شغله إدارة: تجهيز، تفويض، دمج. نفس مبدأ الـ Delegation من درس الـ subagents، بس عالمستوى الأعلى.

## 🎯 الـ playground

ثلاث تاسكات **مستقلة تماماً** (قانون درس 2 مطبّق من التصميم):

- `lib/discount_calculator.dart` — حساب سعر بعد الخصم
- `lib/plate_validator.dart` — تحقق من صيغة رقم اللوحة
- `lib/mileage_converter.dart` — تحويل أميال ↔ كيلومترات

## 🧪 التجربة

### 0. جهّز الـ playground كريبو مستقل (نفس روتينك المحفوظ)

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/01-parallel-agents-worktrees/lesson-3-orchestration/playground
git init
git branch -m main
git add lib/
git commit -m "Initial state: three independent TODOs for the orchestration exercise"
```

> ⚠️ **تحقق قبل ما تكمل** — `git rev-parse --show-toplevel` لازم يطبع مسار بينتهي بـ `.../lesson-3-orchestration/playground`. لو طلع مسار ريبو الـ lab — `git init` ما زبطت، لا تكمل.

### 1. افتح جلسة Claude **وحدة بس** بالـ playground

```bash
claude
```

### 2. أعطي المايسترو الطلب الكامل (انسخه كما هو)

> Orchestrate this: create a git worktree under ../playground-worktrees/ for each of the three TODO files (branches: task/discount, task/plate, task/mileage). Then run three agents in parallel — each agent works only inside its own worktree, implements the TODO in its assigned file, and commits with a clear message. When all three are done, merge the three branches back into main here, show me `git log --oneline --graph`, and remove the worktrees.

وهلق **اتفرج**: رح تشوفه يجهز المكاتب، يطلق الثلاثة بالتوازي (بتشوفهم شغالين بنفس الوقت)، وبالآخر يعرضلك الرسم.

### 3. تحقق بنفسك (ما مننسى قاعدتنا: ما منصدق إلا لما نشوف)

```bash
git log --oneline --graph
git worktree list
cat lib/discount_calculator.dart
```

- الرسم لازم يفرجي 3 branches اندمجوا بـ main
- `worktree list` لازم يرجع سطر واحد بس (المكاتب تسكرت)
- الملفات الثلاثة متنفذة بدون ولا UnimplementedError

### 4. سؤال التثبيت (جاوبه لنفسك قبل ما تقلي خلصت)

ليش الدمجات الثلاثة مشيوا بدون ولا CONFLICT، رغم إنه ثلاث agents اشتغلوا بنفس الوقت؟ *(الجواب بدرس 2 — لو عرفته، انت فهمت الموديول كله)*

## 🏢 كيف تنقلها لمشاريع الشركة

*(للمستقبل — الجلسة المخصصة بآخر المختبر، مش هلق)*

هاد النمط حرفياً هو خط الإنتاج: بتوصل قائمة تاسكات من Linear (موديول 05 لاحقاً)، مايسترو بيقسمها على agents بالتوازي — كل تاسك بملفاته المستقلة — وبيرجعلك PRs جاهزة للمراجعة. الفرق الوحيد عن اليوم: القائمة بتيجي من webhook بدل ما تكتبها انت.
