Here’s an enhanced and clean version of your **README.md** section for setting up a self-hosted GitHub Actions runner on macOS:

---

````md
# 🚀 Setup Self-Hosted GitHub Actions Runner (macOS)

This guide helps you set up a self-hosted GitHub Actions runner on your macOS machine.

---

## 📁 Step 1: Create a Directory

```bash
mkdir actions-runner && cd actions-runner
````

---

## ⬇️ Step 2: Download the Runner Package

> Make sure to check the [latest runner version](https://github.com/actions/runner/releases) from GitHub.

```bash
curl -o actions-runner-osx-x64-2.325.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.325.0/actions-runner-osx-x64-2.325.0.tar.gz
```

---

## ✅ Step 3: (Optional) Verify the SHA256 Checksum

```bash
echo "0562bd934b27ca0c6d8a357df00809fbc7b4d5524d4aeb6ec152e14fd520a4c3  actions-runner-osx-x64-2.325.0.tar.gz" | shasum -a 256 -c
```

---

## 📦 Step 4: Extract the Archive

```bash
tar xzf ./actions-runner-osx-x64-2.325.0.tar.gz
```

---

## ⚙️ Step 5: Configure the Runner

Get your **registration token** from your GitHub repository:

> Settings → Actions → Runners → "Add new" → Copy token and URL

```bash
./config.sh --url https://github.com/<OWNER>/<REPO> --token <REGISTRATION_TOKEN>
```

---

## ▶️ Step 6: Start the Runner

```bash
./run.sh
```

> Leave this terminal running. You can also install as a service (see below).

---

## 🛑 To Stop the Runner

```bash
./svc.sh stop
```

---

## 🔁 Optional: Run as a Service

If you want the runner to start on boot:

```bash
./svc.sh install
./svc.sh start
```

To uninstall the service:

```bash
./svc.sh stop
./svc.sh uninstall
```

---

## 🧹 Cleanup (if needed)

If you get a session conflict or want to reset:

```bash
./config.sh remove --token <REGISTRATION_TOKEN>
```

Then repeat the setup steps.

---

## 🧠 Notes

* Make sure your machine stays powered and connected to the internet.
* Use unique runner names for each machine if running multiple.
* You can monitor runner status in the repository settings under **Actions → Runners**.

---

Happy CI/CD! 🎉

```
# Install
git clone https://github.com/trax-retail/xccov2lcov.git
cd xccov2lcov

# Build the tool
swift build -c release

# Install it (choose one of these options)
# Option 1: Copy to /usr/local/bin
sudo cp .build/release/xccov2lcov /usr/local/bin/

# Option 2: Or add to your PATH
echo 'export PATH="$PATH:$(pwd)/.build/release"' >> ~/.zshrc
source ~/.zshrc

