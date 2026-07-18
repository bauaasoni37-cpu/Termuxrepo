# Termux Custom APT Repository (`Termuxrepo`)

Yeh ek custom Debian/APT repository hai jo Termux environment ke liye banaya gaya hai. Isme aap apne `.deb` packages ko safe rakh sakte hain, organize kar sakte hain aur standard `pkg install` ya `apt install` commands ke dwara direct install kar sakte hain.

## 🚀 Features
* **One-Click Installer:** Ek simple `curl` command ke dwara kisi bhi target Termux device par repository add karein.
* **Auto Indexing:** Naya package add karne par `Packages` aur `Packages.gz` index files automatically rebuild hoti hain.
* **Metadata Extraction:** Package version, architecture aur description automatic extract hokar list ([packages.md](packages.md)) me save ho jati hai.
* **Security Friendly:** Git remote paths se tokens ko secure rakha jata hai.

---

## 📁 Repository Structure
```text
Termuxrepo/
├── Packages               # APT package index file (Auto-generated)
├── Packages.gz            # Gzipped APT package index file (Auto-generated)
├── install.sh             # Repository register karne ka universal setup script
├── packages/              # Sabhi added .deb files yahan store hoti hain
│   ├── build_1.0.0_all.deb # Build environment package (agent tool)
│   └── agy_1.0.0_all.deb  # Antigravity CLI config aur permission setup package
├── scripts/               # Repository management scripts
│   ├── auto_package.sh    # File find, deb package build, index aur push karne ka master script
│   ├── package_agy.sh     # .gemini folder ko secure 'agy' deb me package karne ka script
│   ├── add_package.sh     # Naya .deb file add karne aur repo reindex karne ka script
│   ├── reindex.py         # Packages & Packages.gz indexes generate karne ka Python script
│   └── setup_apt_source.sh # Repository ko Termux sources me register karne ka script
└── packages.md            # Added packages ki markdown list (Auto-updated)
```

## Kaise Use Karein?

### 🛠️ Method 1: Master Script ke Dwara (Sabse Aasan aur Interactive)
Naye scripts/files ko direct build karke repo me add aur push karne ke liye master script run karein:
```bash
./scripts/auto_package.sh
```
*Yeh script aapse details (Package name, filename) puchkar file ko pure system me search karegi, automatic `.deb` banayegi, index refresh karegi aur push karne ke liye pucha jayega.*

---

### 1. Repository Register Kaise Karein (Sirf Ek Baar)

**Method A: Curl ke dwara (Bina manual download kiye direct setup):**
Kisi bhi device par repository ko set karne ke liye run karein:
```bash
curl -sL https://raw.githubusercontent.com/bauaasoni37-cpu/Termuxrepo/main/install.sh | bash
```

**Method B: Local Setup (Agar files local directory me hain):**
```bash
./install.sh
```
*Yeh script automatic repository ko `Termuxrepo.list` source file me register karegi aur `pkg update` run karke database sync karegi.*

---

### 2. Naya `.deb` Package Add Karna
Naya package repository me add karne ke liye:
```bash
./scripts/add_package.sh /path/to/your/package.deb
```
*Yeh script package ko copy karegi, metadata extract karke **[packages.md](packages.md)** ko update karegi aur `Packages` index generate karegi.*

---

### 3. Package Install Kaise Karein
Jab repository successfully setup ho jaye:

**Agy (Antigravity Config) aur complete Build environment ek sath install karne ke liye:**
```bash
pkg install agy -y
```
*(Yeh command `agy` config install karegi aur iski dependency **`build`** (Agent + Flutter/Android SDK environment) ko automatically download aur install kar degi!)*

**Sirf Build environment (बिना config settings के) install karne ke liye:**
```bash
pkg install build -y
```

---

### 4. Updates Ko GitHub Par Push Karna
Jab bhi aap koi naya package add karein aur use host karna chahein, repository directory me jakar changes ko commit karke push karein:
```bash
git add .
git commit -m "Added new packages to repository"
git push origin main
```
