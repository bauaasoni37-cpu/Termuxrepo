# My Custom Repo (my_custom_repo)

Yeh aapka custom Debian/APT repository hai jisme aap apne `.deb` packages ko organize, manage aur `pkg/apt install` ke dwara install kar sakte hain.

## Directory Structure
```text
my_custom_repo/
├── Packages               # APT package index file (Auto-generated)
├── Packages.gz            # Gzipped APT package index file (Auto-generated)
├── install.sh             # Repository ko install/register karne ka setup script
├── packages/              # Sabhi .deb files yahan save honge
├── scripts/               # Management helper scripts
│   ├── add_package.sh     # Naya .deb file add karne aur repo reindex karne ka script
│   ├── reindex.py         # Packages & Packages.gz indexes generate karne ka Python script
│   └── setup_apt_source.sh # Repository ko Termux sources me register karne ka script
└── packages.md            # Sabhi added packages ki markdown list (Auto-updated)
```

## Kaise Use Karein?

### 1. Repository Register Kaise Karein (Sirf Ek Baar)

**Method A: Curl ke dwara (Bina manual download kiye direct setup):**
Agar aapne is repo ko GitHub ya kisi online web server par push kiya hua hai, toh aap is command se kisi bhi Termux machine me install kar sakte hain:
```bash
curl -sL https://raw.githubusercontent.com/<YOUR_GITHUB_USERNAME>/my_custom_repo/main/install.sh | bash
```

**Method B: Local Script ke dwara:**
Agar aap is directory ke andar hain, toh:
```bash
./install.sh
```
*Yeh script automatic repository ko `my_custom_repo.list` source file me register karegi aur `pkg update` run karke database refresh kar degi.*

### 2. Naya Package Add Karna
Naya `.deb` package add karne ke liye:
```bash
./scripts/add_package.sh /path/to/your/package.deb
```
*Yeh script automatic package ko `packages/` directory me copy karega, markdown index update karega aur `Packages` & `Packages.gz` repo indexes rebuild karega.*

### 3. Package Install Karna
Ek baar jab package add ho jaye aur repo sources update ho jayein, toh aap use normal package ki tarah direct install kar sakte hain:
```bash
pkg install build -y
# ya
apt install build -y
```
*(Aap kisi bhi added package ko name se install kar payenge!)*
