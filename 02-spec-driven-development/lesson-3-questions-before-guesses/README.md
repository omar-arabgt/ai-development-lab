# الدرس 3: الأسئلة قبل التخمين — ختام الموديول

## 🗣️ بالعامية

بدرس 2 اكتشفنا (ونحنا بندقق سوا) إنه حتى العقد المنيح فيه ثقوب — والـ AI ساعتها **سد الثقب بتخمينة منطقية** بدون ما يخبرنا. مرقت لأنه التخمينة كانت معقولة. بس تخيلها كانت بقرار مالي؟ بنقطة بتفرق مع الزبون؟

المقاول الشاطر مش اللي بينفذ أسرع — اللي **بيتصل فيك قبل ما يصب الباطون**: "الرسمة ما بتحدد وين باب الكراج، وين بدك ياه؟". هالدرس منعلّم الـ AI (ومنعلّمك انت) نفس العادة: **العقد الناقص بيرجع أسئلة، مش كود مليان تخمينات مخفية**.

الـ spec بالـ playground مفخخ عمداً 😈 — شكله سليم بأول قراءة، بس جواته كم قرار ناقص ما بتشوفهم إلا لما تحاول تنفذ. التمرين: خلي الـ AI يقرأه **كمدقق عقود** ويطلعلك قائمة الأسئلة قبل ولا سطر كود — وبعدين انت (صاحب المنتج) بتجاوب، الـ spec بيتحدث، وبعدها بس التنفيذ.

## 🔧 بالتقني

هاي الخطوة اسمها **Spec Review / Ambiguity Surfacing** — وهي أرخص لحظة لتصليح الأخطاء بكل دورة التطوير:

```
كلفة تصليح القرار الغلط:
بالـ spec (سؤال وجواب)     : دقيقة
بالكود (إعادة تنفيذ)       : ساعة
بالإنتاج (زبون انضرّ)      : 💸😱
```

والصيغة القياسية للطلب — احفظها، هي سطر واحد بيتحط قدام أي spec:

> Before writing any code, review this spec **as an implementer**: list every ambiguity, missing decision, or contradiction you would otherwise have to guess. Number them. Do NOT implement or assume anything yet.

بعد ما توصلك الأسئلة وتجاوب عليها، الدورة بتكمل بنمط درس 2: تحديث الـ spec → توليد الحكم → مراجعة الحكم → تنفيذ لحد الأخضر. **هيك اكتملت السلسلة الذهبية:** spec → أسئلة → spec محكم → حكم مراجع → كود موثوق.

## 🎯 الـ playground

- `specs/loyalty-points.md` — عقد نقاط ولاء **مفخخ عمداً** (لا تقرأه بتمعن قبل التجربة — خلي الـ AI يفاجئك 😄)
- `lib/points_calculator.dart` — stub

## 🧪 التجربة — الدورة الكاملة

### 0. التجهيز

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/02-spec-driven-development/lesson-3-questions-before-guesses/playground
git init
git branch -m main
git add lib/ specs/
git commit -m "Initial state: deliberately incomplete spec"
claude
```

### الخطوة 1 — التدقيق (ممنوع الكود وممنوع التخمين)

> Before writing any code, review specs/loyalty-points.md as an implementer: list every ambiguity, missing decision, or contradiction you would otherwise have to guess. Number them. Do NOT implement or assume anything yet.

**التوقع:** قائمة أسئلة. عدّها — إذا طلّع 3+ أسئلة جوهرية، الـ spec المفخخ انكشف. (أمثلة على شو لازم يمسك: التقريب — 250 دينار كم نقطة؟ شو يعني "weekend" بالضبط — الجمعة والسبت متل الأردن ولا السبت والأحد؟ بأي توقيت منحكم عالتاريخ؟ شو بيصير بمبلغ صفر أو سالب؟)

### الخطوة 2 — انت صاحب القرار

جاوب على أسئلته **بقراراتك انت** (مثلاً: تقريب لتحت — 250 دينار = 2 نقطة؛ الويكند جمعة+سبت بتوقيت عمّان؛ صفر أو سالب = ArgumentError). بعدين:

> Update specs/loyalty-points.md with these decisions — rewrite it with a proper Given/When/Then acceptance criteria table like specs we wrote before.

### الخطوة 3 — دورة درس 2 كاملة

> Now write tool/spec_check.dart from the updated spec (referee first, no implementation).

راجع الحكم (صرت خبير 😎)، وبعدين:

> Implement lib/points_calculator.dart and keep going until the referee passes.

وتحقق: `dart tool/spec_check.dart`

### سؤال التثبيت

ليش خطوة 1 لازم تصير **قبل** كتابة الحكم، مش بعده؟ *(فكر: لو الـ AI كتب الحكم من spec ناقص — الحكم نفسه رح يبني على تخمينات، وبتصير التخمينة "معيار رسمي" بدون ما حدا قررها)*

## 🏢 كيف تنقلها لمشاريع الشركة

*(للمستقبل — بجلسة النقل المخصصة)*

هاي الدورة هي الـ workflow الكامل لأي ميزة بالمصنع: تذكرة Linear → spec أولي → **جولة أسئلة (الـ AI بيدقق، الفريق بيقرر)** → spec محكم → حكم → تنفيذ → PR والحكم بيركض بالـ CI (موديول 03 الجاي). لاحظ وين البشر بهالخط: عالقرارات بس — وهاد بالضبط مكانهم الصح.
