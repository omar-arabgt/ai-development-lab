# خريطة الترجمة: Cursor ↔ Claude Code

> تحضير لجلسة العصف الذهني (الثلاثاء) — ورشات التيم ليدر: [Cursor 101](https://www.youtube.com/watch?v=pQglAvQXYp0) و[Cursor 201](https://www.youtube.com/watch?v=hT00PYA298w)

الفكرة: المفاهيم وحدة، الأسماء بتختلف. هاد الجدول بيترجم بين الأداتين — والأعمدة الفاضية عند Cursor هي نقاط قوة نعرضها بالجلسة.

## الترجمة مفهوم بمفهوم

| المفهوم | Claude Code | Cursor | جربناه بالمختبر؟ |
|---|---|---|---|
| ذاكرة المشروع / القوانين | `CLAUDE.md` | Rules (`.cursor/rules`) | ✅ درس 1 + ablation test |
| صلاحيات وحدود | Permissions (allow/ask/deny) | Agent auto-run settings | ✅ درس 2 |
| حراس بكود (منع/فحص أوتوماتيك) | Hooks (PreToolUse, PostToolUse...) | — لا يوجد مقابل كامل | ✅ درس 3 (production guard + quality gate) |
| موظفين متخصصين بصلاحيات معزولة | Subagents (`.claude/agents/`) | — لا يوجد مقابل مباشر | ✅ درس 4 |
| شغل متوازي | Parallel agents + git worktrees | Background Agents | 🔜 موديول 01 |
| ربط أدوات خارجية (Linear, Sentry...) | MCP | MCP (نفس البروتوكول!) | 🔜 |
| تشغيل بدون واجهة (للأتمتة/CI) | Headless: `claude -p` + GitHub Action رسمية | — محدود | 🔜 موديولات 03/04/09 |
| الإكمال الذكي أثناء الكتابة | — (مش تخصصه) | Tab completion (نقطة قوة Cursor) | — |

## الخلاصة الاستراتيجية للجلسة

- **مش منافسة — تكامل:** Cursor ممتاز للشغل اليومي جوا المحرر (Tab, inline edits). Claude Code أقوى بالأتمتة (hooks, subagents, headless, CI).
- **MCP مشترك** — أي ربط منبنيه (Linear, Sentry) بيخدم الأداتين.
- **الأتمتة الكاملة اللي طلبها التيم ليدر** (Sentry auto-fix، QA أوتوماتيك، PR reviews بدون تدخل) بتحتاج headless mode و hooks — وهاي حالياً أرض Claude Code.

## ملاحظاتي من الورشات

_(تنعبى بعد المشاهدة)_

### Cursor 101
- 

### Cursor 201
- 
