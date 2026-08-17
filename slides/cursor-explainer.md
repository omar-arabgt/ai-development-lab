# AI-First Development على Cursor — الشرح التقني

*(دفتر عمر للعرض — شرح تقني بالتفصيل: الآلية، صيَغ الملفات، والسلوك الفعلي. كل فصل بيبدأ بخلاصة سطر واحد ثم المواصفات)*

---

## فصل 1 — البنية الكاملة (Architecture)

> **الخلاصة:** كل إعدادات الـ AI عايشة كملفات نصية جوّا الريبو تحت `.cursor/` — بتتلجن بـ git، بتمرق بالـ PR review، وبتوصل لكل الفريق تلقائياً مع الـ clone. ما في إعدادات مخفية بسيرفر حدا.

**الطبقات الأربعة وأدوارها:**

| الملف | الدور | إمتى بيشتغل |
|---|---|---|
| `.cursor/rules/project.mdc` | ذاكرة المشروع وقوانينه (سياق) | بينحقن بكل محادثة تلقائياً |
| `.cursor/hooks.json` + سكربتات | حراسة تنفيذية (enforcement) | قبل تنفيذ كل أمر terminal أو أداة MCP |
| `.cursor/commands/*.md` | أوامر جاهزة معيارية (`/sentry-sweep`...) | عند استدعائها بـ `/` |
| `.cursor/mcp.json` | تعريف وصلات خارجية (Sentry، Linear) | عند تفعيلها + مصادقة OAuth لكل مستخدم |

**مبدأ التصميم — فصل السياق عن القوة:**
- الـ rules بتوجّه **قرارات** الـ AI (بيقدر نظرياً يخالفها لو انخدع)
- الـ hooks بتمنع **التنفيذ** نفسه (ما بتعتمد على "اقتناع" الـ AI إطلاقاً)
- الاثنين مع بعض = defense in depth: طبقة توجيه + طبقة منع

**التوازي مع Claude Code:** نفس البنية مكررة بأسماء ثانية — `CLAUDE.md` (بدل rules)، `.claude/settings.json` permissions+hooks، `.claude/skills/`، `.mcp.json`. مصدر الحقيقة واحد والملفات مرايا، فالفريق حر بالأداة والقوانين نفسها.

**الحالة الفعلية:** مركّب كامل على الريبوهين (ArabGT-Mobile + arabgt-backend)، برانش `feature/ai-foundations`، مجرّب end-to-end بتاريخ 2026-08-16.

---

## فصل 2 — Rules: ذاكرة المشروع

> **الخلاصة:** ملف MDC بـ frontmatter فيه `alwaysApply: true` — Cursor بيحقن محتواه بسياق كل محادثة بهالريبو، فالـ AI بيبدأ وهو عارف الـ stack والقوانين والخطوط الحمر بدون أي شرح يدوي.

**الصيغة (MDC = Markdown + frontmatter):**

```
---
description: Project memory — mirrored from CLAUDE.md
alwaysApply: true
---
# ArabGT Mobile — Project Memory
...
```

**آلية التحميل:** `alwaysApply: true` = بينحقن بكل محادثة/agent بهالـ workspace بلا شرط. (البدائل بعالم Cursor: `globs` لتفعيل القاعدة بس لما ملفات معينة تكون بالسياق، أو agent-requested حسب الـ description — احنا اخترنا alwaysApply لأنها قوانين عامة للمشروع كله.)

**شو بينكتب فيه — بس اللي مش قابل للاستنتاج من الكود:**
- **معمارية إلزامية:** التنقل حصراً `ArabgtGo.toNamed` عبر `arabgt_routes.dart` → `arabgt_navigator.dart` (مش `Get.toNamed` — بيكسر التتبع المركزي)
- **بنية الـ features:** التشريح القياسي (bindings/controllers/data source→repository) + **7 مجلدات استثناء** موسومة "do not fix, do not imitate" — كود قديم بينمط مختلف، تقليده بينشر العدوى
- **خطوط حمر:** `lib/environments/prod/` ممنوع اللمس؛ الأسرار (`key.properties`، `.keystore`، GoogleService-Info) ممنوعة القراءة
- **قرارات عمليات:** سير البرانشات (يومي على dev → qa → staging → production)؛ خريطة Sentry (المشاريع mobile-{dev,qa,staging,prod} منفصلة عن backend-*)؛ وجهة Linear الوحيدة (team ArabGT / project "ArabGT Mobile App") وحالة "In Review from AI"
- **بالباكند إضافةً:** حدود الـ endpoints (موبايل→api/، ويب→web/، غير واضح→اسأل)؛ جداول الأخبار mirrors للقراءة فقط عبر ReadOnlyRouter

**الصيانة:** الملف مرآة لـ `CLAUDE.md` (مصدر الحقيقة الواحد) — أي تعديل قانون بيصير بالمصدر وبينعكس، والتعديل بيمرق بالـ PR زي أي كود.

**مجرّب:** سؤال "How do I add a new screen?" بلوحة Cursor رجّع checklist بأسماء ملفاتنا الفعلية + تحذير مجلدات الاستثناء — بدون أي context يدوي.

---

## فصل 3 — Hooks: الحراسة التنفيذية

> **الخلاصة:** سكربتات بتركض **قبل** تنفيذ أي أمر — بتستلم تفاصيل العملية كـ JSON، وبترجّع قرار allow/deny. الرفض بيمنع التنفيذ فعلياً مهما كان الـ AI "مقتنع" — حماية deterministic مش سلوكية.

**الصيغة (`.cursor/hooks.json`):**

```json
{
  "version": 1,
  "hooks": {
    "beforeShellExecution": [{ "command": ".cursor/hooks/production-guard.sh" }],
    "beforeMCPExecution":   [{ "command": ".cursor/hooks/mcp-guard.sh" }]
  },
  "failClosed": true
}
```

**البروتوكول (دورة حياة الطلب):**
1. الـ agent بيقرر ينفذ أمر terminal أو أداة MCP
2. Cursor بيوقف التنفيذ وبيشغل السكربت، وبيبعتله على stdin كائن JSON فيه تفاصيل العملية (الأمر النصي / اسم أداة الـ MCP ومدخلاتها)
3. السكربت بيفحص وبيرجّع JSON: `{"permission": "deny", "user_message": "...", "agent_message": "..."}` للرفض (أو allow للتمرير)
4. عند الرفض: العملية ما بتنفذ، المستخدم بيشوف `user_message`، والـ agent بيستلم `agent_message` فبيفهم السبب وبيعدل مساره
5. `failClosed: true` — لو السكربت نفسه crash أو ما رجّع صيغة سليمة: **رفض تلقائي** (البوابة بتسكّر عند الشك، ما بتفتح)

**قواعد الفحص المركّبة فعلياً (regex على محتوى العملية):**

| الحارس | بيصد |
|---|---|
| `production-guard.sh` (موبايل) | `main_prod`، `environments/prod`، `fastlane release/deploy/beta`، `xcrun altool`، أي upload للستورات |
| `production-guard.sh` (باكند) | `DATABASE_URL=`، `--settings=*prod/staging`، أوامر psql/mysql على prod/staging/arabgt.com، `manage.py shell/dbshell/flush` |
| `mcp-guard.sh` (الاثنين) | Sentry: resolve/assign/update/delete — Linear: delete_*، merge، تعديل projects/releases/milestones |

**ليش طبقة ثانية فوق الـ rules؟** الـ rules ممكن نظرياً تنخدع (prompt injection، سياق طويل، سوء فهم). الـ hook ما عنده "فهم" ينخدع — regex على نص الأمر، نتيجة ثابتة لنفس المدخل، وبيفحص **الأمر مش نية صاحبه**.

**مجرّب مرتين:**
- بالمختبر: حارس الـ DB صدّ أمر فحص كتبه الـ AI اللي ألّف الحارس نفسه — إثبات إنه الفحص محايد
- على ريبو الشركة (2026-08-16): طلب `flutter run --target lib/main_prod.dart` انصد فوراً برسالة production red line

**سؤال متوقع — "شو بيمنع الـ AI يعدل الحارس؟":** ملفات الحراسة كود بالريبو: تعديلها بيبين بالـ diff وبيمرق بالـ PR review، والعمليات الحساسة (push، PR) موقوفة على موافقة بشرية بالإعدادات أصلاً.

---

*(الفصول الجاية: 4 Commands — 5 Multi-Agent وworktrees — 6 MCP — 7 QA والتكلفة)*
