# عدة النقل — Transfer Kit

ملفات جاهزة للزرع بريبوهات ArabGT الفعلية. **الهيكل مطابق لجذر الريبو** — يعني التركيب نسخ مباشر.

## شو جوا العدة

| المجلد | للريبو | المحتوى |
|---|---|---|
| `mobile/` | تطبيق Flutter | `.claude/settings.json` (permissions للموبايل) + 3 skills + `.mcp.json` |
| `backend/` | Django | `.claude/settings.json` (permissions للباك إند — manage.py مضبوطة بعناية) + نفس الـ skills + `.mcp.json` |
| `docs/parallel-workflow.md` | الاثنين | دليل الشغل المتوازي على Cursor وClaude |

## الـ Skills الثلاثة

1. **linear-ticket** — تذكرة من وصف بالعامية، سياسة problem-only
2. **parallel-tasks** — التوزيع المتوازي بسياسة "ولا agent-ين على ملف"
3. **sentry-sweep** — نجم الديمو: top N من Sentry (قراءة فقط) → بطاقات بمشروع "Sentry Bugs" بـ Linear (وبس هناك)، بتوزيع متوازي وفحص تكرار

## التركيب (لكل ريبو — 3 دقايق)

```bash
cd <repo-root>
git checkout -b ai-foundations
cp -r <lab>/transfer-kit/<mobile|backend>/.claude .
cp <lab>/transfer-kit/<mobile|backend>/.mcp.json .
mkdir -p docs && cp <lab>/transfer-kit/docs/parallel-workflow.md docs/
```

## بعد التركيب — بالترتيب

1. **توليد الذاكرة**: جلسة Claude بجذر الريبو: *"Study this codebase thoroughly and draft a CLAUDE.md: structure, architecture, conventions, and red lines. Ask me about anything ambiguous before finalizing."* — عمر يراجع ويعدل
2. **مرآة Cursor**: *"Mirror the reviewed CLAUDE.md into .cursor/rules/ as .mdc files"*
3. **فحص الذاكرة**: جلسة جديدة + "اشرحلي المشروع وكيف أضيف feature" — الجواب لازم يكون دقيق
4. **PR**: رفع branch الـ ai-foundations للمراجعة — أول PR بالمنهجية الجديدة 🎉

## مؤجل عمداً (بقرار عمر)

- **Hooks & production guards** — بتنضاف بعد ما عمر يجيب أسماء بيئات/قواعد الإنتاج الفعلية
- ربط CI (بوابات الـ PR والمراجع) — مرحلة ب بخطة النقل
