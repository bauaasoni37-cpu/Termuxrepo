<div align="center">
  <a href="https://bauaasoni37-cpu.github.io/Termuxrepo/">
    <img alt="Termuxrepo" height="180" src="img/termuxrepo_logo.jpg" style="border-radius: 90px; box-shadow: 0 4px 20px rgba(99, 102, 241, 0.4);">
    <h1>Termuxrepo APT Repository</h1>
  </a>
  <p><b>🔓 Custom Debian/APT Repository for Termux Environment</b></p>

  <div>
    <a href="https://github.com/bauaasoni37-cpu/Termuxrepo/stargazers">
      <img src="https://img.shields.io/github/stars/bauaasoni37-cpu/Termuxrepo?style=for-the-badge&logo=github&color=ffd700&labelColor=0d1117" alt="GitHub Stars">
    </a>
    <a href="https://github.com/bauaasoni37-cpu/Termuxrepo/blob/main/LICENSE">
      <img src="https://img.shields.io/badge/License-BSD_3--Clause-blue?style=for-the-badge&logo=opensourceinitiative" alt="License">
    </a>
    <a href="https://github.com/bauaasoni37-cpu/Termuxrepo/issues">
      <img src="https://img.shields.io/github/issues/bauaasoni37-cpu/Termuxrepo?style=for-the-badge&logo=github&color=orange&labelColor=0d1117" alt="GitHub Issues">
    </a>
  </div>
</div>

## 📖 Table of Contents

- [Project Overview](#-project-overview)
- [Prerequisites](#-prerequisites)
- [Quick Installation](#-quick-installation)
- [Featured Packages](#-featured-packages)
- [Why Open Source?](#-why-open-source)
- [Repository Structure](#-repository-structure)
- [Frequently Asked Questions](#-frequently-asked-questions)

---

## 📋 Prerequisites

Before using Termuxrepo, ensure your environment meets these requirements:

- **Termux** installed on your Android device (Android 7+)
- **Working internet connection** to add the repository and download packages
- **No root required** to install or run any of these packages

---

## 🔍 Project Overview

**Termuxrepo** is a custom Debian/APT repository tailored specifically for the Termux environment. It provides a secure, lightweight, and structured setup to index and host custom `.deb` packages.

This repository allows you to easily register and install specialized tools (such as build environments and Antigravity configs) using the standard `pkg install` or `apt install` workflow.

> [!NOTE]
> All packages in this repository are compiled natively and index automatically. Whenever a package is updated, repository index metadata is updated on-the-fly.

---

## 🚀 Quick Installation

Adding Termuxrepo to your system is extremely seamless. Just run the following one-liner curl command in your Termux shell:

```bash
# Add custom repository
curl -sL https://raw.githubusercontent.com/bauaasoni37-cpu/Termuxrepo/main/install.sh | bash
```

Once successfully installed, update your package lists and install any package:

```bash
# Update APT source database
pkg update

# Install agy configuration package
pkg install agy -y
```

> [!TIP]
> After setting up, you can search for packages inside this repository using `pkg search <package-name>`.

---

## ✨ Featured Packages

We host custom packages compiled to make your development lifecycle smoother:

<div align="center">

| Package | Version | Description |
| :--- | :--- | :--- |
| **agy** | `1.0.0` | Antigravity CLI config and auto-approved command permissions setup. |
| **build** | `1.0.0` | Build environment and compilation tools setup. |

</div>

---

## 🔍 Why Open Source?

Security is paramount. We believe you should see exactly what runs on your environment before running it. 
* All repository configurations are completely open-source.
* Scripts used for indexing, packaging (`scripts/`), and setups are transparent.
* Easily customizable for creating your own package repository.

---

## 📁 Repository Structure

```text
Termuxrepo/
├── index.html             # Premium repository landing page (GitHub Pages)
├── Packages               # APT package index file (Auto-generated)
├── Packages.gz            # Gzipped APT package index file (Auto-generated)
├── install.sh             # Repository register setup script
├── packages/              # Subdirectory containing all hosted .deb files
│   ├── build_1.0.0_all.deb
│   └── agy_1.0.0_all.deb
├── scripts/               # Management scripts for packaging and indexing
└── packages.md            # Auto-updated list of all hosted packages
```

---

## 💬 Frequently Asked Questions

#### Q: Is root access required?
A: No! You don't need root access to add this repository or install its packages.

#### Q: How can I host my own packages here?
A: Put your `.deb` files in `packages/` directory and run `./scripts/auto_package.sh` to package, index, and prepare updates for pushing.
