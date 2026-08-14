# الدرس 3: من التذكرة للـ PR — خط الإنتاج كامل

## 🗣️ بالعامية

هاد الدرس ما فيه ولا مفهوم جديد — **وهاي بالضبط روعته.** كل قطعة تعلمتها رح تشتغل بدورها، بخط واحد متواصل:

```
تذكرة Linear (موديول 05)
  → أسئلة قبل التخمين (موديول 02، درس 3)
    → spec محكم بقراراتك (موديول 02، درس 1)
      → حكم محايد (موديول 02، درس 2)
        → تنفيذ لحد الأخضر
          → branch + push (موديول 01)
            → PR بيمرق عالبوابات الثلاثة (موديول 03)
              → التذكرة بتتحدث لحالها برابط الـ PR (موديول 05)
```

من "طلب من فريق المبيعات مكتوب بتذكرة" لـ "كود مدموج بالبوابات الكاملة والتذكرة محدثة" — والبشر بمكانين بس: **القرارات** (أجوبة الأسئلة) و**الدمج**.

## 🎯 الـ playground

`lib/result_sorter.dart` — stub فرز نتائج البحث. التذكرة اللي رح تزرعها **ناقصة قصداً** (متل طلبات الحياة الحقيقية): "رتبوا النتائج من الأرخص" — طيب والسيارات اللي بدون سعر ("اتصل بالوكيل")؟ والتعادل؟ هاي أسئلة الـ AI لازم يمسكها.

## 🧪 التجربة

### 1. ازرع التذكرة (الطلب الواقعي الناقص)

بأي جلسة claude:

> Create one issue in my lab workspace team: title "sort search results by price" description "sales team request: buyers want to sort search results starting from the cheapest car. note that some listings have no price (dealer asks buyers to call). لازم تكون جاهزة قبل نهاية الأسبوع"

### 2. افتح الجلسة بالـ playground وشغّل الخط

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/05-linear-triage/lesson-3-ticket-to-pr/playground
git init
git branch -m main
git add lib/
git commit -m "Initial state: sorter stub awaiting the ticket-driven spec"
claude
```

> ⚠️ فحص الأمان المعتاد: `git rev-parse --show-toplevel` لازم ينتهي بـ `.../lesson-3-ticket-to-pr/playground`

**المرحلة أ — التذكرة والأسئلة:**

> Fetch the "sort search results by price" issue from my lab workspace. Review it as an implementer: list every ambiguity or missing decision as numbered questions. Do NOT implement or assume anything yet.

(توقع يسأل عن: مكان السيارات بلا سعر؟ ترتيب التعادل؟ نوع الفرز ثابت ولا خيار من المستخدم؟...)

**المرحلة ب — قراراتك:** جاوب على أسئلته (اقتراحي: بلا سعر → بآخر القائمة؛ تعادل → حافظ عالترتيب الأصلي؛ الدالة بترجع قائمة جديدة ما بتعدل الأصلية)، بعدين:

> Write specs/price-sort.md from the ticket plus my decisions (Given/When/Then table), then tool/spec_check.dart as the referee — no implementation yet.

**المرحلة ج — راجع الحكم** (صرت محترف: الحدود؟ قائمة فاضية؟ كل النتائج بلا أسعار؟) بعدين:

> Implement lib/result_sorter.dart until the referee passes.

**المرحلة د — سكّر الحلقة:**

> Commit your work on a branch named feature/price-sort, then comment on the Linear issue: a summary of what was implemented and where the code lives, and move the issue to "In Review".

افتح Linear — التذكرة تحركت لـ In Review وعليها تعليق التسليم. **التذكرة عرفت مصير نفسها لحالها.**

### 3. لمن بدك الجولة الكاملة مع GitHub

هاد الـ playground ريبو محلي (بلا remote) عشان التمرين خفيف — بس لو بدك النسخة الاستعراضية الكاملة (للعرض يوم الأحد مثلاً 😉): اعمل نفس التمرين على ريبو الـ lab نفسه بأسلوب درس 3 موديول 04، والـ PR بيمرق على البوابات الحقيقية.

### سؤال التثبيت

بهالخط الكامل، عدّ المحطات اللي **لازم** يوقف فيها إنسان — واشرح ليش كل وحدة منهم بالذات ما بتنشال حتى بأقصى أتمتة. *(عندي جوابي — قارنه بجوابك: القرارات عالأسئلة، ودمج الـ PR. الأولى لأنها تفضيلات منتج مش حقائق كود، والثانية لأنها المسؤولية القانونية/المهنية عن شو بيدخل الإنتاج)*

## 🏢 كيف تنقلها لمشاريع الشركة

*(للمستقبل — بجلسة النقل المخصصة)*

هاد هو الـ workflow الكامل لأي تذكرة متوسطة الحجم: PM بيكتب الطلب → AI بيرجع أسئلة → PM بيجاوب (5 دقائق بدل ميتنغ) → spec وreferee وكود وPR جاهزين → مراجعة ودمج. مع موديول 09: التذكرة اللي بتوصل لعمود "Ready for AI" بلوحة Linear بتطلق الخط لحالها.
