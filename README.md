# 🧪 AI Development Lab

مختبر تجارب للتحوّل لنموذج **AI-First Development** — كل موديول فيه: شرح مفصّل، ديمو مطبّق وشغال، توثيق كامل، وطريقة التشغيل الأوتوماتيك.

> القاعدة الذهبية: **ما منحكي "خلص" إلا لما الديمو يشتغل قدامنا.**

## قواعد المختبر

1. **الكود كله بالإنجليزي** — تعليقات، مسجات، أسماء متغيرات — عشان ينتقل لمشاريع الشركة مباشرة
2. **الشرح والتوثيق بالعربي** — READMEs والدروس
3. استثناء وحيد: playground الدرس 1 — قوانينه العربية جزء من التجربة الموثقة نفسها

## الموديولات

| # | الموديول | الوصف | الحالة |
|---|----------|-------|--------|
| 00 | [أساسيات Claude Code](00-claude-code-fundamentals/) | Hooks, Subagents, Skills, CLAUDE.md, Permissions — الأساس لكل شي بعده | ✅ |
| 01 | [Parallel Agents + Worktrees](01-parallel-agents-worktrees/) | عدة agents يشتغلوا بالتوازي على نفس الريبو بدون تعارض | ✅ |
| 02 | [Spec-Driven Development](02-spec-driven-development/) | من spec مكتوب → كود كامل مع tests | ✅ |
| 03 | [PR Review أوتوماتيك](03-pr-review-automation/) | كل PR بينفتح → review تلقائي (GitHub Actions) | ✅ |
| 04 | [Sentry Auto-Fix](04-sentry-autofix/) | Bug يوصل من Sentry → agent يحلل ويصلّح ويفتح PR | 🔨 |
| 05 | [Linear Triage](05-linear-triage/) | تصنيف وترتيب التذاكر الجديدة تلقائياً | ⏳ |
| 06 | [QA Testing للتطبيق](06-qa-mobile-testing/) | اختبار الـ user journeys على التطبيق (موبايل) أوتوماتيك | ⏳ |
| 07 | [Analytics (PostHog)](07-analytics-posthog/) | شو هو PostHog وليش انذكر بالميتنغ + ديمو insights | ⏳ |
| 08 | [حماية الـ DB والبيئات](08-safety-db-guardrails/) | الـ AI ما بيلمس production أبداً — عزل، باك أب، صلاحيات | ⏳ |
| 09 | [بنية الأتمتة](09-automation-infra/) | الطبقة اللي بتخلي كل شي فوق يشتغل لحاله: webhooks, cron, CI | ⏳ |

📖 [قاموس المصطلحات](GLOSSARY.md) — كل مصطلح هندسي منمر عليه، عربي وإنجليزي

## بيئة الشركة (Context)

- المنتج الأساسي: **تطبيق موبايل** (مش ويب)
- البيئات: `dev` / `qa` / `staging` / `production`
- الأدوات الحالية: Sentry, Linear, GitHub
- **خط أحمر:** الـ AI ما بيوصل لأي DB أو بيئة production — التفاصيل بموديول 08

## الحالة

- ⏳ لسا ما بلش
- 🔨 شغالين عليه
- ✅ خلص + الديمو مجرّب + موثّق
