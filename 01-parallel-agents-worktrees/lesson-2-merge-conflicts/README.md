# الدرس 2: Merge Conflicts — لما موظفين يكتبوا على نفس السطر

## 🗣️ بالعامية

بالدرس الأول كل شي مشي حرير — لأنه **أنا قسمتلك الشغل صح**: كل agent بملف مختلف. بس بالواقع مش دايماً الدنيا هيك، وأول ما تاسكين يلمسوا **نفس الأسطر بنفس الملف**، الـ git وقت الدمج بيوقف ويقلك: *"هدول الاثنين غيّروا نفس المكان بطريقتين مختلفتين — أنا ما بقرر مين الصح، انت قرر."*

هاد اسمه **Merge Conflict (تعارض دمج)** — ومش خطأ ولا كارثة، هو git عم يحميك من إنه يخمّن بدالك ويمسح شغل حدا. الدرس هاد رح تفتعل التعارض **عمداً** عشان تشوفه وتحله بإيدك مرة، وبعدها ما بتخاف منه أبداً.

والقاعدة الذهبية اللي رح تطلع فيها من الدرس: **التعارض بينحل، بس الأحسن ما يصير أصلاً — قسّم التاسكات على ملفات مختلفة**. هاي القاعدة هي اللي بتحدد كيف بتوزع الشغل على agents بالـ AI Factory.

## 🔧 بالتقني

لما git يلاقي تعارض، بيحط بالملف **علامات التعارض (conflict markers)**:

```
<<<<<<< HEAD
    'brand',
    'price',
=======
    'brand',
    'year',
>>>>>>> task/year-filter
```

| العلامة | معناها |
|---|---|
| `<<<<<<< HEAD` → `=======` | النسخة اللي **عندك** (الـ branch الحالي) |
| `=======` → `>>>>>>> branch` | النسخة الجاية من الـ **branch اللي عم تدمجه** |

وحل التعارض = 3 خطوات دايماً:
1. **افتح الملف وعدّله بإيدك** — احذف العلامات واكتب النسخة النهائية الصح (غالباً دمج الاثنين: `'brand', 'price', 'year'`)
2. `git add <الملف>` — بتعلم لـ git إنك حليته
3. `git commit --no-edit` — بتختم الدمجة

## 🎯 الـ playground

ملف واحد بس: `lib/search_filters.dart` — فيه قائمة فلاتر، وتاسكين **الاثنين بيعدلوا نفس الأسطر** (قصداً): تاسك أ بيضيف فلتر `price`، تاسك ب بيضيف فلتر `year`.

## 🧪 التجربة

### 0. جهّز الـ playground كريبو مستقل

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/01-parallel-agents-worktrees/lesson-2-merge-conflicts/playground
git init
git branch -m main
git add lib/
git commit -m "Initial state: one shared file both tasks will touch"
```

> ⚠️ **تحقق قبل ما تكمل** — نفّذ:
> ```bash
> git rev-parse --show-toplevel
> ```
> لازم يطبعلك مسار بينتهي بـ `.../lesson-2-merge-conflicts/playground`. لو طلعلك مسار ريبو الـ lab الكبير (`.../ai-development-lab`) — يعني خطوة الـ `git init` ما زبطت، **لا تكمل**.

### 1. افتح worktree لكل تاسك

```bash
git worktree add ../playground-worktrees/task-a -b task/price-filter
git worktree add ../playground-worktrees/task-b -b task/year-filter
git worktree list
```

(3 سطور، وكلها مساراتها جوا `lesson-2-merge-conflicts/`)

### 2. شغّل الـ agents بالتوازي (زي الدرس 1)

**تبويب 1:**
```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/01-parallel-agents-worktrees/lesson-2-merge-conflicts/playground-worktrees/task-a && claude
```
اطلب: *"do TASK A in lib/search_filters.dart, then commit your work"*

**تبويب 2:**
```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/01-parallel-agents-worktrees/lesson-2-merge-conflicts/playground-worktrees/task-b && claude
```
اطلب: *"do TASK B in lib/search_filters.dart, then commit your work"*

(لاحظ هالمرة الطلب نفسه فيه "then commit your work" — درس التعلم من المرة الماضية 😄)

### 3. ادمج — وشوف الصدمة

```bash
cd /Users/omarabed/Documents/work/sandbox/ai-development-lab/01-parallel-agents-worktrees/lesson-2-merge-conflicts/playground
git merge task/price-filter --no-edit
git merge task/year-filter --no-edit
```

الدمجة الأولى بتمشي عادي. الثانية — **CONFLICT**! شي زي:

```
Auto-merging lib/search_filters.dart
CONFLICT (content): Merge conflict in lib/search_filters.dart
Automatic merge failed; fix conflicts and then commit the result.
```

### 4. حل التعارض بإيدك

افتح `lib/search_filters.dart` بأي محرر (VS Code مثلاً) — رح تشوف علامات `<<<<<<<`. عدّل القائمة لتصير النسخة الصح النهائية:

```dart
  static const List<String> defaultFilters = [
    'brand',
    'price',
    'year',
  ];
```

(احذف كل العلامات — الملف لازم يرجع Dart سليم)

بعدين:

```bash
git add lib/search_filters.dart
git commit --no-edit
git log --oneline --graph
```

### 5. البونص: خلي Claude يحلها بدالك

اعمل `git reset --hard` وأعد الدمجتين ليصير التعارض من جديد، وهالمرة افتح `claude` بالـ playground واطلب: *"resolve the merge conflict, keep both filters"* — رح تشوفه يقرأ العلامات ويحلها ويختم الدمجة لحاله. هاي مهارة رح نعتمد عليها كثير بالموديولات الجاية.

## 🏢 كيف تنقلها لمشاريع الشركة

هاد الدرس هو **قانون توزيع الشغل** بالـ AI Factory:

- قبل ما تطلق agents بالتوازي، اسأل: **هل التاسكات بتلمس نفس الملفات؟**
  - لأ → أطلقهم بالتوازي براحتك (درس 1)
  - آه → يا بتقسمهم غير شكل، يا بتشغلهم بالتسلسل، يا بتتقبل إنك رح تحل تعارض بالآخر (هالدرس)
- بريبو Flutter حقيقي، الملفات "الساخنة" اللي دايماً بتعمل تعارض: `pubspec.yaml`، ملفات الترجمة `l10n`، الـ routing — انتبه لما توزع تاسكات بتلمسهم
