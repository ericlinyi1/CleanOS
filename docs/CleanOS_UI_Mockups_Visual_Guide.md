# 🎨 CleanOS UI Mockups — Visual Design Guide

**Designer:** Helen  
**Date:** April 18, 2026  
**Style:** iOS Dark Mode, Modern Minimalist, Gradient Accents

---

## 🎨 Design System

### **Color Palette**
```
Primary Background:  #000000 (Pure Black)
Secondary BG:        rgba(255,255,255,0.05) (Subtle white overlay)
Card Background:     rgba(255,255,255,0.08)

Accent Colors:
├─ Blue:     #007AFF (System Blue)
├─ Purple:   #AF52DE (System Purple)  
├─ Green:    #34C759 (System Green)
├─ Orange:   #FF9500 (System Orange)
├─ Red:      #FF3B30 (System Red)
└─ Cyan:     #5AC8FA (System Cyan)

Gradients:
├─ Primary:  Blue → Cyan (TopLeading → BottomTrailing)
├─ Success:  Green → Teal
├─ Warning:  Orange → Red
└─ Premium:  Purple → Pink
```

### **Typography**
```
App Title:        SF Pro Display, Black, 42pt
Section Headers:  SF Pro Display, Bold, 28pt
Card Titles:      SF Pro Text, Bold, 16pt
Body Text:        SF Pro Text, Regular, 15pt
Captions:         SF Pro Text, Regular, 13pt, Gray
```

### **Spacing**
```
Screen Padding:   20pt horizontal
Card Padding:     16pt
Section Spacing:  30pt
Element Spacing:  12pt
Corner Radius:    16pt (cards), 12pt (buttons)
```

---

## 📱 MOCKUP 1: Enhanced Home Dashboard

### **Before (Current)**
- Static 72% circle
- Hardcoded category sizes
- No context or recommendations

### **After (Proposed)**

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  🌙 CleanOS                     ≡    ┃ ← NavigationBar
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                       ┃
┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   ┃
┃   ┃                             ┃   ┃
┃   ┃         ⭕ 72%             ┃   ┃ ← Animated
┃   ┃       28.5 GB / 40 GB      ┃   ┃    circular
┃   ┃                             ┃   ┃    progress
┃   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   ┃
┃   ┃ 📊 Storage Breakdown        ┃   ┃
┃   ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫   ┃
┃   ┃ 🔵 Photos    18.2 GB ████░  ┃   ┃ ← Progress
┃   ┃ 🟣 Videos     8.4 GB ███░░  ┃   ┃    bars with
┃   ┃ 🟢 Other      1.9 GB █░░░░  ┃   ┃    gradient
┃   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   ┃
┃   ┃ 💎 Potential Savings        ┃   ┃
┃   ┃ 12.5 GB Available           ┃   ┃
┃   ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫   ┃
┃   ┃ Duplicates     2.4 GB   →  ┃   ┃ ← Tappable
┃   ┃ Similar        4.1 GB   →  ┃   ┃    rows
┃   ┃ Screenshots    1.2 GB   →  ┃   ┃
┃   ┃ Large Videos   4.8 GB   →  ┃   ┃
┃   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃   ┏━━━━━━━━━━━━━┓ ┏━━━━━━━━━━━━━┓   ┃
┃   ┃ 🔍          ┃ ┃ 🗑️         ┃   ┃ ← Action
┃   ┃ Scan Now   ┃ ┃ Quick     ┃   ┃    buttons
┃   ┃            ┃ ┃ Clean     ┃   ┃
┃   ┗━━━━━━━━━━━━━┛ ┗━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

**Key Features:**
- ✨ Real-time storage calculation
- 📊 Animated circular progress (lottie-style)
- 🎨 Color-coded breakdown bars
- 💡 Actionable "Potential Savings" section
- 🔄 Pull-to-refresh gesture

**Interactions:**
- Tap any category → Navigate to detail view
- Pull down → Refresh stats
- Tap "Scan Now" → Start full library analysis
- Tap "Quick Clean" → Auto-delete obvious junk

---

## 📱 MOCKUP 2: Smart Suggestions Feed

**New Screen:** AI-powered recommendations

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  ← Suggestions              ✨ Auto   ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                       ┃
┃  🔥 HIGH IMPACT                       ┃
┃  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  ┃
┃  ┃ 📸 47 burst photos from trip  ┃  ┃
┃  ┃                                ┃  ┃
┃  ┃ [img][img][img][img][img]...  ┃  ┃ ← Thumbnail
┃  ┃                                ┃  ┃    carousel
┃  ┃ Dec 15-20, 2025 • Marina Bay  ┃  ┃
┃  ┃                                ┃  ┃
┃  ┃ 💡 Keep best 5 photos?        ┃  ┃
┃  ┃ Save 380 MB                   ┃  ┃
┃  ┃                                ┃  ┃
┃  ┃  [Review] [Auto-Select Best]  ┃  ┃
┃  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  ┃
┃                                       ┃
┃  ⚡ QUICK WIN                         ┃
┃  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  ┃
┃  ┃ 🎥 3 large videos (4.8 GB)    ┃  ┃
┃  ┃                                ┃  ┃
┃  ┃ video_001.mp4  1.8 GB  4K     ┃  ┃
┃  ┃ video_002.mp4  1.6 GB  4K     ┃  ┃
┃  ┃ video_003.mp4  1.4 GB  4K     ┃  ┃
┃  ┃                                ┃  ┃
┃  ┃ 💡 Compress to 1080p HEVC?    ┃  ┃
┃  ┃ Save 2.1 GB                   ┃  ┃
┃  ┃                                ┃  ┃
┃  ┃  [Compress All]  [Choose]     ┃  ┃
┃  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  ┃
┃                                       ┃
┃  📅 SCHEDULED                         ┃
┃  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓  ┃
┃  ┃ 🗑️ 89 screenshots (820 MB)    ┃  ┃
┃  ┃                                ┃  ┃
┃  ┃ Over 6 months old              ┃  ┃
┃  ┃ Likely no longer needed        ┃  ┃
┃  ┃                                ┃  ┃
┃  ┃  [Review] [Delete All]         ┃  ┃
┃  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛  ┃
┃                                       ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

**Card Types:**

1. **🔥 HIGH IMPACT** (Red gradient badge)
   - Burst photos from same event
   - Large file groups
   - Duplicate videos

2. **⚡ QUICK WIN** (Yellow gradient badge)
   - Single-action cleanups
   - Obvious deletions
   - Compression opportunities

3. **📅 SCHEDULED** (Blue gradient badge)
   - Old screenshots
   - Temporary downloads
   - Expired time-sensitive content

**Smart Logic:**
```swift
class SuggestionsEngine {
    func generateSuggestions() -> [Suggestion] {
        // 1. Detect photo bursts (timestamp clustering)
        // 2. Find large videos (>1GB, no edits)
        // 3. Identify old screenshots (>6 months)
        // 4. Flag duplicate videos (same duration+size)
        // 5. Prioritize by space savings
    }
}
```

---

## 📱 MOCKUP 3: Enhanced Swipe Review

**Tinder-style photo review with context**

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  ← Similar Photos       2 of 5        ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                       ┃
┃      ←  DELETE          KEEP  →      ┃ ← Swipe hints
┃                                       ┃    with color
┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   ┃
┃   ┃                             ┃   ┃
┃   ┃                             ┃   ┃
┃   ┃                             ┃   ┃
┃   ┃      [ACTUAL PHOTO]         ┃   ┃ ← Full-res
┃   ┃                             ┃   ┃    preview
┃   ┃                             ┃   ┃
┃   ┃                             ┃   ┃
┃   ┃                             ┃   ┃
┃   ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫   ┃
┃   ┃ 📅 Jan 15, 2026 3:42 PM    ┃   ┃ ← Metadata
┃   ┃ 📦 2.4 MB • 4032 x 3024    ┃   ┃    overlay
┃   ┃ 📍 Marina Bay, Singapore   ┃   ┃
┃   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   ┃
┃   ┃ ℹ️ Similar to 3 other photos ┃   ┃ ← Context
┃   ┃                             ┃   ┃    card
┃   ┃ [👁️ Show All]  [⏭️ Skip Group] ┃   ┃
┃   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃   ┏━━━━━━━┓ ┏━━━━━━━┓ ┏━━━━━━━┓   ┃
┃   ┃   ↶   ┃ ┃   X   ┃ ┃   ❤️   ┃   ┃ ← Action
┃   ┃ UNDO  ┃ ┃ DELETE┃ ┃  KEEP ┃   ┃    buttons
┃   ┗━━━━━━━┛ ┗━━━━━━━┛ ┗━━━━━━━┛   ┃
┃                                       ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

**Interactions:**
- **Swipe Left:** Delete with red highlight
- **Swipe Right:** Keep with green highlight
- **Tap Photo:** View full screen
- **Tap "Show All":** Grid view of similar photos
- **Tap "Skip Group":** Move to next category

**Animations:**
- Card rotation during swipe
- Spring animation on release
- Fade-in next card
- Haptic feedback on decision

---

## 📱 MOCKUP 4: Side-by-Side Duplicate Comparison

**Detailed view for exact duplicates**

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  ← Duplicate Group #1        1 of 47  ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                       ┃
┃   ┏━━━━━━━━━━━━━┓ ┏━━━━━━━━━━━━━┓   ┃
┃   ┃             ┃ ┃             ┃   ┃
┃   ┃   [IMG A]   ┃ ┃   [IMG B]   ┃   ┃ ← Side by
┃   ┃             ┃ ┃             ┃   ┃    side
┃   ┃             ┃ ┃             ┃   ┃    preview
┃   ┗━━━━━━━━━━━━━┛ ┗━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃   ┏━━━━━━━━━━━━━┓ ┏━━━━━━━━━━━━━┓   ┃
┃   ┃ ✅ ORIGINAL ┃ ┃   DUPLICATE ┃   ┃ ← Status
┃   ┣━━━━━━━━━━━━━┫ ┣━━━━━━━━━━━━━┫   ┃    badges
┃   ┃ 📦 2.4 MB   ┃ ┃ 📦 2.4 MB   ┃   ┃
┃   ┃ 📅 Jan 15   ┃ ┃ 📅 Jan 15   ┃   ┃
┃   ┃ 📁 Camera   ┃ ┃ 📁 Downloads┃   ┃ ← Album
┃   ┃ ⭐ 4032px   ┃ ┃ ⭐ 4032px   ┃   ┃    location
┃   ┗━━━━━━━━━━━━━┛ ┗━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   ┃
┃   ┃ ⚖️ Analysis                  ┃   ┃
┃   ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫   ┃
┃   ┃ • Files are byte-identical  ┃   ┃ ← Smart
┃   ┃ • Same creation date        ┃   ┃    analysis
┃   ┃ • Different albums          ┃   ┃
┃   ┃                             ┃   ┃
┃   ┃ 💡 Recommendation:          ┃   ┃
┃   ┃ Keep original in Camera,   ┃   ┃
┃   ┃ delete from Downloads       ┃   ┃
┃   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃  [Keep Both] [Keep Left] [Keep Right]┃ ← Action
┃                                       ┃    buttons
┃  [Auto-Decide for All Similar]       ┃ ← Batch
┃                                       ┃    option
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

**Smart Recommendations:**
- Original in Camera Roll → Keep
- Duplicate in Downloads → Delete
- Older file → Keep (might be edited)
- Higher quality → Keep
- In favorites → Always keep

---

## 📱 MOCKUP 5: Animated Progress View

**During scanning/processing**

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  Scanning Library...              ✕  ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                       ┃
┃           ⏳                          ┃ ← Animated
┃      [Scanning...]                   ┃    spinner
┃                                       ┃
┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   ┃
┃   ┃ ████████████░░░░░░░░░░  68% ┃   ┃ ← Progress
┃   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ┃    bar
┃                                       ┃
┃   1,247 / 1,830 photos processed     ┃ ← Counter
┃   Estimated time: 2 minutes          ┃
┃                                       ┃
┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   ┃
┃   ┃ 📊 Progress                  ┃   ┃
┃   ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫   ┃
┃   ┃ ✅ Loaded library (2.1s)     ┃   ┃ ← Activity
┃   ┃ ✅ Duplicates: 47 found      ┃   ┃    log
┃   ┃ ✅ Similar: 123 groups       ┃   ┃
┃   ┃ 🔄 Analyzing blur...         ┃   ┃ ← Current
┃   ┃ ⏸ Video scan queued          ┃   ┃    step
┃   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃   [Pause] [Run in Background]        ┃ ← Controls
┃                                       ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

**Features:**
- Real-time progress updates
- Activity log with timestamps
- Estimated completion time
- Pause/resume capability
- Background processing option

---

## 📱 MOCKUP 6: 3-Page Onboarding Carousel

### **Page 1: Problem**
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                                       ┃
┃                                       ┃
┃              📱                       ┃
┃           ⚠️  72%                    ┃ ← Large
┃                                       ┃    animated
┃                                       ┃    icon
┃     "Your phone is                   ┃
┃      almost full"                     ┃
┃                                       ┃
┃   But you don't know where           ┃
┃   all the space went...               ┃
┃                                       ┃
┃                                       ┃
┃         ● ○ ○                         ┃ ← Page dots
┃                                       ┃
┃                                       ┃
┃       [ Skip ]      [ Next → ]       ┃ ← Navigation
┃                                       ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

### **Page 2: Solution**
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                                       ┃
┃             🤖✨                      ┃
┃                                       ┃
┃     CleanOS finds and removes:       ┃
┃                                       ┃
┃   ┌─────────────────────────────┐    ┃
┃   │ 🔵 Duplicate photos         │    ┃ ← Animated
┃   │ 🟣 Similar shots            │    ┃    list with
┃   │ 🟢 Blurry images            │    ┃    fade-in
┃   │ 🟡 Old screenshots          │    ┃    effect
┃   │ 🔴 Large videos             │    ┃
┃   └─────────────────────────────┘    ┃
┃                                       ┃
┃      💡 Saves gigabytes              ┃
┃         automatically                 ┃
┃                                       ┃
┃         ○ ● ○                         ┃
┃                                       ┃
┃     [ ← Back ]     [ Next → ]        ┃
┃                                       ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

### **Page 3: Privacy**
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                                       ┃
┃             🔒                        ┃
┃                                       ┃
┃     Your photos never                ┃
┃     leave your device.                ┃
┃                                       ┃
┃   ┌─────────────────────────────┐    ┃
┃   │ ✓ 100% private              │    ┃
┃   │ ✓ No cloud upload           │    ┃
┃   │ ✓ You control everything    │    ┃
┃   │ ✓ Open source               │    ┃
┃   └─────────────────────────────┘    ┃
┃                                       ┃
┃      🌟 Trusted by 50K+ users        ┃
┃                                       ┃
┃                                       ┃
┃         ○ ○ ●                         ┃
┃                                       ┃
┃                 [ Get Started → ]    ┃ ← Large CTA
┃                                       ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

**Interactions:**
- Swipe left/right to navigate
- Auto-advance after 5 seconds
- Skip button always visible
- Page dots indicate position

---

## 📱 MOCKUP 7: Premium Paywall

**Strategic placement after first cleanup**

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                                   ✕  ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                       ┃
┃             💎✨                      ┃
┃                                       ┃
┃        Upgrade to Premium            ┃
┃                                       ┃
┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   ┃
┃   ┃ ✨ Unlimited cleanups        ┃   ┃
┃   ┃ 🤖 Advanced AI detection     ┃   ┃
┃   ┃ 🎥 Bulk video compression    ┃   ┃
┃   ┃ 📅 Automatic weekly cleanup  ┃   ┃
┃   ┃ ☁️ Cloud backup before delete┃   ┃
┃   ┃ 🎯 Priority support          ┃   ┃
┃   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   ┃
┃   ┃ 🎉 BEST VALUE - 40% OFF     ┃   ┃ ← Highlight
┃   ┃                             ┃   ┃    annual
┃   ┃  $29.99/year                ┃   ┃
┃   ┃  $2.49/month                ┃   ┃
┃   ┃                             ┃   ┃
┃   ┃  [Start Free Trial]         ┃   ┃ ← Primary CTA
┃   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   ┃
┃   ┃  $4.99/month                ┃   ┃ ← Secondary
┃   ┃  Billed monthly             ┃   ┃    option
┃   ┃                             ┃   ┃
┃   ┃  [Subscribe]                ┃   ┃
┃   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃   [ Restore Purchase ]               ┃
┃                                       ┃
┃   7-day free trial • Cancel anytime  ┃ ← Trust
┃   No commitment required              ┃    signals
┃                                       ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

**Free Tier Limits (shown after hitting limit):**
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  ⚠️ Free Limit Reached                ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                       ┃
┃   You've used 3/3 cleanups           ┃
┃   this month.                         ┃
┃                                       ┃
┃   🔄 Resets in 18 days               ┃
┃                                       ┃
┃   or                                  ┃
┃                                       ┃
┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   ┃
┃   ┃ 💎 Upgrade to Premium        ┃   ┃
┃   ┃                             ┃   ┃
┃   ┃ • Unlimited cleanups        ┃   ┃
┃   ┃ • Advanced features         ┃   ┃
┃   ┃ • No waiting                ┃   ┃
┃   ┃                             ┃   ┃
┃   ┃  [Start Free Trial]         ┃   ┃
┃   ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   ┃
┃                                       ┃
┃   [ Maybe Later ]                    ┃
┃                                       ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

---

## 🎨 ANIMATIONS & INTERACTIONS

### **1. Storage Circle Animation**
```swift
// Smooth fill animation
Circle()
    .trim(from: 0, to: storagePercentage)
    .stroke(gradient, lineWidth: 15)
    .animation(.spring(response: 1.5), value: storagePercentage)
    .rotationEffect(.degrees(-90))
```

### **2. Card Swipe Physics**
```swift
.gesture(DragGesture()
    .onChanged { value in
        offset = value.translation
        rotation = Double(offset.width / 20)
    }
    .onEnded { _ in
        if abs(offset.width) > 150 {
            withAnimation(.spring()) {
                // Swipe off screen
                offset.width = offset.width > 0 ? 500 : -500
            }
        } else {
            withAnimation(.spring()) {
                offset = .zero
                rotation = 0
            }
        }
    }
)
```

### **3. Pull-to-Refresh**
```swift
ScrollView {
    // content
}
.refreshable {
    await viewModel.refreshData()
}
```

### **4. Skeleton Loading**
```swift
RoundedRectangle(cornerRadius: 12)
    .fill(Color.gray.opacity(0.3))
    .overlay(
        Color.white.opacity(0.3)
            .mask(
                Rectangle()
                    .offset(x: shimmerOffset)
            )
    )
    .onAppear {
        withAnimation(.linear(duration: 1.5).repeatForever()) {
            shimmerOffset = 300
        }
    }
```

---

## 🎯 IMPLEMENTATION PRIORITY

### **Must-Have (MVP)**
1. ✅ Enhanced Home Dashboard with real data
2. ✅ Swipe Review with actual photos
3. ✅ Progress indicator during scan
4. ✅ Basic onboarding

### **Should-Have (V1.1)**
5. ✅ Smart Suggestions Feed
6. ✅ Side-by-side comparison
7. ✅ Premium paywall

### **Nice-to-Have (V1.2+)**
8. ✅ Advanced animations
9. ✅ Widgets
10. ✅ Share extension

---

## 💬 NEXT STEPS

Which mockup should I implement first?

**Quick wins (1-2 days each):**
- Enhanced Home Dashboard
- Swipe Review
- Progress View

**Bigger features (3-5 days each):**
- Smart Suggestions
- Comparison View
- Premium Paywall

Let me know what resonates with you! 🚀
