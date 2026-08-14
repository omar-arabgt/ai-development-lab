# الدرس 3: الدورة الكاملة — من crash لـ PR بأمر واحد

## 🗣️ بالعامية

بدرس 2 عديت الكبسات وقلت "كتير" 😄. هالدرس منشيلها كلها إلا **وحدة**: بتكتب أمر واحد بالتيرمينال، وبتتفرج على الأنبوب كامل يشتغل لحاله — يسحب الخطأ من Sentry، يحقق بالكود، يفتح branch، يصلّح، يثبت الإصلاح بالتشغيل، يعمل commit وpush، ويسلمك رابط جاهز لفتح الـ PR.

**والكبسة الوحيدة الباقية — قصداً — هي فتح ودمج الـ PR.** ليش هاي بالذات؟ لأنها كبسة **قرار**، مش كبسة **نقل معلومات**. كل الكبسات اللي شلناها كانت "انسخ هاد لهون، شغّل هداك" — شغل ساعي بريد. اللي ظل هو "أنا موافق يدخل هالكود مشروعي" — وهاد قرارك، ومحمي بكل بوابات موديول 03 (الحكم + القفل + المراجع).

## 🔧 بالتقني — القطعة الجديدة: Headless Mode

لحد اليوم فتحت `claude` وحكيت معه **تفاعلياً**. الوضع الثاني هو `claude -p "..."` — **بدون واجهة**: بينفذ المهمة كاملة وبيطلع. هاد هو حجر أساس كل الأتمتة:

```
تفاعلي:  claude          ← جلسة حوار، انت بالطرف الثاني
Headless: claude -p "..."  ← مهمة تنطلق وتخلص لحالها — قابلة للاستدعاء من
                            سكربت، cron، webhook، CI... (موديول 09!)
```

ولاحظ `--allowedTools` بالأمر تحت — نفس الدرس اللي دفعنا ثمنه مع المراجع الصامت: بالوضع الـ headless **ما في حدا يكبس Allow**، فأي أداة مش بالقائمة = رفض صامت. منعطيه بالضبط اللي بيحتاجه: أدوات Sentry، قراءة وتعديل ملفات، وgit وdart.

## 🧪 التجربة

### 0. تأكد إنه Sentry MCP متاح من جذر الريبو

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab
claude mcp list
```

إذا `sentry` مش بالقائمة هون (لأنك ضفته من مجلد ثاني — الإضافة الافتراضية محلية للمشروع)، ضيفه على مستوى حسابك كله:

```bash
claude mcp add -s user --transport http sentry https://mcp.sentry.dev/mcp
```

(وممكن يطلب إعادة مصادقة عبر `/mcp` مرة وحدة)

### 1. فجّر الجريمة الجديدة 🔫

```bash
cd 04-sentry-autofix/lesson-1-sentry-eyes/playground
export SENTRY_DSN="نفس-الـDSN"
dart run bin/import_dealer_contacts.dart
cd ../../..
```

(استيراد الوكلاء بينهار على `branches: "N/A"` — issue جديدة بـ Sentry)

### 2. الأمر الواحد — أطلق الأنبوب

من **جذر الريبو** (خلي SENTRY_DSN مصدّر):

```bash
claude -p "You are the sentry-autofix pipeline. Fetch the most recent unresolved issue from my Sentry lab org (sentrytest). Find its root cause in this repository (the playground code is under 04-sentry-autofix/lesson-1-sentry-eyes/playground). Create a git branch named fix/sentry-dealer-import, implement a minimal fix in the same spirit as the existing parsePrice fix (skip-and-report, never crash the whole import), prove the fix by running the affected script, commit ONLY the files you changed with a clear message, push the branch to origin, and print the GitHub compare URL for opening a pull request. Do NOT merge anything, and do NOT touch the arabgt org." --allowedTools "mcp__sentry__*,Read,Glob,Grep,Edit,Write,Bash(git *),Bash(dart *)"
```

واتفرج على المخرجات وهو يمشي المراحل. بالآخر بيطبعلك رابط `compare/fix/sentry-dealer-import`.

### 3. الكبسة الوحيدة 👑

افتح الرابط → **Create pull request** → شوف بواباتك الثلاثة يشتغلوا عليه (CI Referee + مراجعة Claude) → اقرأ الـ diff بعينك → **Merge**.

هاي هي الدورة اللي انحكت بالميتنغ حرفياً: **bug من Sentry → agent يحلل ويصلّح ويجهز PR** — وانت عند القرار بس.

### سؤال التثبيت

بموديول 09 رح نشيل حتى كتابتك للأمر (webhook من Sentry بيطلق الأنبوب لحاله). شو اللي بيخلي هيك أتمتة **آمنة** رغم إنه ولا إنسان بالخط قبل الـ PR؟ *(الجواب: البوابات — كل شي الأنبوب بينتجه لازم يمرق على الحكم والقفل والمراجع قبل ما يلمس main. الأتمتة بدون بوابات تهور؛ بوابات بدون أتمتة بطء)*

## 🏢 كيف تنقلها لمشاريع الشركة

*(للمستقبل — بجلسة النقل المخصصة)*

نفس الأمر بالضبط، بس المصدر أخطاء Flutter الحقيقية والريبو ريبو الشركة — مع فرقين: صلاحيات Sentry مقروءة بس بالبداية، والأنبوب بيشتغل بجدولة (كل صباح: خد أعلى crash وجهّز PR) قبل ما ننتقل للـ webhook الفوري. النتيجة: الفريق بيصحى كل يوم على PRs جاهزة للمراجعة بدل قائمة crashes.
