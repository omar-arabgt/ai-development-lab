# الدرس 2: بروفة الكارثة — منخرب بإيدنا ومنرجع سالمين

## 🗣️ بالعامية

الحماية بدرس 1 بتمنع الغلط **المتوقع**. بس شو لو صار غلط رغم كل شي — AI عدّل 40 ملف بطريقة غلط، أمر مسح شي ما لازم ينمسح؟ الفرق بين فريق محترف وهاوي مش "ما بيغلطوا" — **"بيرجعوا بأمان وبسرعة"**. ومتل مطافي الحريق: البروفة بتصير **قبل** الحريق، مش وقته.

المبدأ اللي بيغير نفسيتك بالشغل مع AI: **كل شي ملجون بـ git مستحيل يضيع.** لما تعرف إنه في "آلة زمن" تحتك، بتعطي الـ AI حرية أكبر بلا قلق — الشجاعة الحقيقية جاية من شبكة الأمان، مش من الثقة العمياء.

## 🔧 بالتقني — أدوات آلة الزمن

| الوضع | الأداة | شو بتعمل |
|---|---|---|
| خراب **غير ملجون** (uncommitted) | `git restore .` + `git clean -fd` | بترجع الملفات المتتبعة وبتمسح الدخيلة — ثواني |
| خراب **انلجن** بـ commit غلط | `git revert <hash>` | بتعمل commit عكسي بيلغيه — والتاريخ بيظل صادق |
| "ضاع كل شي، وين كنا؟" | `git reflog` | سجل كل حركة للـ HEAD — حتى اللي بتحسبه ضاع، إله أثر هون |
| نقطة حفظ قبل مغامرة | `git branch checkpoint` | متل save point بالألعاب — بترجعلها متى بدك |

## 🧪 التجربة — 3 كوارث بترتيب تصاعدي

### 0. جهّز مسرح الكارثة

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/08-safety-db-guardrails/lesson-2-disaster-drill/playground
git init && git branch -m main
git add lib/ && git commit -m "Baseline: pricing rules and reviewed Arabic labels"
```

(الملفين "الغاليين": قواعد تسعير مضبوطة + ترجمات عربية مراجعة يدوياً — تخيل فيهم 3 أسابيع شغل)

### الكارثة 1 — خراب غير ملجون

خرّب بإيدك بلا رحمة:

```bash
echo "// GARBAGE OVERWRITE" > lib/pricing_rules.dart
rm lib/labels_ar.dart
echo "junk" > lib/random_junk.txt
```

هلق افتح `claude` واطلب:

> Disaster drill: this repo's working tree was just wrecked (overwritten file, deleted file, junk file). Assess the damage with git, then recover everything back to the last commit — and explain each recovery command as you go.

**المتوقع:** `git status` و`git diff` للتشخيص → `git restore .` رجّعت المكتوب فوقه **والممسوح** → `git clean -fd` شالت الدخيل. تحقق بعينك: `cat lib/labels_ar.dart` — الترجمات رجعت حرف بحرف.

### الكارثة 2 — الخراب انلجن 😱

```bash
echo "// broken pricing" > lib/pricing_rules.dart
git commit -am "Update pricing"
```

(الغلطة صارت "رسمية" — بالتاريخ!) بالجلسة:

> The last commit wrecked pricing_rules.dart. Undo it the safe way — keep the history honest — and explain why you chose that method over the alternative.

**المتوقع:** يختار `git revert` (بيضيف commit عكسي) ويشرح ليش مش `reset --hard` (اللي بيمحي تاريخ — خطر على فروع مشتركة). افتح `git log` وشوف القصة كاملة محفوظة: الغلطة **وتصحيحها** — تاريخ صادق.

### الكارثة 3 — عادة نقطة الحفظ (الوقاية)

قبل ما تطلب من AI عملية جريئة، خد عادة السطر الواحد:

```bash
git branch checkpoint-before-refactor
```

بعدين اطلب بالجلسة شي جريء عمداً: *"Aggressively refactor both files — merge them into one file, rename everything"* — وبعد ما يخلص، قرر إنك ما حبيت النتيجة:

```bash
git reset --hard checkpoint-before-refactor
```

رجعت بثانية. هاي العادة = الشجاعة: جرب أي شي، لأنه الرجعة دايماً بثانية.

### سؤال التثبيت — الأخير قبل الموديول الأخير

كل هالسحر اشتغل لأنه **الكود بـ git**. بالشركة في شي ثمين مش بـ git: **قاعدة البيانات**. ليش استراتيجية "باك أب الـ DB" أصعب من هيك — وشو أهم سؤال بتسأله عن أي باك أب؟ *(تلميح: الباك أب اللي ولا مرة جربتوا ترجعوا منه هو أمنية، مش باك أب — بروفة الاسترجاع هي الباك أب الحقيقي. وهاد حرفياً نفس مبدأ "حارس ما شفته بيصد")*

## 🏢 كيف تنقلها لمشاريع الشركة

*(للمستقبل — بجلسة النقل المخصصة)*

قانون فريق من ثلاث نقاط: (1) كل شغل AI على branches — main محمي أصلاً؛ (2) قبل أي عملية واسعة: checkpoint branch — سطر واحد؛ (3) للـ DB: باك أب آلي **مع بروفة استرجاع شهرية مجدولة** — والبروفة نفسها مهمة أتمتة لموديول 09. النتيجة النفسية الأهم: فريق ما بيخاف من الـ AI لأنه عارف إنه كل شي قابل للرجوع.
