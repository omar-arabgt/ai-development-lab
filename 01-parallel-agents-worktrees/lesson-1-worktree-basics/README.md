# الدرس 1: Git Worktrees — مكاتب منفصلة لنفس المشروع

## 🗣️ بالعامية

لحد هلق كل شغلك كان بمكتب واحد (مجلد واحد) — لو بديت جلستين Claude Code فيه بنفس الوقت، الاثنين رح يدوسوا على بعض: نفس الملفات، نفس التعديلات، تعارض مضمون.

الـ **git worktree** بيحل هاي بطريقة بسيطة: بيعطيك **نسخة تانية من نفس المشروع، بمجلد منفصل، على branch منفصل** — بدون ما تعمل `clone` جديد (يعني بدون ما تنزّل الريبو مرتين). كل نسخة (worktree) هي باب مختلف لنفس البيت: نفس الأساسات (تاريخ الـ git، الـ commits)، بس غرفة شغل خاصة فيها.

هيك بيصير عندك مكتبين: بمكتب أ بتحط agent يشتغل على تاسك أ، وبمكتب ب agent تاني يشتغل على تاسك ب — **بنفس اللحظة، بدون ما يوصل أحدهم لشغل التاني**.

## 🔧 بالتقني

```
playground/                    ← الريبو الأساسي (branch: main)
├── .git/                      ← تاريخ الـ git الحقيقي (واحد بس)
└── lib/...

playground-worktrees/task-a/   ← worktree تاني (branch: task/currency-formatter)
├── .git                       ← مش مجلد! ملف بيأشر عالـ .git الأصلي
└── lib/...                    ← نسخة كاملة من الملفات، بس معزولة

playground-worktrees/task-b/   ← worktree تالت (branch: task/favorites-toggle)
├── .git
└── lib/...
```

نقاط مهمة:
- كل worktree لازم يكون على **branch مختلف** — git ما بيسمحلك تفتح نفس الـ branch بمكانين
- التعديلات بكل worktree **معزولة تماماً عن التانية** لحد ما تعمل merge
- لما تخلص، بتعمل `git worktree remove` وبترجع تدمج (`merge`) الشغل عالـ branch الرئيسي

### الأوامر الأساسية

| الأمر | شو بيعمل |
|---|---|
| `git worktree add <path> -b <branch>` | يفتح worktree جديد بمسار معين، على branch جديد |
| `git worktree list` | يعرضلك كل الـ worktrees المفتوحة حالياً |
| `git worktree remove <path>` | يقفل worktree (لازم ما يكون فيه تعديلات غير محفوظة) |
| `git merge <branch>` | يدمج شغل branch معين بالـ branch الحالي |

## 🎯 الـ playground

بمجلد `playground/` ريبو Git بسيط ومستقل (مش جزء من ريبو الـ lab — قصداً، عشان تقدر تعمل فيه worktrees بحرية بدون ما تلخبط الريبو الرئيسي). فيه ملفين **مستقلين تماماً عن بعض** (ولا سطر مشترك بينهم) — قصداً، عشان لما ندمجهم، صفر تعارض:

- `lib/currency_formatter.dart` — تاسك أ: فورمات السعر بالدينار
- `lib/favorites_service.dart` — تاسك ب: toggle للمفضلة

## 🧪 التجربة

### 0. جهّز الـ playground كريبو مستقل

`git worktree` بيحتاج ريبو Git حقيقي. الـ playground هون ملفات عادية بس (مش ريبو لسا) — قصداً، عشان يظل جزء عادي من ريبو الـ lab على GitHub. أول خطوة: حوّله لريبو مستقل بجلسة تيرمينال وحدة:

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/01-parallel-agents-worktrees/lesson-1-worktree-basics/playground
git init
git branch -m main
git add lib/
git commit -m "Initial state: two independent TODOs for the worktree exercise"
```

> ⚠️ **تحقق قبل ما تكمل** — نفّذ:
> ```bash
> git rev-parse --show-toplevel
> ```
> لازم يطبعلك مسار بينتهي بـ `.../lesson-1-worktree-basics/playground`. لو طلعلك مسار ريبو الـ lab الكبير (`.../ai-development-lab`) — يعني خطوة الـ `git init` ما زبطت، **لا تكمل**؛ أي `worktree add` هون رح يفتح worktrees على ريبو الـ lab الحقيقي كله بدل الـ playground (صارت معنا 😅).

### 1. افتح worktree لكل تاسك

```bash
git worktree add ../playground-worktrees/task-a -b task/currency-formatter
git worktree add ../playground-worktrees/task-b -b task/favorites-toggle
git worktree list
```

بعد `git worktree list` لازم تشوف 3 سطور **وكلها مساراتها جوا `lesson-1-worktree-basics/`** — لو شفت سطر مساره جذر `ai-development-lab`، وقّف وارجع لخطوة التحقق.

لازم تشوف 3 سطور: الريبو الأساسي + الـ worktree-ين الجداد.

### 2. افتح تبويبين تيرمينال منفصلين (بالتوازي)

**تبويب 1:**
```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/01-parallel-agents-worktrees/lesson-1-worktree-basics/playground-worktrees/task-a && claude
```
اطلب: *"implement the TODO in lib/currency_formatter.dart"*

**تبويب 2 (بنفس الوقت):**
```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/01-parallel-agents-worktrees/lesson-1-worktree-basics/playground-worktrees/task-b && claude
```
اطلب: *"implement the TODO in lib/favorites_service.dart"*

شغّل الاثنين **بنفس الوقت** — هاد بالضبط الفرق عن كل الدروس السابقة. اثنين agents، اثنين مكاتب، شغل حقيقي متوازي.

### 3. ارجع للريبو الأساسي وادمج

بعد ما الاثنين يخلصوا ويعملوا commit لشغلهم (اطلب من كل واحد `git commit -am "..."` بنهاية شغله):

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/01-parallel-agents-worktrees/lesson-1-worktree-basics/playground
git merge task/currency-formatter
git merge task/favorites-toggle
```

لازم الاثنين يندمجوا **بدون ولا تعارض واحد** (`Fast-forward` أو `Merge made by...`) — لأنهم عدّلوا ملفات مختلفة تماماً.

### 4. نظّف

```bash
git worktree remove ../playground-worktrees/task-a
git worktree remove ../playground-worktrees/task-b
```

## 🏢 كيف تنقلها لمشاريع الشركة

بريبو الـ Flutter الحقيقي: بدل ما تستنى agent يخلّص تاسك (مثلاً "أصلح باغ الترجمة") قبل ما تبلش تاسك تاني ("أضف شاشة جديدة") — بتفتح worktree لكل واحد، وبتشغّل agent بكل واحد بنفس الوقت. أهم شرط: **التاسكات لازم تلمس ملفات مختلفة** (متل المثال هون) وإلا رح تواجه conflicts عند الدمج — وهاد بالضبط اللي بيحدد كيف تقسّم الشغل بين agents بالموديولات الجاية.
