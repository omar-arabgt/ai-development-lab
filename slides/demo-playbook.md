# دليل الديمو — وين كل إشي وكيف بتجربه قدام أمجد

*(محدث 2026-08-17 مساءً — بعد تركيب v2 عالريبوهين الحقيقيين)*

---

## 1. الوضع الحالي — شو وين

| الريبو | البرانش | الحالة |
|---|---|---|
| **ArabGT-Mobile** | `feature/ai-foundations-v2` | ✅ كل شي مـ committed **محلياً** (مش مدفوع — قرارك) — الأساس المجرب + الإضافات الأدفانس، 24 ملف |
| **arabgt-backend** | `ai-foundations` (مدفوع) + `feature/ai-advanced` (محلي) | ✅ الأساس مدفوع على origin؛ الإضافات الأدفانس محلية فوقه |

⚠️ **تنبيهين قبل الميتنغ:**
1. برانش `fix/AGT-511-image-network-noise` (موبايل) فيه commit باسم "--" لجّن نسخ حراس **أضعف** بالغلط — لازم ينشال قبل دمج الـ PR تبعه (بشيله بأمر واحد لما تعطيني إشارة)
2. برانش `ai-foundations` القديم (موبايل، مدفوع) صار **متجاوز** — v2 هو المعتمد؛ بعد العرض منسكر القديم

---

## 2. خريطة الطبقات — الملف ووين بتشوفه

| الطبقة | المسار بالريبو | وين بتشوفها بالواجهة |
|---|---|---|
| **Rules** (الذاكرة) | `CLAUDE.md` + `.cursor/rules/project.mdc` | بتشتغل خفي بكل محادثة — بتثبتها بسؤال (ديمو 1) |
| **Permissions** | `.claude/settings.json` (allow/ask/deny) | لما يطلب push بتشوف طلب الموافقة |
| **Hooks** (الحراس) | `.cursor/hooks.json` + `.cursor/hooks/*.sh` و`.claude/settings.json` | رسالة BLOCKED حمرا بالمحادثة (ديمو 2) |
| **Skills/Commands** | `.claude/skills/*/SKILL.md` + `.cursor/commands/*.md` | قائمة الـ `/` باللوحة والـ IDE (ديمو 4) |
| **Subagents** | `.claude/agents/*.md` | بتناديهم بالاسم: "Use the pr-reviewer agent..." |
| **MCP** (Sentry/Linear) | `.mcp.json` + `.cursor/mcp.json` | تبويب MCPs بالإعدادات + النتائج بالمحادثة |
| **قانون التوازي** | قسم "Parallel work" بالذاكرة + `/parallel-tasks` | أي multi-agent بيلتزم فيه تلقائياً |

**الـ skills الموجودة (بالأداتين):** `linear-ticket` • `sentry-sweep` • `daily-report` 🆕 • `release-check` 🆕 • `parallel-tasks` 🆕 (+`parallel-tasks` skill عند Claude من قبل)

**الـ agents:** موبايل: flutter-reviewer، qa-engineer، pr-reviewer — باكند: django-reviewer، api-qa، web-reviewer، performance-reviewer، pr-reviewer

---

## 3. سيناريو الديمو — 15 دقيقة بالترتيب

> كله من لوحة Cursor، الـ workspace: **arabgt-mobile** على برانش **feature/ai-foundations-v2**

**① الذاكرة (دقيقتين)** — الصق:
`How do I add a new screen in this app?`
✔ المتوقع: checklist بأسماء ملفاتكم (arabgt_routes → arabgt_navigator → ArabgtGo) + تحذير مجلدات الاستثناء. الجملة لأمجد: *"ما حدا علّمه بالمحادثة — قرأ ذاكرة المشروع"*

**② الحارس لايف (دقيقة — الأقوى)** — الصق:
`Run this command: flutter run --target lib/main_prod.dart`
✔ المتوقع: 🛑 BLOCKED برسالة production red line. بعدها مباشرة:
`Run: git push --force origin dev`
✔ المتوقع: 🛑 BLOCKED (الحارس الجديد). الجملة: *"مش أدب — قوة. حتى لو الـ AI انخدع، الأمر ما بينفذ"*

**③ قائمة الأوامر (نص دقيقة)** — اكتب `/`
✔ المتوقع: daily-report, release-check, sentry-sweep, linear-ticket, parallel-tasks. الجملة: *"خبرة الفريق صارت ملفات — أي زميل بيعمل pull بيلاقيها"*

**④ التقرير اليومي الحي (3 دقايق)** — اكتب:
`/daily-report`
✔ المتوقع: تقرير markdown من Sentry الشركة الفعلي: جديد/راجع/غير متتبع + جدول + ربط مع Linear. الجملة: *"هاد بيقدر يوصلكم كل صبح أوتوماتيكياً"*

**⑤ القصة الكاملة — الباغات الثلاثة (4 دقايق)** — افتح جاهز مسبقاً:
- صفحة PRs: [#544](https://github.com/ArabGT-Platform/ArabGT-Mobile/pull/544) [#545](https://github.com/ArabGT-Platform/ArabGT-Mobile/pull/545) [#546](https://github.com/ArabGT-Platform/ArabGT-Mobile/pull/546)
- بورد Linear (بطاقات "In Review from AI" بليبل Sentry)
- ترمينال: `git worktree list`
الجملة: *"3 أخطاء production حقيقية، انحلوا بالتوازي بجلسة وحدة — تست بيفشل أول، حل، فحوصات، PR — والدمج بضل قرار بشري"*

**⑥ الختام (دقيقتين)** — `/release-check`
✔ المتوقع: بيركض analyze + tests + فحص المسارات الممنوعة وبيعطي GO/NO-GO. الجملة: *"وهاد نفسه بيصير شرط دمج إجباري على GitHub — أحمر = زر الدمج معطل"*

---

## 4. خطة الطوارئ (fallback)

**قبل الميتنغ بساعة، خذ سكرينشوتات لـ:**
1. جواب سؤال الذاكرة (①)
2. رسالتي BLOCKED (②)
3. قائمة الـ `/` (③)
4. تقرير `/daily-report` (④)
5. صفحة الـ 3 PRs + بورد Linear + `git worktree list` (⑤)
6. حكم pr-reviewer على الـ PRs (READY + ترتيب الدمج)

لو النت خذل أو الجلسة علقت: بتكمل العرض بالسكرينشوتات + الدفتر العربي (`cursor-explainer.md`) + وثيقة Word الإنجليزية (`ai-first-technical-brief.docx`).

---

## 5. شو بعده معلق (بعد موافقة أمجد)

| الخطوة | مين |
|---|---|
| push للبرانشين + فتح PRs للأساس | انت (الأوامر جاهزة عندي) |
| تنظيف commit "--" من fix/AGT-511 | أنا، بإشارتك |
| Branch protection + required checks على GitHub الشركة | أدمن الـ org |
| مفتاح Cursor API كـ secret + workflow المراجع على كل PR | انت + أدمن |
| نقل nightly/weekly QA workflows + secret الـ Test Lab | أنا معك |
| PostHog للشركة (لو منقرر) + التقرير الصباحي الموحد | مرحلة ثانية |
